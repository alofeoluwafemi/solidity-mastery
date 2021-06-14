// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
Contracts need to be marked as abstract when at least one of their functions is not implemented.

- Contracts may be marked as abstract even though all functions are implemented.
- This can be done by using the abstract keyword
- Abstract contracts can not be instantiated directly
- If a contract inherits from an abstract contract and does not implement all non-implemented functions by overriding,
  it needs to be marked as abstract as well.
*/


//contract needs to be defined as abstract, because the function utterance() was defined,
//but no implementation was provided
abstract contract Feline {
    function utterance() public virtual returns (bytes32);
}

contract Cat is Feline {
    function utterance() public pure override returns (bytes32) { return "miaow"; }
}

/*
Interfaces are similar to abstract contracts, but they cannot have any functions implemented.
There are further restrictions:

- They cannot inherit from other contracts, but they can inherit from other interfaces.
- All declared functions must be external.
- They cannot declare a constructor.
- They cannot declare state variables.
*/

interface Token {
    enum TokenType { Fungible, NonFungible }
    struct Coin { string obverse; string reverse; }
    function transfer(address recipient, uint amount) external;
}

contract DemoToken is Token {
    function transfer(address recipient, uint amount) external {
        _transfer(recipient, amount);
    }
}


contract TimeLock {

    function transferToken() public {
        Token(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f).transfer(0xA5771debcAD3Af421712c8e2072a41eAc1BF9282, 1 ether);
    }
}
