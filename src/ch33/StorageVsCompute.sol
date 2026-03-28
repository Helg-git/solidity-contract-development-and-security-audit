// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract StorageVsCompute {
    // 方案 A：存储每个用户的奖励（SLOAD = 2100 gas）
    mapping(address => uint256) public userRewards;

    // 方案 B：存储总奖励 + 每用户的存款时间，实时计算奖励
    uint256 public totalRewardRate;
    mapping(address => uint256) public userStakedAt;
    mapping(address => uint256) public userStakedAmount;

    // 方案 A：直接读存储，简单但贵
    function claimRewardA() external returns (uint256) {
        uint256 reward = userRewards[msg.sender]; // SLOAD: 2100 gas
        userRewards[msg.sender] = 0;              // SSTORE (清零): 4800 gas
        return reward;
    }

    // 方案 B：计算得到，初始写入贵但后续查询便宜
    function claimRewardB() external returns (uint256) {
        // 缓存存储值到内存，避免重复 SLOAD
        uint256 stakedAt = userStakedAt[msg.sender];     // SLOAD: 2100
        uint256 stakedAmount = userStakedAmount[msg.sender]; // SLOAD: 2100

        if (stakedAmount == 0) return 0;

        // 计算奖励（纯内存操作，gas 很低）
        uint256 duration = block.timestamp - stakedAt;   // 内存计算: ~3 gas
        uint256 reward = (stakedAmount * duration * totalRewardRate) / 1e18;

        // 重置状态
        userStakedAt[msg.sender] = block.timestamp;      // SSTORE: 20000
        return reward;
    }
}
