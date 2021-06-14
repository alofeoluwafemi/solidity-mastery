// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
Values of reference type can be modified through multiple different places.
Contrast this with value types where you get an independent copy whenever a variable of value type is used.
Because of that, reference types have to be handled more carefully than value types.

Currently, reference types comprise "structs", "arrays" and "mappings".
If you use a reference type, you always have to explicitly provide the data area where the type is stored

1. memory: whose lifetime is limited to an external function call
2. storage: the location where the state variables are stored, where the lifetime is limited to the lifetime of a contract
3. calldata: its a non-modifiable, non-persistent area where function arguments are stored, and behaves mostly like memory
*/



contract CheckReference {
      // The data location of x is storage.
      // This is the only place where the
      // data location can be omitted.
      uint[] public x;

      // The data location of memoryArray is memory.
      function def(uint[] memory memoryArray) public {
          x = memoryArray; // works, copies the whole array to storage
      }

      function copy() public returns(uint[] memory, uint)
      {
          uint[] storage y = x;
          uint copied = y[2];

          x[2] = 0;

          return(y, copied);

      }
}

/*
Fixed size memory arrays cannot be assigned to dynamically-sized memory arrays,
i.e. the following is not possible
*/
contract NotPossible {
    function f() public {
        // The next line creates a type error because uint[3] memory
        // cannot be converted to uint[] memory.
        //uint[] memory x = [uint(1), 3, 4];
    }
}
