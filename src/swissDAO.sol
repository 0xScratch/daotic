// SPDX-License-Identifier: Proprietary
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract DAONation is DAOManagement, ERC1155Burnable {
    // uint256 public constant WRAPPED_ETH = 0;
    uint256 public constant EXPERIENCE_POINTS = 1;
    uint256 public constant ACTIVITY_POINTS = 2;
    uint256 public constant ASSIGNED_ROLES = 3;

    constructor() public ERC1155("https://swissdao.space/api/item/{id}.json") {
        // _mint(msg.sender, NOTHING, 10**18, "");
    }

    function uri(uint256 _tokenid) public pure override returns (string memory) {
        return string(abi.encodePacked("https://swissdao.space/api/item/", Strings.toString(_tokenid), ".json"));
    }
}
