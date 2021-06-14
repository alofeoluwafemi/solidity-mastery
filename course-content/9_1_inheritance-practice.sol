// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./9_0_inheritance.sol";

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
