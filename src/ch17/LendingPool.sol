// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title LendingPool - 借贷协议核心数据模型
contract LendingPool {
    // ========== 核心映射 ==========
    mapping(address => mapping(address => uint256)) public deposits;
    mapping(address => mapping(address => uint256)) public borrows;
    mapping(address => mapping(address => uint256)) public collateral;

    // ========== 资产池配置 ==========
    mapping(address => uint256) public totalDeposits;
    mapping(address => uint256) public totalBorrows;
    mapping(address => uint256) public maxLTV;            // 7500 = 75%
    mapping(address => uint256) public liquidationThreshold; // 8000 = 80%
}
