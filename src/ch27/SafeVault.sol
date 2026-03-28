// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/// @title SafeVault - 修复后的安全存取款合约
/// @notice 添加边界检查，使用 address(this).balance 替代自维护的 totalDeposits
contract SafeVault is ReentrancyGuard {
    mapping(address => uint256) public deposits;
    address public owner;

    constructor() { owner = msg.sender; }

    function deposit() external payable {
        require(msg.value > 0, "Must deposit something");
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be > 0");          // 边界检查
        require(deposits[msg.sender] >= amount, "Insufficient");
        deposits[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }

    // 不依赖 totalDeposits，直接用 address(this).balance
    function getTotalBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
