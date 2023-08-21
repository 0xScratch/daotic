// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Strings } from "@oz/utils/Strings.sol";
import { Base64 } from "@oz/utils/Base64.sol";

import { MembershipArt } from "./MembershipArt.sol";

/// @title MembershipMetadata
/// @author https://swissdao.space/ (https://github.com/swissDAO)
/// @notice Metadata Library
/// @custom:security-contact dev@swissdao.space
library MembershipMetadata {
    /*//////////////////////////////////////////////////////////////
                                PUBLIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Render the JSON Metadata for a given token.
    /// @return Returns base64 encoded metadata file.
    function generateTokenURI() public pure returns (string memory) {
        bytes memory _svg = MembershipArt.generateSVG();
        string memory _name = "Membership #1";

        /// forgefmt: disable-start
        bytes memory _metadata = abi.encodePacked(
            "{",
                '"name": "',
                _name,
                '",',
                '"description": "Membership of 0x000 for swissDAO",',
                '"image": ',
                    '"data:image/svg+xml;base64,',
                    Base64.encode(_svg),
                    '",',
                '"attributes": [', 
                    _getAttributes(),
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
    function _getAttributes() internal pure returns (bytes memory) {
        return abi.encodePacked(_getTrait("Holder", "0x00", ""));
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
