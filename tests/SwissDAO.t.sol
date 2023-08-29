// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import { Test } from "@std/Test.sol";
import { LibString } from "@solady/utils/LibString.sol";

import { AccessControlHelper } from "../helpers/AccessControlHelper.sol";
import { Constants } from "../helpers/Constants.sol";

import { SwissDAO } from "../src/SwissDAO.sol";

/// @title Test for {SwissDAO}
/// @author swissdao.space (https://github.com/swissDAO)
/// @custom:security-contact xxx@gmail.com
contract SwissDAOTest is Test, AccessControlHelper, Constants {
    /*//////////////////////////////////////////////////////////////
                                 STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    SwissDAO public s_swissDaoToken;

    /*//////////////////////////////////////////////////////////////
                               SETUP
    //////////////////////////////////////////////////////////////*/

    function setUp() public {
        s_swissDaoToken = new SwissDAO(Constants.DEFAULT_ADMIN_ROLER, Constants.CORE_DELEGATE_ROLER);
    }

    /*//////////////////////////////////////////////////////////////
                            function initialize()
    //////////////////////////////////////////////////////////////*/

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    function test_Initialization() public {
        assertTrue(s_swissDaoToken.hasRole(Constants.DEFAULT_ADMIN_ROLE, Constants.DEFAULT_ADMIN_ROLER));
        assertTrue(s_swissDaoToken.hasRole(Constants.CORE_DELEGATE_ROLE, Constants.CORE_DELEGATE_ROLER));
    }

    /*//////////////////////////////////////////////////////////////
                            function uri()
    //////////////////////////////////////////////////////////////*/

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    function test_ReturnsURI() public {
        uint256 _tokenId = 1;
        string memory _uri = s_swissDaoToken.uri(_tokenId);

        assertFalse(LibString.eq(_uri, string(abi.encodePacked(""))));
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    function test_FuzzReturnsURI(uint256 _tokenId) public {
        vm.assume(_tokenId != 0);
        string memory _uri = s_swissDaoToken.uri(_tokenId);

        assertFalse(LibString.eq(_uri, string(abi.encodePacked(""))));
    }

    /*//////////////////////////////////////////////////////////////
                      function increasePoints()
    //////////////////////////////////////////////////////////////*/

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    function test_ShouldRevertIncreasePoints() public {
        address _sender = address(10);

        vm.prank(_sender);
        vm.expectRevert(abi.encodeWithSignature("SwissDAO_PermissionError()"));
        s_swissDaoToken.increasePoints(_sender, 10);
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    function test_FuzzShouldRevertIncreasePoints(address _sender) public {
        vm.prank(_sender);
        vm.expectRevert(abi.encodeWithSignature("SwissDAO_PermissionError()"));
        s_swissDaoToken.increasePoints(_sender, 10);
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    function test_IncreasePoints() public {
        address _sender = Constants.DEFAULT_ADMIN_ROLER;
        uint256 _amount = 10;

        vm.prank(_sender);
        s_swissDaoToken.increasePoints(_sender, _amount);

        assertEq(s_swissDaoToken.balanceOf(_sender, s_swissDaoToken.EXPERIENCE_POINTS()), _amount);
        assertEq(s_swissDaoToken.balanceOf(_sender, s_swissDaoToken.ACTIVITY_POINTS()), _amount);
    }
}
