// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
Solidity supports multiple inheritance.
Contracts can inherit other contract by using the is keyword.

Function that is going to be overridden by a child contract must be declared as virtual.
Function that is going to override a parent function must use the keyword override.

Order of inheritance is important.
You have to list the parent contracts in the order from “most base-like” to “most derived”.
*/

contract A {
    //function can be overridden by a child contract
    function foo() public pure virtual returns (string memory) {
          return "A";
    }
}

// Contracts inherit other contracts by using the keyword 'is'.
contract B is A {
    // Override A.foo()
    function foo() public pure virtual override returns (string memory) {
        return "B";
    }
}

contract C is A {
    // Override A.foo()
    function foo() public pure virtual override returns (string memory) {
        return "C";
    }
}

// Contracts can inherit from multiple parent contracts.
// When a function is called that is defined multiple times in
// different contracts, parent contracts are searched from
// right to left, and in depth-first manner.

contract D is B, C {
    // D.foo() returns "C"
    // since C is the right most parent contract with function foo()
    function foo() public pure override(B, C) returns (string memory) {
        return super.foo();
    }
}

contract E is C, B {
    function foo() public pure override(C, B) returns (string memory) {
        return super.foo();
    }
}

contract F is A, B {
    function foo() public pure override(A, B) returns (string memory) {
        return super.foo();
    }
}
