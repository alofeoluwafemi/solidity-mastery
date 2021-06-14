// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataTypes {

    /*
    uint (unsigned integer) integer only accepts positive numbers
    */

    //Boolean
    bool public boolean = true;

    //Size 0 to 2 ^ 8 - 1 alias for uint256
    uint8 public u8      = 2**8 - 1;

    //Size 0 to 2 ^ 16 - 1 alias for uint256
    uint16 public u16     = 2**16 - 1;

    //Size 0 to 2 ^ 32 - 1 alias for uint256
    uint32 public u32     = 2**32 - 1;

    //Size 0 to 2 ^ 64 - 1 alias for uint256
    uint64 public u64     = 2**64 - 1;

    //Size 0 to 2 ^ 128 - 1 alias for uint256
    uint128 public u128    = 2**128 - 1;

    //Size 0 to 2 ^ 256 - 1 alias for uint256
    uint256 public u256  = 2**256 - 1;

    //Size 0 to 2 ^ 256 - 1 alias for uint256
    uint public u        = 2**256 - 1;



    /***
    * Negative numbers are allowed for int types
    */

    //Size -2 ^ 8 - 1 to 2 ^ 8 - 1 alias for uint256
    int8 public i8      = -2**7;

    //Size 0 to 2 ^ 16 - 1 alias for uint256
    int16 public i16     = -2**15;

    //Size 0 to 2 ^ 32 - 1 alias for uint256
    int32 public i32     = -2**31;

    //Size 0 to 2 ^ 64 - 1 alias for uint256
    int64 public i64     = -2**63;

    //Size 0 to 2 ^ 128 - 1 alias for uint256
    int128 public i128    = -2**127;

    //Size 0 to 2 ^ 256 - 1 alias for uint256
    int256 public i256  = -2**255;

    //Size -2 ^ 256 - 1 to 2 ^ 256 - 1 alias for uint256
    int public i        = -2**254;

    //Size -2 ^ 255 - 1 to 2 ^ 255 - 1 alias for uint256
    int public _i       = 2**254;


    address public addr = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;

    //Contract Types
    SomeContract a;

}

contract SomeContract{

  function someFunction() {

  }
}
