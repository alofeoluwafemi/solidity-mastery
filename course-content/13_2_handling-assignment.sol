// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
- Create a different contract ForEven
- Move onlyEven into ForEven contract
- Change onlyEven to an external functions
- Deploy ForEven Contract
- Call onlyEven from OldTryCatch contract
- Make sure your contract compiles on Remix browser
*/

contract OldTryCatch {

    function execute(uint256 amount) external {

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
