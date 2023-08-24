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

    function test_ShouldRevertMintIfAlreadyMember() public {
        uint256 _tokenId = s_membership.mint();
        assertEq(_tokenId, s_membership.totalSupply());

        vm.expectRevert(abi.encodeWithSignature("Membership__YouAlreadyAreMember()"));
        s_membership.mint();
    }

    function test_Mint() public {
        uint256 _tokenId = s_membership.mint();
        s_membership.tokenURI(_tokenId);
    }

    function test_Upgrade() public {
        uint256 _tokenId = s_membership.mint();
        s_membership.tokenURI(_tokenId);

        Membership.TokenStruct memory _tokenStruct = Membership.TokenStruct({
            mintedAt: block.timestamp,
            joinedAt: block.timestamp,
            experiencePoints: 100,
            activityPoints: 50,
            holder: msg.sender,
            state: Membership.TokenState.ACTIVE
        });

        vm.prank(DEFAULT_ADMIN_ADDRESS);
        s_membership.updateMembership(_tokenId, _tokenStruct);

        s_membership.tokenURI(_tokenId);
    }
}
