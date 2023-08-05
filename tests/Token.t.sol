// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test} from "@std/Test.sol";
import {Token} from "../src/Token.sol";

/// @title Test for {Token}
/// @author Olivier Winkler (https://github.com/owieth)
/// @custom:security-contact xxx@gmail.com
contract TokenTest is Test {
    Token public token;

    function setUp() public {
        token = new Token();
        token.setNumber(0);
    }

    function testIncrement() public {
        token.incrementNumber();
        assertEq(token.getCurrentNumber(), 1);
    }

    function testSetNumber(uint256 x) public {
        token.setNumber(x);
        assertEq(token.getCurrentNumber(), x);
    }
}
