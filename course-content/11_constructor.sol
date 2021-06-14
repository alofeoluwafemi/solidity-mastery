// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
A constructor is an optional function that is executed upon contract creation.
Here are examples of how to pass arguments to constructors.
*/

contract TypeA {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

contract TypeB {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

// There are 2 ways to initialize parent contract with parameters.

// Pass the parameters here in the inheritance list.
contract TypeC is TypeB("Input to TypeB"), TypeA("Input to TypeA") {
}

//Or in the constructor
// Order of constructors called:
// 1. TypeB
// 2. TypeA
// 3. TypeD
contract TypeD is TypeA, TypeB {
    constructor() TypeB("TypeB was called") TypeA("TypeA was called") {
    }
}
