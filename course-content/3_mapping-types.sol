// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

/*
Mapping types use the syntax mapping(_KeyType => _ValueType)
and variables of mapping type are declared using the syntax mapping(_KeyType => _ValueType) _VariableName.

The _KeyType can be any built-in value type, bytes, string, or any contract or enum type.
Other user-defined or complex types, such as mappings, structs or array types are not allowed.

_ValueType can be any type, including mappings, arrays and structs.
*/
contract MappingExample {

    mapping (address => uint256) public _balances;
    mapping (address => mapping (address => uint256)) public _allowances;
}
