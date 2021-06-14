// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

/*
An implicit type conversion is automatically applied by the compiler in some cases during assignments,
when passing arguments to functions and when applying operators.

In general, an implicit conversion between value-types is possible if it makes sense semantically and no information is lost.


If the compiler does not allow implicit conversion but you are confident a conversion will work,
an explicit type conversion is sometimes possible.

This may result in unexpected behaviour and allows you to bypass some security features of the compiler.
*/
contract Conversion {


    uint8 y = 8;
    uint16 z = 32768;
    uint32 x = y + z;

    //Another example
    uint8[] = [2, 4, 6];


    /*
    Explicit Conversion
    */

    int  y = -3;
    uint x = uint(y);

    // If an integer is explicitly converted to a smaller type, higher-order bits are cut off:
    uint32 a = 0x12345678;
    uint16 b = uint16(a); // b will be 0x5678 now

    uint16[] = [uint16(2), 4, 6];

}
