// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title BuggyVault - 边界条件漏洞示例
/// @notice 允许零值取款、selfdestruct 可强制发 ETH 导致状态不一致
contract BuggyVault {
    mapping(address => uint256) public deposits;
    uint256 public totalDeposits;
    address public owner;

    constructor() { owner = msg.sender; }

    function deposit() external payable {
        require(msg.value > 0, "Must deposit something");
        deposits[msg.sender] += msg.value;
        totalDeposits += msg.value;
    }

    // 漏洞：允许取款 0，浪费 gas
    function withdraw(uint256 amount) external {
        require(deposits[msg.sender] >= amount, "Insufficient");
        deposits[msg.sender] -= amount;
        totalDeposits -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }

    // 漏洞：selfdestruct 可强制发 ETH，totalDeposits 与余额不一致
    function emergencyWithdraw() external {
        require(msg.sender == owner, "Not owner");
        payable(owner).transfer(address(this).balance);
    }
}
