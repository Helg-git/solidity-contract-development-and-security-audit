// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title VulnerableBank - 重入攻击漏洞示例
/// @notice 取款函数在状态更新之前执行外部调用，存在重入风险
contract VulnerableBank {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        // Checks: 余额是否足够
        require(balances[msg.sender] >= amount, "余额不足");

        // Interactions: 先转账（危险！控制权交出去了）
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "转账失败");

        // Effects: 后更新余额（太晚了！）
        balances[msg.sender] -= amount;
    }
}
