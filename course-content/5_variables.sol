// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Variables {

    /*
    There are three types of variable in solidity
    1. Local Variable: which are declared in a function,
       discarded after a function call and not stored on the blockchain.

    2. State Variable: which are declared outside a function
       and stored on the blockchain

    3. Global variable: which provides information about the blockchain msg.sender or msg.data 
    */

    uint8 public nonce;

    bytes4 public callable;

    function setLocalVariable() public pure returns(address owner) {
       owner = payable(0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c);
    }

    function setStateVariable() public returns(uint8, bytes4 ){
       nonce = 128;

       callable = bytes4(keccak256('setLocalVariable()'));

       return(nonce, callable);
    }

    /***
    * reference https://docs.soliditylang.org/en/v0.8.0/units-and-global-variables.html
    */
    function getGlobalVariable() public payable returns(address sender, uint amount, bytes memory data) {
        sender = msg.sender;
        amount = msg.value;
        data = msg.data;

        return(sender, amount, data);
    }

}
