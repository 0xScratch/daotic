// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "@std/Script.sol";

import {Constants} from "../helpers/Constants.sol";

import {SwissDAO} from "../src/SwissDAO.sol";

/// @title Deploy script for {SwissDAO}
/// @author swissdao.space (https://github.com/swissDAO)
/// @custom:security-contact xxx@gmail.com
contract Deploy is Script, Constants {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        new SwissDAO(Constants.DEFAULT_ADMIN_ROLER, Constants.CORE_DELEGATE_ROLER);

        vm.stopBroadcast();
    }
}
