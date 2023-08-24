// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Strings } from "@oz/utils/Strings.sol";
import { Base64 } from "@oz/utils/Base64.sol";

import { MembershipArt } from "./MembershipArt.sol";
import { Membership } from "../Membership.sol";

/// @title MembershipMetadata
/// @author https://swissdao.space/ (https://github.com/swissDAO)
/// @notice Metadata Library
/// @custom:security-contact dev@swissdao.space
library MembershipMetadata {
    /*//////////////////////////////////////////////////////////////
                              CONSTANTS
    //////////////////////////////////////////////////////////////*/

    /// @dev Animated NFT URI
    string private constant ANIMATION_TOKEN_URI_PREFIX = "https://www.swissdao.space/membercard/";

    /*//////////////////////////////////////////////////////////////
                                PUBLIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Render the JSON Metadata for a given token.
    /// @return Returns base64 encoded metadata file.
    function generateTokenURI(
        uint256 _tokenId,
        Membership.TokenStruct memory _tokenStruct
    )
        public
        pure
        returns (string memory)
    {
        bytes memory _svg = MembershipArt.generateSVG(_tokenStruct);
        string memory _name = string.concat("Membership #", Strings.toString(_tokenId));

        string memory _holder = Strings.toHexString(_tokenStruct.holder);

        /// forgefmt: disable-start
        bytes memory _metadata = abi.encodePacked(
            "{",
                '"name": "',
                _name,
                '",',
                '"description": "',
                string.concat("Membership of", _holder, '",'),
                '"image": ',
                    '"data:image/svg+xml;base64,',
                    Base64.encode(_svg),
                    '",',
                '"animation_url": "',
                string.concat(ANIMATION_TOKEN_URI_PREFIX, _holder),
                '",',
                '"attributes": [', 
                    _getAttributes(_tokenStruct),
                "]",
            "}"
        );
        /// forgefmt: disable-end

        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(_metadata)));
    }

    /*//////////////////////////////////////////////////////////////
                                INTERNAL
    //////////////////////////////////////////////////////////////*/

    /// @dev Generate all Attributes
    /// @return Returns base64 encoded attributes.
    function _getAttributes(Membership.TokenStruct memory _tokenStruct) internal pure returns (bytes memory) {
        return abi.encodePacked(
            _getTrait("Holder", Strings.toHexString(_tokenStruct.holder), ""),
            _getTrait("Minted", Strings.toHexString(_tokenStruct.mintedAt), ""),
            _getTrait("Joined", Strings.toHexString(_tokenStruct.joinedAt), ""),
            _getTrait("Experience Points", Strings.toHexString(_tokenStruct.experiencePoints), ""),
            _getTrait("Activity Points", Strings.toHexString(_tokenStruct.activityPoints), ""),
            _getTrait("State", "ONBOARDING", "")
        );
    }

    /// @dev Generate the SVG snipped for a single attribute.
    /// @param traitType The `trait_type` for this trait.
    /// @param traitValue The `value` for this trait.
    /// @param append Helper to append a comma.
    function _getTrait(
        string memory traitType,
        string memory traitValue,
        string memory append
    )
        internal
        pure
        returns (string memory)
    {
        return
            string(abi.encodePacked("{", '"trait_type": "', traitType, '",' '"value": "', traitValue, '"' "}", append));
    }
}
