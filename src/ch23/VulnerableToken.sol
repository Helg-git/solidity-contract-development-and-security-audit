// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title VulnerableToken - 访问控制缺失示例
/// @notice mint 函数没有 onlyOwner 修饰符，任何人都能铸造代币
contract VulnerableToken {
    mapping(address => uint256) public balance;
    uint256 public totalSupply;

    // 没有 onlyOwner 修饰符！
    function mint(address to, uint256 amount) external {
        balance[to] += amount;
        totalSupply += amount;
    }
}
