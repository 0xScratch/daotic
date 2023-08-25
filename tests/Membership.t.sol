// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import { Test } from "@std/Test.sol";
import { Membership } from "../src/Membership.sol";

/// @title Test for {Membership}
/// @author Olivier Winkler (https://github.com/owieth)
/// @custom:security-contact xxx@gmail.com
contract MembershipTest is Test {
    address private constant DEFAULT_ADMIN_ADDRESS = address(100);

    Membership public s_membership;

    function setUp() public {
        s_membership = new Membership(DEFAULT_ADMIN_ADDRESS, address(2));
    }

    function test_Mint() public {
        uint256 _tokenId = s_membership.mint();
        s_membership.tokenURI(_tokenId);
    }

    function test_Upgrade() public {
        uint256 _tokenId = s_membership.mint();
        s_membership.tokenURI(_tokenId);

        vm.prank(DEFAULT_ADMIN_ADDRESS);
        s_membership.updateMembership(_tokenId, 100, 50);

        s_membership.tokenURI(_tokenId);
    }
}
