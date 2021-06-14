// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


//Example A (Simple use)

library SafeMath {
    function add(uint x, uint y) external pure returns (uint) {
        uint z = x + y;
        require(z >= x, "uint overflow");
        return z;
    }
}

contract TestSafeMath {

    using SafeMath for uint;

    function testAdd(uint x, uint y) public pure returns (uint) {
        return x.add(y);
    }
}
