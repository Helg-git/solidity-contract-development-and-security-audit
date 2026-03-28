// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract VulnerableBank {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    // 漏洞：先转账，后更新状态
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient");
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        balances[msg.sender] -= amount; // 重入点！
    }
}
