// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title SafeBank - 使用 CEI 模式修复重入漏洞
/// @notice 先更新状态再执行外部调用，遵循 Checks-Effects-Interactions 模式
contract SafeBank {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        // Checks: 检查余额
        require(balances[msg.sender] >= msg.value, "余额不足");
        uint256 amount = balances[msg.sender];

        // Effects: 先更新状态
        balances[msg.sender] = 0;

        // Interactions: 最后转账
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "转账失败");
    }
}
