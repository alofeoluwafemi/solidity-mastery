/*
1. License: Start with a comment indicating its license type e.g
 SPDX-License-Identifier: MIT

2. Pragmas: It is used to enable certain compiler features or checks
  a. Version Pragma e.g pragma solidity ^0.8.0;
  b. ABI Coder Pragma e.g pragma abicoder v2

3. Import: Other Source Files e.g
  import * as symbolName from "filename";

4. Comments:
*/

// a. Single-line comments '//' and
// b. multi-line comments # /*...*/ are possible.


//Additionally there is another type of comment called the netspec comment

/** @title Shape calculator. */
contract ShapeCalculator {

  //State variable;

    constructor(){

    }

    /// @dev Calculates a rectangle's surface and perimeter.
    /// @notice
    /// @param w Width of the rectangle.
    /// @param h Height of the rectangle.
    /// @return s The calculated surface.
    /// @return p The calculated perimeter.
    function rectangle(uint w, uint h) public pure returns (uint s, uint p) {
        s = w * h;
        p = 2 * (w + h);
    }
}

/*
5. State Variables: State variables are variables whose values are permanently stored in contract storage. e.g uint8 = 12

6. Functions: Functions are the executable units of code.
   Functions are usually defined inside a contract, but they can also be defined outside of contracts.
*/

contract Functions {
    function bid() public payable {
      helper();
    }
}

// Helper function defined outside of a contract
function helper(uint x) pure returns (uint) {
    return x * 2;
}

/*
7. Function Modifier: Function Modifiers are used to modify the behaviour of a function
*/

contract Ownable {
    address public owner;

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only owner."
        );
        _;
    }

    function withdraw() public view onlyOwner {
      owner = address(0x0);
    }
}

/*
8. Events: Is an inheritable member of A contract. When an event is emitted,
   it stores the arguments passed in transaction logs
*/

contract EventContract {
    event Bidded(address index bidder, uint amount); // Event

    function bid() public payable {
        emit Bidded(msg.sender, msg.value); // Triggering event
    }
}

/*
9. Enum Types: Can be used to create custom types with a finite set of ‘constant values’
*/

contract EnumTypes {
    enum Levels { Beginner, Novice, Advance } // Enum

    Levels public constant default = Levels.Beginner;

    mapping (address => Levels) public players;

    function upgradeUser(address user) {
        players[address] = Levels.Novice;
    }
 }
