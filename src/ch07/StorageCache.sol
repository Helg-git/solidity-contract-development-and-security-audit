// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract StorageCache {
    struct User {
        uint256 balance;
        uint256 rewards;
        bool isActive;
    }
    mapping(address => User) public users;

    // 优化前：每次 users[user].xxx 都重新计算地址
    function badUpdate(address user, uint256 amount) external {
        users[user].balance += amount;
        users[user].rewards += amount / 10;
        users[user].isActive = true;
    }

    // 优化后：storage 指针，编译器能更好地优化
    function goodUpdate(address user, uint256 amount) external {
        User storage u = users[user]; // 一次拿到 storage 指针
        u.balance += amount;
        u.rewards += amount / 10;
        u.isActive = true;
    }
}
