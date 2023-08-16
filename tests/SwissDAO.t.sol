// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test} from "@std/Test.sol";
import {Strings} from "@oz/utils/Strings.sol";

import {Constants} from "../helpers/Constants.sol";

import {SwissDAO} from "../src/SwissDAO.sol";

/// @title Test for {SwissDAO}
/// @author swissdao.space (https://github.com/swissDAO)
/// @custom:security-contact xxx@gmail.com
contract SwissDAOTest is Test, Constants {
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
