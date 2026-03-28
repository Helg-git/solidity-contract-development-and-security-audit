// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title FixedBank - 修复后的银行合约（CEI + ReentrancyGuard）
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract FixedBank is ReentrancyGuard {
    mapping(address => uint256) public balances;

    function withdraw(uint256 amount) external nonReentrant {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount; // Effect 先执行
        (bool success, ) = msg.sender.call{value: amount}(""); // Interaction 后执行
        require(success, "Transfer failed");
    }
}
