// SPDX-License-Identifier: Proprietary
pragma solidity ^0.8.18;

import { AccessControl } from "@oz/access/AccessControl.sol";
import { ERC1155 } from "@oz/token/ERC1155/ERC1155.sol";
import { Strings } from "@oz/utils/Strings.sol";
import { Base64 } from "@oz/utils/Base64.sol";

contract SwissDAO is ERC1155, AccessControl {
    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/

    /// @notice This error is thrown when a token is intended to be transferred
    error SwissDAO_SoulboundTokenError();

    /// @notice This error is thrown when a member does not have the required role for calling a function
    error SwissDAO_PermissionError();

    /// @notice This error is thrown when minting the Membership NFT for already onboarded member
    error SwissDAO_OnboardingError();

    /*//////////////////////////////////////////////////////////////
                              CONSTANTS
    //////////////////////////////////////////////////////////////*/

    /// @notice EXPERIENCE_POINTS tokens have the id 1, ACTIVITY_POINTS tokens have the id 2, all membership NFT tokens inherit their id from their owners address.
    uint256 public constant EXPERIENCE_POINTS = 1;

    /// @notice EXPERIENCE_POINTS tokens have the id 1, ACTIVITY_POINTS tokens have the id 2, all membership NFT tokens inherit their id from their owners address.
    uint256 public constant ACTIVITY_POINTS = 2;

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

    /*//////////////////////////////////////////////////////////////
                              LOOK UP TABLES
    //////////////////////////////////////////////////////////////*/

    address[] public membersLUP;
    function numberOfMembers() public view returns (uint) {
        return membersLUP.length;
    }

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /// @notice Explain to a developer any extra details
    /// @dev Explain to a developer any extra details
    constructor(
        address _defaultAdminRoler,
        address _coreDelegateRoler
    )
        ERC1155("https://swissdao.space/api/item/{id}.json")
    {
        _setRoleAdmin(CORE_DELEGATE_ROLE, DEFAULT_ADMIN_ROLE); // Only the swissDAO multisig wallet can grant the core delegate role/guild.
        _setRoleAdmin(COMMUNITY_MANAGER_ROLE, CORE_DELEGATE_ROLE); // Only core delegates can assign roles/guilds.
        _setRoleAdmin(EVENT_MANAGER_ROLE, CORE_DELEGATE_ROLE); // Only core delegates can assign roles/guilds.
        _setRoleAdmin(PROJECT_MANAGER_ROLE, CORE_DELEGATE_ROLE); // Only core delegates can assign roles/guilds.
        _setRoleAdmin(TREASURY_MANAGER_ROLE, CORE_DELEGATE_ROLE); // Only core delegates can assign roles/guilds.
        _setRoleAdmin(DEVELOPER_ROLE, CORE_DELEGATE_ROLE); // Only core delegates can assign roles/guilds.
        _setRoleAdmin(COMMUNITY_MEMBER_ROLE, CORE_DELEGATE_ROLE); // Only core delegates can assign roles/guilds.

        _grantRole(DEFAULT_ADMIN_ROLE, _defaultAdminRoler); // swissDAO mutlisig wallet address
        _grantRole(CORE_DELEGATE_ROLE, _coreDelegateRoler); // swissDAO mutlisig wallet address
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

        if(_tokenid == 1) {
            _svg = abi.encodePacked('<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="visual" viewBox="0 0 1000 1000" width="1000" height="1000" version="1.1"><rect x="0" y="0" width="1000" height="1000" fill="#001122"/><path d="M0 838L143 716L286 631L429 765L571 726L714 745L857 760L1000 652L1000 1001L857 1001L714 1001L571 1001L429 1001L286 1001L143 1001L0 1001Z" fill="#C62368" stroke-linecap="square" stroke-linejoin="bevel"/><text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="500" letter-spacing="-0.04em" x="200" y="600">XP</text></svg>');
            _name = "XP";
            _description = "Experience Point";
        }else if(_tokenid == 2) {
            _svg = abi.encodePacked('<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="visual" viewBox="0 0 1000 1000" width="1000" height="1000" version="1.1"><rect x="0" y="0" width="1000" height="1000" fill="#001122"/><path d="M0 838L143 716L286 631L429 765L571 726L714 745L857 760L1000 652L1000 1001L857 1001L714 1001L571 1001L429 1001L286 1001L143 1001L0 1001Z" fill="#C62368" stroke-linecap="square" stroke-linejoin="bevel"/><text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="500" letter-spacing="-0.04em" x="200" y="600">AP</text></svg>');
            _name = "AP";
            _description = "Activity Point";
        }else{
            address member = address(uint160(_tokenid)); // membership NFT tokens inherit their id from their owners address
            uint256 xp = balanceOf(member, 1);
            uint256 ap = balanceOf(member, 2);
            // bool hasDeveloperRole = hasRole(DEVELOPER_ROLE, member);
            // bool hasProjectManagerRole = hasRole(PROJECT_MANAGER_ROLE, member);

            _svg = abi.encodePacked(
            '<svg ',
                'xmlns="http://www.w3.org/2000/svg" ',
                'width="1000" ',
                'height="1000" ',
                'fill="#1E1E1E" ',
                'stroke="#ffffff"',
            '>',
                '<rect width="1000" height="1000" fill="#1E1E1E" />',
                '<rect x="75.5" y="140.5" width="349" height="219" rx="11.5" fill="black" stroke="white" />',
                '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="24" letter-spacing="-0.04em">', '<tspan x="104" y="187">', "Holder", "</tspan></text>",
                '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="24" letter-spacing="-0.04em">', '<tspan x="250" y="187">', Strings.toHexString(member), "</tspan></text>",
                '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="24" letter-spacing="-0.04em">', '<tspan x="104" y="225">', "AP", "</tspan></text>",
                '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="24" letter-spacing="-0.04em">', '<tspan x="250" y="225">', Strings.toString(ap), "</tspan></text>",
                '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="24" letter-spacing="-0.04em">', '<tspan x="104" y="265">', "XP", "</tspan></text>",
                '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="24" letter-spacing="-0.04em">', '<tspan x="250" y="265">', Strings.toString(xp), "</tspan></text>",
            '</svg>'
            );
            
            _name = "Membership";
            _description = "swissDAO Membership";
        }


        bytes memory _metadata = abi.encodePacked(
            "{",
                '"name": "',
                _name,
                '",',
                '"description": "',
                _description,
                '", ',
                '"image": ',
                '"data:image/svg+xml;base64,',
                Base64.encode(_svg),
                '",',
            "}"
        );
        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(_metadata)));
    }

    /// This function increases points for a specified member by a specified ammount. Only core delegates or community manegers can increase experience points.
    function increasePoints(address member, uint256 amount) public {
        // Check that the calling account has the CORE_DELEGATE_ROLE or COMMUNITY_MANAGER_ROLE
        if(!hasRole(DEFAULT_ADMIN_ROLE, msg.sender) && !hasRole(CORE_DELEGATE_ROLE, msg.sender) && !hasRole(COMMUNITY_MANAGER_ROLE, msg.sender)) {
            revert SwissDAO_PermissionError();
        }

        _mint(member, EXPERIENCE_POINTS, amount, "");
        _mint(member, ACTIVITY_POINTS, amount, "");
    }

    /// This function decreases activity points for all members by one. Only core delegates or community manegers can increase experience points.
    function decreaseActivityPoints() public {
        // Check that the calling account has the CORE_DELEGATE_ROLE or COMMUNITY_MANAGER_ROLE
        if(!hasRole(DEFAULT_ADMIN_ROLE, msg.sender) && !hasRole(CORE_DELEGATE_ROLE, msg.sender) && !hasRole(COMMUNITY_MANAGER_ROLE, msg.sender)) {
            revert SwissDAO_PermissionError();
        }

        for(uint i=0; i<membersLUP.length; i++){
            if(balanceOf(membersLUP[i], ACTIVITY_POINTS)>0){
                _burn(membersLUP[i], ACTIVITY_POINTS, 1);
            }
        }
    }
    

    /// This function onboards a new member. Only core delegates or event manegers can onboard members.
    function onboard(address member) public {
        // Check that the calling account has the CORE_DELEGATE_ROLE or EVENT_MANAGER_ROLE
        if(!hasRole(DEFAULT_ADMIN_ROLE, msg.sender) && !hasRole(CORE_DELEGATE_ROLE, msg.sender) && !hasRole(EVENT_MANAGER_ROLE, msg.sender)) {
            revert SwissDAO_PermissionError();
        }
        
        uint256 membershipId = uint256(uint160(member));

        // Check if member is not already onboarded
        if(balanceOf(member, membershipId) == 1 ) {
            revert SwissDAO_OnboardingError();
        }

        membersLUP.push(member);
        _mint(member, EXPERIENCE_POINTS, 1, "");
        _mint(member, ACTIVITY_POINTS, 1, "");
        _mint(member, membershipId, 1, "");
        _grantRole(COMMUNITY_MEMBER_ROLE, member);
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
