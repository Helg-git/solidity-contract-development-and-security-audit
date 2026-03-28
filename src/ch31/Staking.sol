// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./Token.sol";

// 示例 Staking 合约，供 Deploy.s.sol 部署脚本使用
contract Staking {
    Token public token;
    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public lastStakeTime;
    uint256 public totalStaked;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);

    constructor(address _token) {
        token = Token(_token);
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be > 0");
        token.transferFrom(msg.sender, address(this), amount);
        stakedBalance[msg.sender] += amount;
        lastStakeTime[msg.sender] = block.timestamp;
        totalStaked += amount;
        emit Staked(msg.sender, amount);
    }

    function unstake(uint256 amount) external {
        require(stakedBalance[msg.sender] >= amount, "Insufficient staked balance");
        stakedBalance[msg.sender] -= amount;
        totalStaked -= amount;
        token.transfer(msg.sender, amount);
        emit Unstaked(msg.sender, amount);
    }
}
