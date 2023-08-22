// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Strings } from "@oz/utils/Strings.sol";

import { Membership } from "../Membership.sol";

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
    function generateSVG(Membership.TokenStruct memory _tokenStruct) public pure returns (bytes memory) {
        /// forgefmt: disable-start
        return abi.encodePacked(
            '<svg ',
                'xmlns="http://www.w3.org/2000/svg" ',
                'width="1000" ',
                'height="1000" ',
                'fill="#1E1E1E" ',
                'stroke="#ffffff"',
            '>',
                '<rect width="1000" height="1000" fill="#1E1E1E" />',
                '<rect x="75.5" y="140.5" width="349" height="219" rx="11.5" fill="black" stroke="white" />',
                _generateContent(_tokenStruct),
            '</svg>'
        );
        /// forgefmt: disable-end
    }

    /// @notice Generate the complete SVG code for a given Token.
    /// @return Retunrs concated string
    function _generateContent(Membership.TokenStruct memory _tokenStruct) public pure returns (string memory) {
        return string.concat(
            _generateText("104", "187", "Holder"),
            _generateText("250", "187", Strings.toHexString(_tokenStruct.holder)),
            _generateText("104", "225", "AP"),
            _generateText("250", "225", Strings.toString(_tokenStruct.activityPoints)),
            _generateText("104", "265", "XP"),
            _generateText("250", "265", Strings.toString(_tokenStruct.experiencePoints))
        );
    }

    /// @dev Generate Text object
    /// @param _x X position
    /// @param _y Y position
    /// @param _value Text value
    /// @return Retunrs concated string
    function _generateText(
        string memory _x,
        string memory _y,
        string memory _value
    )
        internal
        pure
        returns (string memory)
    {
        return string.concat(
            '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="24" letter-spacing="-0.04em">',
            '<tspan x="',
            _x,
            '" y="',
            _y,
            '">',
            _value,
            "</tspan></text>"
        );
    }
}
