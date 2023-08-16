// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test} from "@std/Test.sol";
import {Strings} from "@oz/utils/Strings.sol";

import {SwissDAO} from "../src/SwissDAO.sol";

/// @title Test for {SwissDAO}
/// @author swissdao.space (https://github.com/swissDAO)
/// @custom:security-contact xxx@gmail.com
contract SwissDAOTest is Test {
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
        s_swissDaoToken = new SwissDAO();
    }

    /*//////////////////////////////////////////////////////////////
                            function uri()
    //////////////////////////////////////////////////////////////*/

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    function test_ReturnsURI() public {
        uint256 _tokenId = 1;
        string memory _uri = s_swissDaoToken.uri(_tokenId);

        assertFalse(Strings.equal(_uri, string(abi.encodePacked(""))));
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    function test_FuzzReturnsURI(uint256 _tokenId) public {
        string memory _uri = s_swissDaoToken.uri(_tokenId);

        assertFalse(Strings.equal(_uri, string(abi.encodePacked(""))));
    }

    /*//////////////////////////////////////////////////////////////
                      function increaseExperiencePoints()
    //////////////////////////////////////////////////////////////*/
}
