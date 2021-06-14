// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
<address payable>.transfer(uint256 amount)
send given amount of Wei to Address, reverts on failure, forwards 2300 gas stipend, not adjustable

<address payable>.send(uint256 amount) returns (bool)
send given amount of Wei to Address, returns false on failure, forwards 2300 gas stipend, not adjustable

<address>.call(bytes memory) returns (bool, bytes memory)
issue low-level CALL with the given payload, returns success condition and return data, forwards all available gas, adjustable
*/

contract EtherReceiver {
    receive() external payable {}
}

contract EtherSender {

    EtherReceiver private receiverAdr = new EtherReceiver();

    bool locked = false;

    //Gaurd against double withdraw
    modifier noReentrancy() {
        require(!locked, "No reentrancy");

        locked = true;
        _;  //Inserts function body
        locked = false;
    }

    function sendEther(uint _amount) public payable {
        if (!address(receiverAdr).send(_amount)) {
            //handle failed send
        }
    }

    function callValueEther(uint _amount) public payable noReentrancy {
      (bool sucess, ) = address(receiverAdr).call.value(_amount).gas(35000)();

      if(success) {

      }else{
        //Fails
      }
    }

    function transferEther(uint _amount) public payable {
          address(receiverAdr).transfer(_amount);
    }
}

/*
Note
-------------------------------------------------------------------------------------------------------
Both methods, transfer and send, are considered safe against re-entrancy,
because they only forward 2300 gas, transfer should be the go-to method to transfer ether in most cases.

This is because it reverts automatically in case of any errors.
The send method can be seen as the low level counterpart of transfer.
It should be used in cases where it is important that the error is handled in the contract without reverting all state changes.
The low level call.value method should only be used as a last resort, as it breaks the type-safety of Solidity.

One of its application fields is sending ether to fallback functions that require more than the stipend of gas.
With its adjustable parameters it can provide great flexibility for honest and experienced users, but also for malicious ones.

On one hand the differentiation into three methods used for the same task provides for flexibility,
because the simple transfer function can be used for most use cases
while the more complicated call.value can be adjusted and and used for specialized tasks.

On the other hand the differentiation can be confusing for developers and users alike,
as there are no real semantic clues between the naming of the different options, as to where their differences could be.

Study Case: http://www.kingoftheether.com/postmortem.html
*/
