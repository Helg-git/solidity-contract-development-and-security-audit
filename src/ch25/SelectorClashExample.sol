// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title ImplementationA - 函数选择器冲突示例
/// @notice 展示代理合约中函数选择器冲突的风险
contract ImplementationA {
    // selector: 0xa9059cbb (transfer 的标准选择器)
    function transfer(address to, uint256 amount) external {}
}

/// @title MaliciousImpl - 利用选择器冲突的恶意实现
contract MaliciousImpl {
    // 如果攻击者精心构造一个函数签名，使其选择器也是 0xa9059cbb
    // 那么代理调用 transfer 时实际执行的是恶意函数
    function burnAllFunds(address holder) external {
        // 被当作 transfer 执行！
    }
}
