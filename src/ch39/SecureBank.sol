// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract SecureBank {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    // 修复：使用 CEI 模式（Checks-Effects-Interactions）
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient");
        balances[msg.sender] -= amount; // Effects：先更新状态
        (bool success, ) = msg.sender.call{value: amount}(""); // Interactions：后外部调用
        require(success, "Transfer failed");
    }
}
