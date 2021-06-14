// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
A contract can have multiple functions of the same name but with different parameter types.
This process is called “overloading”
*/
contract Overloading {

    /// @param status true
    function getStatus(bool status) public pure returns (bool) {
        return status;
    }

    /// @param status 1
    function getStatus(uint1 status) public pure returns (uint1) {
        return status;
    }

    /// @param status 'true'
    function getStatus(bytes8 status) public pure returns (bytes8) {
        return status;
    }

}
