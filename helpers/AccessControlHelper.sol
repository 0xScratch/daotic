// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { LibString } from "@solady/utils/LibString.sol";

/// @title AccessControl Helper
/// @author swissdao.space (https://github.com/swissDAO)
/// @notice AccessControl Helper
/// @custom:security-contact xxx@gmail.com
contract AccessControlHelper {
    /*//////////////////////////////////////////////////////////////
                                PUBLIC
    //////////////////////////////////////////////////////////////*/

    /// @dev Composes access control revert message
    /// @param _sender Sender Address
    /// @param _role Accessed role
    function getAccessControlRevertMessage(address _sender, string memory _role) public pure returns (bytes memory) {
        return
            bytes(string.concat("AccessControl: account ", LibString.toHexString(_sender), " is missing role ", _role));
    }
}
