// SPDX-License-Identifier: Proprietary
pragma solidity ^0.8.18;

import {AccessControl} from "@oz/access/AccessControl.sol";
import {ERC1155} from "@oz/token/ERC1155/ERC1155.sol";
import {Strings} from "@oz/utils/Strings.sol";

contract SwissDAO is ERC1155, AccessControl {
    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/

    /// @notice This error is thrown when a token is intended to be transferred
    error SwissDAO_SoulboundTokenError();

    /*//////////////////////////////////////////////////////////////
                              CONSTANTS
    //////////////////////////////////////////////////////////////*/

    /// @notice Explain to a developer any extra details
    uint256 public constant EXPERIENCE_POINTS = 1;

    /// @notice Explain to a developer any extra details
    uint256 public constant ACTIVITY_POINTS = 2;

    /// @notice Explain to a developer any extra details
    uint256 public constant ASSIGNED_ROLES = 3;

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

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /// @notice Explain to a developer any extra details
    /// @dev Explain to a developer any extra details
    constructor() ERC1155("https://swissdao.space/api/item/{id}.json") {
        // _mint(msg.sender, NOTHING, 10**18, "");
    }

    /*//////////////////////////////////////////////////////////////
                               PUBLIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Explain to a developer any extra details
    /// @dev Explain to a developer any extra details
    /// @param _tokenid Sender's Address
    function uri(uint256 _tokenid) public pure override returns (string memory) {
        return string(abi.encodePacked("https://swissdao.space/api/item/", Strings.toString(_tokenid), ".json"));
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
    ) internal override(ERC1155) {
        if (_from != address(0) || _to != address(0)) {
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
}
