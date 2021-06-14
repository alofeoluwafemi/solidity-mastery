// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC20 {
    function approve(address, uint256) external returns (bool);

    function transfer(address, uint256) external returns (bool);

    function allowance(address owner, address spender) external returns (uint256);

    function transferFrom(address from, address to, uint tokens) external returns (bool);

    function balanceOf(address tokenOwner) external view returns (uint);
}
