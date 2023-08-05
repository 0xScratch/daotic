// SPDX-License-Identifier: Proprietary
pragma solidity ^0.8.18;

import {ERC1155} from "@oz/token/ERC1155/ERC1155.sol";
import {Strings} from "@oz/utils/Strings.sol";

contract DAONation is ERC1155 {
    // uint256 public constant WRAPPED_ETH = 0;
    uint256 public constant EXPERIENCE_POINTS = 1;
    uint256 public constant ACTIVITY_POINTS = 2;
    uint256 public constant ASSIGNED_ROLES = 3;

    constructor() ERC1155("https://swissdao.space/api/item/{id}.json") {
        // _mint(msg.sender, NOTHING, 10**18, "");
    }

    function uri(uint256 _tokenid) public pure override returns (string memory) {
        return string(abi.encodePacked("https://swissdao.space/api/item/", Strings.toString(_tokenid), ".json"));
    }
}
