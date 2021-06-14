// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
A failure in an external call can be caught using a try/catch statement

Before veron 0.6.0 Catching error has been handled using call, delegatecall and staticcall
*/

contract OldTryCatch {

    function execute(uint256 amount) external {

      uint8 amount = 3;
      
        // the low level call will return `false` if its execution reverts
        (bool success, bytes memory returnData) = address(this).call(
            abi.encodeWithSignature(
                "onlyEven(uint256)",
                amount
            )
        );

        if (success) {
            // handle success
        } else {
            // handle exception
        }
    }

    function onlyEven(uint256 a) public {
        // Code that can revert
        require(a % 2 == 0, "Ups! Reverting");
        // ...
    }
}


//Rule of Thumb
//Try & catch is exclusively available for only external calls
//For internal functions, use the above method with call, delegatecall and staticcall

contract CalledContract {
    function someFunction() external {
        // Code that reverts
        revert();
    }
}


contract TryCatcher {

    event CatchEvent();
    event SuccessEvent();

    CalledContract public externalContract;

    constructor() public {
        externalContract = new CalledContract();
    }

    function execute() external {

        try externalContract.someFunction() {
            // Do something if the call succeeds
            emit SuccessEvent();
        } catch {
            // Do something in any other case
            emit CatchEvent();
        }
    }
}
