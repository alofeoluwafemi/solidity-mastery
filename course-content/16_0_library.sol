// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
Libraries are similar to contracts, but you can't declare any state variable and you can't send ether.
A library is embedded into the contract if all library functions are internal.
Otherwise the library must be deployed and then linked before the contract is deployed.
*/

//Example A (Simple use)
library SafeMath {
    function add(uint x, uint y) internal pure returns (uint) {
        uint z = x + y;
        require(z >= x, "uint overflow");

        return z;
    }
}

contract TestSafeMath {
    function testAdd(uint x, uint y) public pure returns (uint) {
        return SafeMath.add(y);
    }
}

//import "./SafeMath";

contract TestSafeMath {

   using SafeMath for uint;

    function testAdd(uint x, uint y) public pure returns (uint) {
        return x.add(y);
    }
}
