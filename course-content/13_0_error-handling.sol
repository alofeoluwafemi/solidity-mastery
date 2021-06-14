// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
Solidity uses state-reverting exceptions to handle errors.
Such an exception undoes all changes made to the state in the current call (and all its sub-calls)
and flags an error to the caller.

When exceptions happen in a sub-call, they “bubble up” (i.e., exceptions are rethrown)

Exceptions to this rule are send and the low-level functions
- call
- delegatecall and
- staticcall


They return false as their first return value in case of an exception instead of “bubbling up”.
*/


//Rule of Thumb
//Panic via assert and Error via require

/*
- require is used to validate inputs and conditions before execution.
- revert function is another way to trigger exceptions from within other code blocks to flag an error and revert the current call.
- assert is used to check for code that should never be false. Failing assertion probably means that there is a bug.
*/


contract Sharer {
    function sendHalf(address payable addr) public payable returns (uint balance) {
        require(msg.value % 2e18 == 0, "Even value required.");
        uint balanceBeforeTransfer = address(this).balance;
        addr.transfer(msg.value / 2);

        // Since transfer throws an exception on failure and
        // cannot call back here, there should be no way for us to
        // still have half of the money.
        assert(address(this).balance == balanceBeforeTransfer - msg.value / 2);
        return address(this).balance;
    }
}
