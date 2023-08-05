// SPDX-License-Identifier: Proprietary
pragma solidity ^0.8.18;

<<<<<<< HEAD
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
=======
import {ERC1155} from "@oz/token/ERC1155/ERC1155.sol";
import {Strings} from "@oz/utils/Strings.sol";
>>>>>>> 4a0acb453d1180a6a47445aaff5f41652ac7ebfc

contract SwissDAO is ERC1155 {
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

<<<<<<< HEAD
    bytes32 public constant CORE_DELEGATE_ROLE = keccak256("CORE_DELEGATE_ROLE");
    bytes32 public constant COMMUNITY_MANAGER_ROLE = keccak256("COMMUNITY_MANAGER_ROLE");
    bytes32 public constant EVENT_MANAGER_ROLE = keccak256("EVENT_MANAGER_ROLE");
    bytes32 public constant PROJECT_MANAGER_ROLE = keccak256("PROJECT_MANAGER_ROLE");
    bytes32 public constant TREASURY_MANAGER_ROLE = keccak256("TREASURY_MANAGER_ROLE");
    bytes32 public constant DEVELOPER_ROLE = keccak256("DEVELOPER_ROLE");
=======
    /// @notice Explain to a developer any extra details
    uint256 public constant ASSIGNED_ROLES = 3;
>>>>>>> 4a0acb453d1180a6a47445aaff5f41652ac7ebfc

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
}
