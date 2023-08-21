// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Ownable } from "@oz/access/Ownable.sol";
import { AccessControl } from "@oz/access/AccessControl.sol";
import { Counters } from "@oz/utils/Counters.sol";
import { ERC721 } from "@oz/token/ERC721/ERC721.sol";
import { ERC721URIStorage } from "@oz/token/ERC721/extensions/ERC721URIStorage.sol";
import { ERC721Enumerable } from "@oz/token/ERC721/extensions/ERC721Enumerable.sol";
import { ERC721Pausable } from "@oz/token/ERC721/extensions/ERC721Pausable.sol";
import { ERC721Burnable } from "@oz/token/ERC721/extensions/ERC721Burnable.sol";
import { Base64 } from "@oz/utils/Base64.sol";
import { Strings } from "@oz/utils/Strings.sol";

import { MembershipMetadata } from "./libraries/MembershipMetadata.sol";

/// @title Membership
/// @author https://swissdao.space/ (https://github.com/swissDAO)
/// @notice Membership Contract for swissDAO
/// @custom:security-contact dev@swissdao.space
contract Membership is Ownable, AccessControl, ERC721URIStorage, ERC721Enumerable, ERC721Pausable, ERC721Burnable {
    using Counters for Counters.Counter;

    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                                CONSTANTS
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                                STRUCTS
    //////////////////////////////////////////////////////////////*/

    /// @dev Struct that contains vital information
    ///      timestamp: Minted Timestamp
    struct TokenStruct {
        uint256 timestamp;
    }

    /*//////////////////////////////////////////////////////////////
                                ENUMS
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @dev Tracker of tokenIds
    Counters.Counter private s_tokenIds;

    /*//////////////////////////////////////////////////////////////
                              CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /// @dev Initialize NFTIME Contract, grant DEFAULT_ADMIN_ROLE to multisig.
    /// @param _multisig Mutlisig address
    constructor(address _multisig) ERC721("NFTIME", "TIME") {
        _grantRole(DEFAULT_ADMIN_ROLE, _multisig);
    }

    /*//////////////////////////////////////////////////////////////
                                EXTERNAL
    //////////////////////////////////////////////////////////////*/

    /// @notice Mint Membership
    /// @return Returns new tokenId
    function mint() external payable whenNotPaused returns (uint256) {
        s_tokenIds.increment();
        uint256 _newItemId = s_tokenIds.current();

        _mint(msg.sender, _newItemId);

        return _newItemId;
    }

    /// @notice Update DEFAULT_ADMIN_ROLE.
    /// @param _multisig New multisig address.
    function setDefaultAdminRole(address _multisig) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(DEFAULT_ADMIN_ROLE, _multisig);
        _revokeRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /// @notice Stop Minting
    function pauseTransactions() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    /// @notice Resume Minting
    function resumeTransactions() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }

    /*//////////////////////////////////////////////////////////////
                                PUBLIC
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                            INTERNAL OVERRIDES
    //////////////////////////////////////////////////////////////*/

    /// @dev Override of the tokenURI function
    /// @param _tokenId TokenId
    /// @return Returns base64 encoded metadata
    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return MembershipMetadata.generateTokenURI();
    }

    /// @dev See {IERC165-supportsInterface}.
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AccessControl, ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /// @dev See {ERC721-_beforeTokenTransfer}.
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    )
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
    {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
    }

    /// @dev See {ERC721-_burn}.
    function _burn(uint256 _tokenId) internal override(ERC721, ERC721URIStorage) whenNotPaused {
        super._burn(_tokenId);
    }
}
