// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
Events allow logging to the Ethereum blockchain.
Some use cases for events are:
Listening for events and updating user interface

cheap form of storage
*/

contract Event {

    // Up to 3 parameters can be indexed.
    // Indexed parameters helps you filter the logs by the indexed parameter
    event Transferred(address indexed sender,address indexed to, uint256 amount);

    function fireEvent(address to) public {
        emit Transfer(msg.sender, to, "Funds sent");
    }
}

//Javascript side to listen to event
 filter = {
    address: {CONTRACT_ADDRESS},
    topics: [
        ethers.utils.id("Transfer(address,address,uint256)"),
        null,
        {MY_ADDRESS} //Filter transfer sent to me
    ]
}

provider.on(filter, () => {
    // do whatever you want here
    // I'm pretty sure this returns a promise, so don't forget to resolve it
})

//You can always query for events from the past
// List all token transfers *to* myAddress:
contract.filters.Transfer(null, myAddress)
