// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Script } from "@std/Script.sol";

import { Token } from "../src/Token.sol";

/// @title Deployscript for {Token}
/// @author Olivier Winkler (https://github.com/owieth)
/// @custom:security-contact xxx@gmail.com
contract Deploy is Script {
    function setUp() public { }

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        new Token();

        vm.stopBroadcast();
    }
}
