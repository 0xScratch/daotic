// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { LibString } from "@solady/utils/LibString.sol";

import { Membership } from "../Membership.sol";

/// @title MembershipArt
/// @author https://swissdao.space/ (https://github.com/swissDAO)
/// @notice Art Render Library
/// @custom:security-contact dev@swissdao.space
library MembershipArt {
    /*//////////////////////////////////////////////////////////////
                                CONSTANTS
    //////////////////////////////////////////////////////////////*/

    string private constant MEMBERCARD_CIRCULAR_PROGRESS =
        '<path d="M209.348 351.447C202.005 344.105 197.005 334.75 194.979 324.566C192.954 314.382 193.993 303.826 197.967 294.233C201.941 284.64 208.67 276.441 217.303 270.672C225.937 264.903 236.087 261.824 246.471 261.824C256.854 261.824 267.005 264.903 275.638 270.672C284.272 276.441 291.001 284.64 294.974 294.233C298.948 303.827 299.988 314.383 297.962 324.567C295.936 334.751 290.936 344.105 283.594 351.447" fill="none" stroke="white" stroke-width="5" stroke-linecap="round" stroke-linejoin="round" />';

    string private constant MEMBERCARD_GRADIENT_ONBBOARDING = "#E31D1C";

    string private constant MEMBERCARD_GRADIENT_ACTIVE = "#D7E0E7";

    string private constant MEMBERCARD_GRADIENT_INACTIVE = "#000000";

    string private constant MEMBERCARD_GRADIENT_LABS = "#E1A255";

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
                'width="700" ',
                'height="700" ',
                'style="background:#000000"',
            '>',
                '<rect x="176.971" y="244.824" width="347" height="211" rx="15.5" fill="black" stroke="#868686" />',
                _generateProfileImage(_tokenStruct.profileImageUri),
                MEMBERCARD_CIRCULAR_PROGRESS,
                '<rect x="226.938" y="359.844" width="39.0674" height="8.96191" rx="4.48096" fill="white" />',
                _generateExperienceRect(_tokenStruct.state),
                _generateContent(_tokenStruct),
                '',
            '</svg>'
        );
        /// forgefmt: disable-end
    }

    function _generateProfileImage(string memory _profileImageUri) internal pure returns (string memory) {
        return string.concat(
            '<image xmlns="http://www.w3.org/2000/svg" width="100" height="100" href="',
            _profileImageUri,
            '" x="196" y="264" clip-path="inset(0% round 50%)"/>'
        );
    }

    function _generateExperienceRect(Membership.TokenState _tokenState) internal pure returns (string memory) {
        return string.concat(
            '<rect x="226.938" y="359.844" width="39.0674" height="8.96191" rx="4.48096" fill="',
            _tokenState == Membership.TokenState.ONBOARDING
                ? MEMBERCARD_GRADIENT_ONBBOARDING
                : _tokenState == Membership.TokenState.ACTIVE
                    ? MEMBERCARD_GRADIENT_ACTIVE
                    : _tokenState == Membership.TokenState.LABS ? MEMBERCARD_GRADIENT_INACTIVE : MEMBERCARD_GRADIENT_LABS,
            '" />'
        );
    }

    /// @notice Generate the complete SVG code for a given Token.
    /// @return Retunrs concated string
    function _generateContent(Membership.TokenStruct memory _tokenStruct) internal pure returns (string memory) {
        return string.concat(
            _generateText("196", "406", "John Doe"),
            _generateText("196", "428", LibString.toHexString(_tokenStruct.holder)),
            _generateText("237", "366", LibString.toString(_tokenStruct.experiencePoints))
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
            '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="14" letter-spacing="-0.04em">',
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
