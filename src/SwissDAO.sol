// SPDX-License-Identifier: Proprietary
pragma solidity ^0.8.18;

import { AccessControl } from "@oz/access/AccessControl.sol";
import { ERC1155 } from "@oz/token/ERC1155/ERC1155.sol";
import { Base64 } from "@oz/utils/Base64.sol";
import { LibString } from "@solady/utils/LibString.sol";

contract SwissDAO is ERC1155, AccessControl {
    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/

    /// @notice This error is thrown when a token is intended to be transferred
    error SwissDAO_SoulboundTokenError();

    /// @notice Thrown if account already has membership
    error SwissDAO__YouAlreadyAreMember();

    /*//////////////////////////////////////////////////////////////
                              CONSTANTS
    //////////////////////////////////////////////////////////////*/

    /// @notice Collection name
    string public name;

    /// @notice EXPERIENCE_POINTS, ACTIVITY_POINTS and ATTENDED_EVENTS tokens have the ids 1, 2 and 3, all membership NFT tokens inherit their id from their owners address.
    uint256 public constant EXPERIENCE_POINTS = 1;

    /// @notice EXPERIENCE_POINTS, ACTIVITY_POINTS and ATTENDED_EVENTS tokens have the ids 1, 2 and 3, all membership NFT tokens inherit their id from their owners address.
    uint256 public constant ACTIVITY_POINTS = 2;

    /// @notice EXPERIENCE_POINTS, ACTIVITY_POINTS and ATTENDED_EVENTS tokens have the ids 1, 2 and 3, all membership NFT tokens inherit their id from their owners address.
    uint256 public constant ATTENDED_EVENTS = 3;

    /// @notice Explain to a developer any extra details
    bytes32 public constant CORE_DELEGATE_ROLE = keccak256("CORE_DELEGATE_ROLE");

    /// @notice Explain to a developer any extra details
    bytes32 public constant COMMUNITY_MANAGER_ROLE = keccak256("COMMUNITY_MANAGER_ROLE");

    /// @notice Explain to a developer any extra details
    bytes32 public constant EVENT_MANAGER_ROLE = keccak256("EVENT_MANAGER_ROLE");

    /// @notice Explain to a developer any extra details
    bytes32 public constant PROJECT_MANAGER_ROLE = keccak256("PROJECT_MANAGER_ROLE");

    /// @notice Explain to a developer any extra details
    bytes32 public constant TREASURY_MANAGER_ROLE = keccak256("TREASURY_MANAGER_ROLE");

    /// @notice Explain to a developer any extra details
    bytes32 public constant DEVELOPER_ROLE = keccak256("DEVELOPER_ROLE");

    /// @notice Explain to a developer any extra details
    bytes32 public constant COMMUNITY_MEMBER_ROLE = keccak256("COMMUNITY_MEMBER_ROLE");

    /// @dev Animated NFT URI
    string private constant ANIMATION_TOKEN_URI_PREFIX = "https://owieth-website-app.vercel.app/members/";

    /*//////////////////////////////////////////////////////////////
                                STRUCTS
    //////////////////////////////////////////////////////////////*/

    /// @dev Struct that contains vital information
    ///      timestamp: Minted Timestamp
    struct MemberStruct {
        string nickname;
        uint256 joinedAt;
        string profileImageUri;
    }

    /*//////////////////////////////////////////////////////////////
                              STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @dev swissDAO members Look Up Table
    address[] public s_members;

    /// @dev Mapping from member addresses to memberStructs
    mapping(address member => MemberStruct) private s_memberStructs;

    uint256 _lastAPDecreaseTimestamp;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /// @notice Explain to a developer any extra details
    /// @dev Explain to a developer any extra details
    constructor(address _defaultAdminRoler, address _coreDelegateRoler) ERC1155("") {
        name = "swissDAO";
        _setRoleAdmin(CORE_DELEGATE_ROLE, DEFAULT_ADMIN_ROLE); // Only the swissDAO multisig wallet can grant the core delegate role/guild.
        _setRoleAdmin(COMMUNITY_MANAGER_ROLE, CORE_DELEGATE_ROLE); // Only core delegates can assign roles/guilds.
        _setRoleAdmin(EVENT_MANAGER_ROLE, CORE_DELEGATE_ROLE); // Only core delegates can assign roles/guilds.
        _setRoleAdmin(PROJECT_MANAGER_ROLE, CORE_DELEGATE_ROLE); // Only core delegates can assign roles/guilds.
        _setRoleAdmin(TREASURY_MANAGER_ROLE, CORE_DELEGATE_ROLE); // Only core delegates can assign roles/guilds.
        _setRoleAdmin(DEVELOPER_ROLE, CORE_DELEGATE_ROLE); // Only core delegates can assign roles/guilds.
        _setRoleAdmin(COMMUNITY_MEMBER_ROLE, CORE_DELEGATE_ROLE); // Only core delegates can assign roles/guilds.

        _grantRole(DEFAULT_ADMIN_ROLE, _defaultAdminRoler); // swissDAO mutlisig wallet address
        _grantRole(CORE_DELEGATE_ROLE, _coreDelegateRoler); // swissDAO mutlisig wallet address

        _lastAPDecreaseTimestamp = block.timestamp;
    }

    /*//////////////////////////////////////////////////////////////
                             MODIFIERS
    //////////////////////////////////////////////////////////////*/

    modifier onlyDefaultAdminOrCoreDelegateOrCommunityManager {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || hasRole(CORE_DELEGATE_ROLE, msg.sender) || hasRole(COMMUNITY_MANAGER_ROLE, msg.sender), "Only DEFAULT_ADMIN or CORE_DELEGATE or COMMUNITY_MANAGER can call this function.");
        _;
    }

    modifier onlyDefaultAdminOrCoreDelegateOrEventManager {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || hasRole(CORE_DELEGATE_ROLE, msg.sender) || hasRole(EVENT_MANAGER_ROLE, msg.sender), "Only DEFAULT_ADMIN or CORE_DELEGATE or EVENT_MANAGER can call this function.");
        _;
    }

    /*//////////////////////////////////////////////////////////////
                               PUBLIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Explain to a developer any extra details
    /// @dev Explain to a developer any extra details
    /// @param _tokenid Sender's Address
    function uri(uint256 _tokenid) public view override returns (string memory) {
        bytes memory _svg;
        string memory _name;
        string memory _description;
        string memory _animation_url;
        string memory _attributes;

        if (_tokenid == 1) {
            _svg = abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="visual" viewBox="0 0 1000 1000" width="1000" height="1000" version="1.1"><rect x="0" y="0" width="1000" height="1000" fill="#001122"/><path d="M0 838L143 716L286 631L429 765L571 726L714 745L857 760L1000 652L1000 1001L857 1001L714 1001L571 1001L429 1001L286 1001L143 1001L0 1001Z" fill="#C62368" stroke-linecap="square" stroke-linejoin="bevel"/><text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="500" letter-spacing="-0.04em" x="200" y="600">XP</text></svg>'
            );
            _name = "XP";
            _description = "Experience Point";
            _animation_url = "";
            _attributes = "[]";
        } else if (_tokenid == 2) {
            _svg = abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="visual" viewBox="0 0 1000 1000" width="1000" height="1000" version="1.1"><rect x="0" y="0" width="1000" height="1000" fill="#001122"/><path d="M0 838L143 716L286 631L429 765L571 726L714 745L857 760L1000 652L1000 1001L857 1001L714 1001L571 1001L429 1001L286 1001L143 1001L0 1001Z" fill="#C62368" stroke-linecap="square" stroke-linejoin="bevel"/><text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="500" letter-spacing="-0.04em" x="200" y="600">AP</text></svg>'
            );
            _name = "AP";
            _description = "Activity Point";
            _animation_url = "";
            _attributes = "[]";
        } else if (_tokenid == 3) {
            _svg = abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="visual" viewBox="0 0 1000 1000" width="1000" height="1000" version="1.1"><rect x="0" y="0" width="1000" height="1000" fill="#001122"/><path d="M0 838L143 716L286 631L429 765L571 726L714 745L857 760L1000 652L1000 1001L857 1001L714 1001L571 1001L429 1001L286 1001L143 1001L0 1001Z" fill="#C62368" stroke-linecap="square" stroke-linejoin="bevel"/><text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="160" letter-spacing="-0.04em" x="200" y="500">EVENTS</text></svg>'
            );
            _name = "EVENTS";
            _description = "Attended Events";
        } else {
            address member = address(uint160(_tokenid)); // membership NFT tokens inherit their id from their owners address
            string memory xp = LibString.toString(balanceOf(member, EXPERIENCE_POINTS));
            string memory ap = LibString.toString(balanceOf(member, ACTIVITY_POINTS));
            string memory ae = LibString.toString(balanceOf(member, ATTENDED_EVENTS));
            // bool hasDeveloperRole = hasRole(DEVELOPER_ROLE, member); // add later
            // bool hasProjectManagerRole = hasRole(PROJECT_MANAGER_ROLE, member); // add later
            // uint256 joinedAt = LibString.toHexString(s_memberStructs[member].joinedAt); // add later
            // string profileImageUri s_memberStructs[member].profileImageUri; // add later

            _svg = abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" width="1000" height="1000" fill="#1E1E1E" stroke="#ffffff"> <rect width="1000" height="1000" fill="#1E1E1E" /><rect x="75.5" y="140.5" width="349" height="219" rx="11.5" fill="black" stroke="white" />',
                '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="24" letter-spacing="-0.04em"><tspan x="104" y="187">Holder</tspan></text>',
                '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="24" letter-spacing="-0.04em"><tspan x="250" y="187">',
                LibString.toHexString(member),
                "</tspan></text>",
                '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="24" letter-spacing="-0.04em"><tspan x="104" y="225">AP</tspan></text>',
                '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="24" letter-spacing="-0.04em"><tspan x="250" y="225">',
                ap,
                "</tspan></text>",
                '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="24" letter-spacing="-0.04em"><tspan x="104" y="265">XP</tspan></text>',
                '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="24" letter-spacing="-0.04em"><tspan x="250" y="265">',
                xp,
                "</tspan></text></svg>"
            );

            _name = s_memberStructs[member].nickname;
            _description = "swissDAO Membership";
            _animation_url = string.concat(ANIMATION_TOKEN_URI_PREFIX, LibString.toHexString(member), "/preview");
            _attributes = string(
                abi.encodePacked(
                    '[{ "trait_type": "Experience Points", "value": "',
                    xp,
                    ' "}, { "trait_type": "Activity Points", "value": "',
                    ap,
                    '"}, { "trait_type": "Attended Events", "value": "',
                    ae,
                    '"}]'
                )
            );
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
        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(_metadata)));
    }

    /// This function increases points for a specified member by a specified ammount. Only core delegates or community manegers can increase experience points.
    function increasePoints(address member, uint256 amount) onlyDefaultAdminOrCoreDelegateOrCommunityManager public {
        _mint(member, EXPERIENCE_POINTS, amount, "");
        uint256 maxTopUp = 100 - balanceOf(member, ACTIVITY_POINTS); // Activity Points have a ceiling of 100
        uint256 topUp = amount <= maxTopUp ? amount : maxTopUp;
        if (topUp != 0) {
            _mint(member, ACTIVITY_POINTS, topUp, "");
        }
    }

    /// This function decreases activity points for all members by one. Only core delegates or community manegers can increase experience points.
    function decreaseActivityPoints() public {
        // Check blocktime maturity
        require((block.timestamp >= _lastAPDecreaseTimestamp + 1 weeks), "Please wait till one week since the last call of decreaseActivityPoints() has passed.");

        for (uint256 i = 0; i < s_members.length;) {
            if (balanceOf(s_members[i], ACTIVITY_POINTS) > 0) {
                _burn(s_members[i], ACTIVITY_POINTS, 1);
            }
            unchecked {
                ++i;
            }
        }
        _lastAPDecreaseTimestamp=block.timestamp;
    }

    /// This function onboards a new member. Only core delegates or event manegers can onboard members.
    function onboard(address member, string memory nickname, string memory profileImageUri) onlyDefaultAdminOrCoreDelegateOrEventManager public {
        uint256 membershipId = uint256(uint160(member));

        // Check if member is not already onboarded
        if (balanceOf(member, membershipId) == 1) {
            revert SwissDAO__YouAlreadyAreMember();
        }

        s_members.push(member);
        _mint(member, EXPERIENCE_POINTS, 1, "");
        _mint(member, ACTIVITY_POINTS, 1, "");
        _mint(member, membershipId, 1, "");
        _grantRole(COMMUNITY_MEMBER_ROLE, member);
        s_memberStructs[member].nickname = nickname;
        s_memberStructs[member].joinedAt = block.timestamp;
        s_memberStructs[member].profileImageUri = profileImageUri;
    }

    /// This function returns the number of onboarded members.
    function numberOfMembers() public view returns (uint256) {
        return s_members.length;
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
            revert SwissDAO_SoulboundTokenError();
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
