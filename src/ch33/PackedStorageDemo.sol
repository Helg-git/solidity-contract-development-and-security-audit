// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 差的排列：每个变量各占一个 slot = 4 个 slot = 80000 gas 初始化
struct UserInfoBad {
    uint256 amount;     // slot 0（32 字节）
    address owner;      // slot 1（20 字节，浪费 12 字节）
    bool isActive;      // slot 2（1 字节，浪费 31 字节）
    uint128 rewardDebt; // slot 3（16 字节，浪费 16 字节）
}

// 好的排列：打包到一个 slot = 2 个 slot = 40000 gas 初始化
struct UserInfoGood {
    // slot 0: 1 + 1 + 4 + 20 = 26 字节（剩余 6 字节）
    bool isActive;       // 1 字节
    bool isVIP;          // 1 字节
    uint32 lastUpdate;   // 4 字节
    address owner;       // 20 字节

    // slot 1: 16 + 16 = 32 字节（完美填满）
    uint128 rewardDebt;  // 16 字节
    uint128 amount;      // 16 字节（如果确定 amount 不会超过 2^128）
}

contract PackedStorageDemo {
    UserInfoBad public bad;
    UserInfoGood public good;
}
