// SPDX-License-Identifier: Proprietary
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract DAONation is DAOManagement, ERC1155Burnable {
    // uint256 public constant WRAPPED_ETH = 0;
    uint256 public constant EXPERIENCE_POINTS = 1;
    uint256 public constant ACTIVITY_POINTS = 2;

    bytes32 public constant CORE_DELEGATE_ROLE = keccak256("CORE_DELEGATE_ROLE");
    bytes32 public constant COMMUNITY_MANAGER_ROLE = keccak256("COMMUNITY_MANAGER_ROLE");
    bytes32 public constant EVENT_MANAGER_ROLE = keccak256("EVENT_MANAGER_ROLE");
    bytes32 public constant PROJECT_MANAGER_ROLE = keccak256("PROJECT_MANAGER_ROLE");
    bytes32 public constant TREASURY_MANAGER_ROLE = keccak256("TREASURY_MANAGER_ROLE");
    bytes32 public constant DEVELOPER_ROLE = keccak256("DEVELOPER_ROLE");

    constructor() public ERC1155("https://swissdao.space/api/item/{id}.json") {
        // _mint(msg.sender, NOTHING, 10**18, "");
    }

    function uri(uint256 _tokenid) override public pure returns (string memory) {
        return string(
            abi.encodePacked(
                "https://swissdao.space/api/item/",
                Strings.toString(_tokenid),".json"
            )
        );
    }
}