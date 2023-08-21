// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Strings } from "@oz/utils/Strings.sol";

/// @title MembershipArt
/// @author https://swissdao.space/ (https://github.com/swissDAO)
/// @notice Art Render Library
/// @custom:security-contact dev@swissdao.space
library MembershipArt {
    /*//////////////////////////////////////////////////////////////
                                CONSTANTS
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                                PUBLIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Generate the complete SVG code for a given Token.
    /// @return Returns base64 encoded svg file.
    function generateSVG() public pure returns (bytes memory) {
        /// forgefmt: disable-start
        return abi.encodePacked(
            '<svg ',
                'xmlns="http://www.w3.org/2000/svg" ',
                'width="1000" ',
                'height="1000" ',
                'style="background:black;"',
            '>',
            '</svg>'
        );
        /// forgefmt: disable-end
    }
}
