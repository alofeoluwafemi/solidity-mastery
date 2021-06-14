// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
Function types are the types of functions.
There are four types of functions:
1. Internal (Default Type): They  can only be called inside the current contract
2. External: They can be called from other contracts and via transactions
3. Private: They are only visible for the contract they are defined in and not in derived contracts.
4. Public functions are part of the contract interface and can be either called internally or via messages.
   For public state variables, an automatic getter function (see below) is generated.

Function definition:

function (<parameter types>) {internal|external} [pure|view|payable] [returns (<return types>)]

A public function can be accessed both internally and externally with this keyword
*/
contract FunctionTypes {

  /*
  Function visibility types
  */

  //A private function is one that can only be called by the main contract itself
  function privateFunction() private {
      publicFunction();
    }

    //An internal function can be called by the main contract itself, plus any derived contracts.
    function InternalFunction() internal {
        this.publicFunction();
    }


    function publicFunction() public {
        //
    }

    function externalFunction() external {
        //
    }

    /*
    Function return types & how it affect state
    */

    //Does not read or write to state
    function calculateArea(uint8 length, uint8 breath) public pure returns (uint8 area) {
      return length * breath;
    }

    uint8 l = 8;

    uint8 b = 6;

    //Reads from state
    function getArea() public view returns (uint8 area) {
      return l * b;
    }

    //Writes to state
    function setLB(uint8 length, uint8 breath) public {
      l = length;
      b = breath;
    }

    //Return multiple values
    function getLB() public view returns (uint8 length, uint8 breath) {
      return (length, breath);
    }

    //Destructing arguement & unamed return value
    function reclaculateArea() public returns (uint8) {
        (length, breath) = getLB();

        return length * breath;
    }

    // Can use array for input
    function arrayInput(uint[] memory _arr) public {
    }

    // Can use array for output
    uint[] public arr;

    function arrayOutput() public view returns (uint[] memory) {
        return arr;
    }

    /// Reference types

    /*
    Prior to 0.8.0 you need to add
    pragma experimental ABIEncoderV2;
    to accept struct and nested array as function arguement
    Since Solidity version 0.8.0 the syntax is no longer needed
    */
    struct Transfer {
      address recipient;
      uint  amount;
    }

    Transfer[] public transfers;

    function structInput(Transfer memory transfer) public {
        transfers.push(transfer);
    }

    function structArrayInput(Transfer[] memory transfers) public {
      for (uint i = 0; i < transfers.length; i++) {
        transfers.push(transfers[i]);
      }
    }

    function structOutput() public returns (Transfer) {
        return transfers.pop();
    }

    function structArrayOutput() public returns (Transfer[]) {
        return transfers;
    }

    /// @notice We cannot use map for neither input nor output
    /// More on mapping soon
}
