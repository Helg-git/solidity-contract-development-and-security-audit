// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title ImplementationV2 - 存储布局碰撞示例
/// @notice 在 owner 之前插入了新变量，导致所有存储位置偏移
contract ImplementationV1 {
    address public owner;           // slot 0
    uint256 public value;           // slot 1
}

/// @notice 升级时在前面插入了新变量 —— 危险！
contract ImplementationV2 {
    bool public paused;             // slot 0 (新的！)
    address public owner;           // slot 1 (原来是 slot 0)
    uint256 public value;           // slot 2 (原来是 slot 1)
}
