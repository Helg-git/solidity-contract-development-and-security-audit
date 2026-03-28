// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title ImplementationV1 - 代理合约的第一个实现版本
contract ImplementationV1 {
    address public owner;
    uint256 public value;

    function initialize() external {
        owner = msg.sender;
    }

    function setValue(uint256 _value) external {
        require(msg.sender == owner, "Not owner");
        value = _value;
    }
}
