// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title VulnerableBank - 重入与余额检查竞争条件（ch27 版本）
/// @notice 取款时先转账后更新余额，存在重入漏洞
contract VulnerableBank {
    mapping(address => uint256) public balances;

    // 漏洞：先转账，后更新余额
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        // Interaction 放在了 Effect 之前！
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        // 状态更新放最后，重入窗口打开
        balances[msg.sender] -= amount;
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }
}
