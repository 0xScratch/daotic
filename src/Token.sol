// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "@oz/token/ERC20/ERC20.sol";
import {Ownable} from "@oz/access/Ownable.sol";

/// @title Token Test Contract
/// @author Olivier Winkler (https://github.com/owieth)
/// @custom:security-contact xxx@gmail.com
contract Token is ERC20, Ownable {
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/

    /// @dev Explain to a developer any extra details
    error Token__Error();

    /// @dev Explain to a developer any extra details
    /// @param id a parameter just like in doxygen (must be followed by parameter name)
    error Token__ErrorWithParams(uint256 id);

    /*//////////////////////////////////////////////////////////////
                                 STRUCTS
    //////////////////////////////////////////////////////////////*/

    /// @dev Explain to a developer any extra details
    /// @param id a parameter just like in doxygen (must be followed by parameter name)
    /// @param name a parameter just like in doxygen (must be followed by parameter name)
    struct TokenStruct {
        uint256 id;
        string name;
    }

    /*//////////////////////////////////////////////////////////////
                                CONSTANTS
    //////////////////////////////////////////////////////////////*/

    /// @dev Explain to a developer any extra details
    uint256 private constant CONSTANT_NUMBER = 100;

    /*//////////////////////////////////////////////////////////////
                                IMMUTABLES
    //////////////////////////////////////////////////////////////*/

    /// @dev Explain to a developer any extra details
    uint256 private immutable i_immutableNumber = 100;

    /*//////////////////////////////////////////////////////////////
                                 STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @dev Explain to a developer any extra details
    uint256 private s_number;

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/

    /// @dev Explain to a developer any extra details
    /// @param from a parameter just like in doxygen (must be followed by parameter name)
    /// @param to a parameter just like in doxygen (must be followed by parameter name)
    /// @param id a parameter just like in doxygen (must be followed by parameter name)
    event TokenEvent(address indexed from, address indexed to, address indexed id);

    /*//////////////////////////////////////////////////////////////
                                MODIFIERS
    //////////////////////////////////////////////////////////////*/

    /// @dev Explain to a developer any extra details
    modifier onlyMinter() {
        _;
    }

    /// @dev Explain to a developer any extra details
    /// @param minter a parameter just like in doxygen (must be followed by parameter name)
    modifier onlyMinterByAddress(address minter) {
        _;
    }

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor() ERC20("Token", "TKN") {}

    /*//////////////////////////////////////////////////////////////
                               EXTERNAL
    //////////////////////////////////////////////////////////////*/

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param newNumber a parameter just like in doxygen (must be followed by parameter name)
    function setNumber(uint256 newNumber) external {
        s_number = newNumber;
    }

    /*//////////////////////////////////////////////////////////////
                               PUBLIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    function incrementNumber() public {
        s_number++;
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    function getCurrentNumber() public view returns (uint256) {
        return s_number;
    }

    /*//////////////////////////////////////////////////////////////
                               INTERNAL
    //////////////////////////////////////////////////////////////*/

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    function _calculateNumber() internal {}

    /*//////////////////////////////////////////////////////////////
                               PRIVATE
    //////////////////////////////////////////////////////////////*/

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    function _calculateAmount() private {}
}
