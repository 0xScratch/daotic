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

    string private constant MEMBERCARD_CLIP_PATH =
        '<clipPath id="container"><rect x="176.47" y="244.32" width="348" height="212" rx="16" fill="#fff" /></clipPath>';

    string private constant MEMBERCARD_PROFILE_IMAGE_FILTER =
        '<filter id="h" x="39.631" y="311.28" width="612.65" height="271.4" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix" /><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape" /><feGaussianBlur stdDeviation="36" /></filter>';

    string private constant MEMBERCARD_RADIAL_GRADIENT_BORDER_TOP_RIGHT =
        '<radialGradient id="d" cx="0" cy="0" r="1" gradientTransform="translate(598.58 324.44) rotate(174.42) scale(570.89 144.67)" gradientUnits="userSpaceOnUse"><stop stop-color="#fff" offset="0" /><stop stop-color="#fff" stop-opacity="0" offset="1" /></radialGradient>';

    string private constant MEMBERCARD_RADIAL_GRADIENT_BORDER_TOP_LEFT =
        '<radialGradient id="c" cx="0" cy="0" r="1" gradientTransform="translate(145.32 121.07) rotate(30.64) scale(334.56 202.12)" gradientUnits="userSpaceOnUse"><stop stop-color="#fff" offset="0" /><stop stop-color="#fff" stop-opacity="0" offset="1" /></radialGradient>';

    string private constant MEMBERCARD_RADIAL_GRADIENT_BORDER_BOTTOM_LEFT =
        '<radialGradient id="b" cx="0" cy="0" r="1" gradientTransform="translate(36.841 530.69) rotate(-5.3394) scale(428.27 108.06)" gradientUnits="userSpaceOnUse"><stop stop-color="#fff" offset="0" /><stop stop-color="#fff" stop-opacity="0" offset="1" /></radialGradient>';

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
                // '<rect width="700" height="700" fill="#000" />',
                //'<rect x="75.5" y="140.5" width="349" height="219" rx="11.5" fill="black" stroke="white" />',

                _generateDefinitions(_tokenStruct),
                '<rect x="176.97" y="244.82" width="347" height="211" rx="15.5" stroke="url(#d)" />',
                '<rect x="176.97" y="244.82" width="347" height="211" rx="15.5" stroke="url(#c)" />',
                '<rect x="176.97" y="244.82" width="347" height="211" rx="15.5" stroke="url(#b)" />'
                //_generateContent(_tokenStruct),
            '</svg>'
        );
        /// forgefmt: disable-end
    }

    function _generateDefinitions(Membership.TokenStruct memory _tokenStruct) internal pure returns (string memory) {
        return string.concat(
            "<defs>",
            MEMBERCARD_CLIP_PATH,
            MEMBERCARD_PROFILE_IMAGE_FILTER,
            _generateProfileImage(_tokenStruct.profileImageUri),
            _generateLinearGradient(_tokenStruct.state),
            MEMBERCARD_RADIAL_GRADIENT_BORDER_TOP_RIGHT,
            MEMBERCARD_RADIAL_GRADIENT_BORDER_TOP_LEFT,
            MEMBERCARD_RADIAL_GRADIENT_BORDER_BOTTOM_LEFT,
            "</defs>"
        );
    }

    function _generateProfileImage(string memory _profileImageUri) internal pure returns (string memory) {
        return string.concat(
            '<pattern id="a" width="1" height="1" patternContentUnits="objectBoundingBox"><image transform="scale(.0044444)" width="225" height="225" href="',
            _profileImageUri,
            '" clip-path="inset(0% round 15px)" /></pattern>'
        );
    }

    function _generateLinearGradient(Membership.TokenState _tokenState) internal pure returns (string memory) {
        return string.concat(
            '<linearGradient id="f" x1="345.96" x2="345.96" y1="426.43" y2="466.86" gradientUnits="userSpaceOnUse"><stop stop-color="#FFFBFB" stop-opacity=".56" offset="0" />',
            '<stop stop-color="',
            _tokenState == Membership.TokenState.ONBOARDING
                ? MEMBERCARD_GRADIENT_ONBBOARDING
                : _tokenState == Membership.TokenState.ACTIVE
                    ? MEMBERCARD_GRADIENT_ACTIVE
                    : _tokenState == Membership.TokenState.LABS ? MEMBERCARD_GRADIENT_INACTIVE : MEMBERCARD_GRADIENT_LABS,
            '" offset="1" /></linearGradient>'
        );
    }

    /// @notice Generate the complete SVG code for a given Token.
    /// @return Retunrs concated string
    function _generateContent(Membership.TokenStruct memory _tokenStruct) internal pure returns (string memory) {
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
