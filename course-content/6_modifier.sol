// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 Modifiers are code that can be run before and / or after a function call. They can be used to:
 1. Restrict access
 2. Validate inputs
 3. Guard against reentrancy hack
*/

contract Modifier {

    address admin;

    mapping(address => bool) users;

    //Restrict access
    modifier onlyAdmin(){
      require(msg.sender == admin,"You do not have admin priviledges");
      _;  //Inserts function body
    }

    //Validate inputs
    modifier isAllowed(address account){
      require(address != address(0),"Invalid user");
      require(!!users[account],"You do not have admin priviledges");
      _;  //Inserts function body
    }

    //Gaurd against double withdraw
    modifier noReentrancy() {
        require(!locked, "No reentrancy");

        locked = true;
        _;  //Inserts function body
        locked = false;
    }


}
