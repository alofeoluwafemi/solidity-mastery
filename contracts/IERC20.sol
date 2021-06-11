// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC20 {
    function approve(address, uint256) external returns (bool);

    function transfer(address, uint256) external returns (bool);
}
