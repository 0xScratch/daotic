// SPDX-License-Identifier: Proprietary
pragma solidity ^0.8.18;

import { AccessControl } from "@oz/access/AccessControl.sol";
import { ERC1155 } from "@oz/token/ERC1155/ERC1155.sol";
import { LibString } from "@solady/utils/LibString.sol";
import { Base64 } from "@oz/utils/Base64.sol";

contract SwissDAO is ERC1155, AccessControl {
    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/

    /// @notice This error is thrown when a token is intended to be transferred
    error SwissDAO__SoulboundTokenError();

    /// @notice This error is thrown when a member does not have the required role for calling a function
    error SwissDAO__PermissionError();

    /// @notice Thrown if account already has membership
    error SwissDAO__YouAlreadyAreMember();

    /// @notice Freezed
    error SwissDAO__FreezedBeforeAttending3Events();

    /// @notice Freezed
    error SwissDAO__FreezedBeforePassingContributorQuest();

    /// @notice Contributor onboarding quest
    error SwissDAO__WrongAnswer();

    /*//////////////////////////////////////////////////////////////
                              CONSTANTS
    //////////////////////////////////////////////////////////////*/

    // XPERIENCE_POINTS, ACTIVITY_POINTS and ATTENDED_EVENTS tokens have the ids 1, 2 and 3
    // Guild badges have the ids from 100 till 109
    // Memberships cards start with the id 10000
    // AccessControl's roles are used for direct contract permissions

    uint256 public constant EXPERIENCE_POINTS = 1;
    uint256 public constant ACTIVITY_POINTS = 2;
    uint256 public constant ATTENDED_EVENTS = 3;

    uint256 public constant CORE_DELEGATE_GUILD_BADGE = 100;
    uint256 public constant PARTNERSHIPS_GUILD_BADGE = 101;
    uint256 public constant DEV_GUILD_BADGE = 102;
    uint256 public constant EVENT_GUILD_BADGE = 103;
    uint256 public constant MEDIA_GUILD_BADGE = 104;
    uint256 public constant DESIGN_GUILD_BADGE = 105;
    uint256 public constant COMMUNITY_GUILD_BADGE = 106;
    uint256 public constant PROJECT_GUILD_BADGE = 107;
    uint256 public constant EDUCATION_GUILD_BADGE = 108;
    uint256 public constant TREASURY_GUILD_BADGE = 109;

    /*//////////////////////////////////////////////////////////////
                                STRUCTS
    //////////////////////////////////////////////////////////////*/

    /// @dev Struct that contains vital information
    struct MembershipStruct {
        string nickname;
        uint256 joinedAt;
        string profileImageUri;
    }

    /*//////////////////////////////////////////////////////////////
                              STORAGE
    //////////////////////////////////////////////////////////////*/

    // The mapping from token ID to account balances (who ownes how much of which token) is defined in the parent contract ERC1155 as
    // mapping(uint256 => mapping(address => uint256)) private _balances;

    // XPERIENCE_POINTS, ACTIVITY_POINTS and ATTENDED_EVENTS tokens have the ids 1, 2 and 3
    // Guild badges have the ids from 100 till 109, max one per guild per address
    // Memberships cards start with the id 10000, max one membership per address

    /// @dev swissDAO members Look Up Table
    address[] private s_members;

    // /// @dev Mapping from member addresses to membershipIDs
    // mapping(address => uint256) private s_membershipIDs;

    /// @dev Mapping from member addresses to membershipStructs
    mapping(address => MembershipStruct) private s_memberships;

    uint256 private s_lastAPDecreaseTimestamp;

    uint256 private s_membershipIdsCounter = 10_000;

    string private s_uri = "https://owieth-website-app.vercel.app/api/metadata/";

    /*//////////////////////////////////////////////////////////////
                             MODIFIERS
    //////////////////////////////////////////////////////////////*/

    modifier onlyDefaultAdminOrCoreDelegateOrCommunity() {
        // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || balanceOf(msg.sender, CORE_DELEGATE_GUILD_BADGE)==1 || balanceOf(msg.sender, COMMUNITY_GUILD_BADGE)==1, "SwissDAO PermissionError");
        if (
            !hasRole(DEFAULT_ADMIN_ROLE, msg.sender) && balanceOf(msg.sender, CORE_DELEGATE_GUILD_BADGE) == 0
                && balanceOf(msg.sender, COMMUNITY_GUILD_BADGE) == 0
        ) {
            revert SwissDAO__PermissionError();
        }
        _;
    }

    modifier onlyDefaultAdminOrCoreDelegateOrEvent() {
        if (
            !hasRole(DEFAULT_ADMIN_ROLE, msg.sender) && balanceOf(msg.sender, CORE_DELEGATE_GUILD_BADGE) == 0
                && balanceOf(msg.sender, EVENT_GUILD_BADGE) == 0
        ) {
            revert SwissDAO__PermissionError();
        }
        _;
    }

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /// @notice Explain to a developer any extra details
    /// @dev Explain to a developer any extra details
    constructor(address _defaultAdminRoler, address _coreDelegateRoler) ERC1155("") {
        _grantRole(DEFAULT_ADMIN_ROLE, _defaultAdminRoler); // swissDAO mutlisig wallet address
        _mint(_coreDelegateRoler, CORE_DELEGATE_GUILD_BADGE, 1, "");
        s_lastAPDecreaseTimestamp = block.timestamp;
    }

    /*//////////////////////////////////////////////////////////////
                                EXTERNAL
    //////////////////////////////////////////////////////////////*/

    /// Call this function if someone attended an event for the first time. This also mints the first ATTENDED_EVENTS token. Only core delegates or event guild can confirm attendance and onboard members.
    function onboard(
        address member,
        string memory nickname,
        string memory profileImageUri
    )
        external
        onlyDefaultAdminOrCoreDelegateOrEvent
    {
        uint256 _membersArrayLength = s_members.length;

        // Loop through the member array and check if it already includes this member address.
        for (uint256 i; i < _membersArrayLength;) {
            if (s_members[i] == member) {
                revert SwissDAO__YouAlreadyAreMember();
            }

            unchecked {
                ++i;
            }
        }

        _mint(member, s_membershipIdsCounter, 1, ""); // this is the official mapping of the parent ERC1155 contract
        attended(member);
        s_members.push(member);
        s_memberships[member].nickname = nickname;
        s_memberships[member].joinedAt = block.timestamp;
        s_memberships[member].profileImageUri = profileImageUri;

        ++s_membershipIdsCounter;
    }

    /// What is the short name of the token representing your voting power? The code is published so you can see the correct answer here.
    function takeContributorQuest(address member, string memory answer) external {
        if (msg.sender != member) {
            revert SwissDAO__PermissionError(); // Individual task! Do it yourself.
        }

        if (balanceOf(member, ATTENDED_EVENTS) < 3) {
            revert SwissDAO__FreezedBeforeAttending3Events();
        }

        if (keccak256(abi.encodePacked(answer)) != keccak256(abi.encodePacked("AP"))) {
            revert SwissDAO__WrongAnswer();
        }

        _mint(member, EXPERIENCE_POINTS, 1, ""); // passing the contributor quest mints the first XP and so unlocks collecting points
    }

    /// This function increases points for a specified member by a specified ammount. Only core delegates or community guild can increase points and only after the member passed the contributor quest.
    function increasePoints(address member, uint256 amount) external onlyDefaultAdminOrCoreDelegateOrCommunity {
        if (balanceOf(member, EXPERIENCE_POINTS) == 0) {
            revert SwissDAO__FreezedBeforePassingContributorQuest();
        }

        _mint(member, EXPERIENCE_POINTS, amount, "");
        uint256 maxTopUp = 100 - balanceOf(member, ACTIVITY_POINTS); // Activity Points have a ceiling of 100
        uint256 topUp = amount <= maxTopUp ? amount : maxTopUp;

        if (topUp != 0) {
            _mint(member, ACTIVITY_POINTS, topUp, "");
        }
    }

    /// This function decreases activity points for all members by one. Only core delegates or community manegers can increase experience points.
    function decreaseActivityPoints() external {
        // Check blocktime maturity
        require(
            (block.timestamp >= s_lastAPDecreaseTimestamp + 1 weeks),
            "Please wait till one week since the last call of decreaseActivityPoints() has passed."
        );

        uint256 _membersArrayLength = s_members.length;

        for (uint256 i = 0; i < _membersArrayLength;) {
            if (balanceOf(s_members[i], ACTIVITY_POINTS) > 0) {
                _burn(s_members[i], ACTIVITY_POINTS, 1);
            }

            unchecked {
                ++i;
            }
        }

        s_lastAPDecreaseTimestamp = block.timestamp;
    }

    /// This function returns the number of onboarded members.
    function numberOfMembers() external view returns (uint256) {
        return s_members.length;
    }

    /// @notice Get function for tokenstruct of tokenid
    /// @return TokenStruct
    function getMembershipStructByHolder(address _holder) external view returns (MembershipStruct memory) {
        return s_memberships[_holder];
    }

    /*//////////////////////////////////////////////////////////////
                               PUBLIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Explain to a developer any extra details
    /// @dev Explain to a developer any extra details
    /// @param _tokenId TokenId
    function uri(uint256 _tokenId) public view override returns (string memory) {
        bytes memory _svg;
        string memory _name;
        string memory _description;
        string memory _animation_url;
        string memory _attributes;

        if (_tokenId == 1) {
            _svg = abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="visual" viewBox="0 0 1000 1000" width="1000" height="1000" version="1.1"><rect x="0" y="0" width="1000" height="1000" fill="#001122"/><path d="M0 838L143 716L286 631L429 765L571 726L714 745L857 760L1000 652L1000 1001L857 1001L714 1001L571 1001L429 1001L286 1001L143 1001L0 1001Z" fill="#C62368" stroke-linecap="square" stroke-linejoin="bevel"/><text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="500" letter-spacing="-0.04em" x="200" y="600">XP</text></svg>'
            );
            _name = "XP";
            _description = "Experience Point";
            _attributes = "[]";
        } else if (_tokenId == 2) {
            _svg = abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="visual" viewBox="0 0 1000 1000" width="1000" height="1000" version="1.1"><rect x="0" y="0" width="1000" height="1000" fill="#001122"/><path d="M0 838L143 716L286 631L429 765L571 726L714 745L857 760L1000 652L1000 1001L857 1001L714 1001L571 1001L429 1001L286 1001L143 1001L0 1001Z" fill="#C62368" stroke-linecap="square" stroke-linejoin="bevel"/><text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="500" letter-spacing="-0.04em" x="200" y="600">AP</text></svg>'
            );
            _name = "AP";
            _description = "Activity Point";
            _attributes = "[]";
        } else if (_tokenId == 3) {
            _svg = abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="visual" viewBox="0 0 1000 1000" width="1000" height="1000" version="1.1"><rect x="0" y="0" width="1000" height="1000" fill="#001122"/><path d="M0 838L143 716L286 631L429 765L571 726L714 745L857 760L1000 652L1000 1001L857 1001L714 1001L571 1001L429 1001L286 1001L143 1001L0 1001Z" fill="#C62368" stroke-linecap="square" stroke-linejoin="bevel"/><text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="160" letter-spacing="-0.04em" x="200" y="500">EVENTS</text></svg>'
            );
            _name = "EVENTS";
            _description = "Attended Events";
            _attributes = "[]";
        }

        bytes memory _metadata = abi.encodePacked(
            "{",
            '"name": "',
            _name,
            '", ',
            '"description": "',
            _description,
            '", ',
            '"image": ',
            '"data:image/svg+xml;base64,',
            Base64.encode(_svg),
            '",',
            '"animation_url": "',
            _animation_url,
            '", ',
            '"attributes": ',
            _attributes,
            "}"
        );

        if (_tokenId == 1 || _tokenId == 2 || _tokenId == 3) {
            return string(abi.encodePacked("data:application/json;base64,", Base64.encode(_metadata)));
        } else {
            return LibString.concat(s_uri, LibString.toString(_tokenId));
        }
    }

    /// This function confirm attendance of a member. Only core delegates or event guild can confirm attendance.
    function attended(address member) public onlyDefaultAdminOrCoreDelegateOrEvent {
        _mint(member, ATTENDED_EVENTS, 1, "");
    }

    /*//////////////////////////////////////////////////////////////
                               INTERNAL
    //////////////////////////////////////////////////////////////*/

    /// @notice Explain to a developer any extra details
    /// @dev Explain to a developer any extra details
    /// @param _operator Address
    /// @param _from Address
    /// @param _to Address
    /// @param _ids Uint256[]
    /// @param _amounts Uint256[]
    /// @param _data Bytes
    function _beforeTokenTransfer(
        address _operator,
        address _from,
        address _to,
        uint256[] memory _ids,
        uint256[] memory _amounts,
        bytes memory _data
    )
        internal
        override(ERC1155)
    {
        if (_from != address(0) && _to != address(0)) {
            revert SwissDAO__SoulboundTokenError();
        }

        super._beforeTokenTransfer(_operator, _from, _to, _ids, _amounts, _data);
    }

    /// @notice Explain to a developer any extra details
    /// @dev Explain to a developer any extra details
    /// @param _interfaceId Address
    function supportsInterface(bytes4 _interfaceId) public view override(ERC1155, AccessControl) returns (bool) {
        return super.supportsInterface(_interfaceId);
    }

    /*//////////////////////////////////////////////////////////////
                               TERMINATION
    //////////////////////////////////////////////////////////////*/

    function destroy(address apocalypse) public onlyRole(DEFAULT_ADMIN_ROLE) {
        selfdestruct(payable(apocalypse));
    }
}
