// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/// @title Constants
/// @author swissdao.space (https://github.com/swissDAO)
/// @notice Constants Contract for Tests
/// @custom:security-contact xxx@gmail.com
contract Constants {
    /*//////////////////////////////////////////////////////////////
                                CONSTANTS
    //////////////////////////////////////////////////////////////*/

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    address public constant DEFAULT_ADMIN_ROLER = address(69420);

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x0000000000000000000000000000000000000000000000000000000000000000;

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    address public constant CORE_DELEGATE_ROLER = address(100000);

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    bytes32 public constant CORE_DELEGATE_ROLE = 0x6b42ed08206aec75e1c79a01381db1760227171d022cf137a65b1296f5b08195;

    uint256 public constant CORE_DELEGATE_GUILD_BADGE = 100;
}
