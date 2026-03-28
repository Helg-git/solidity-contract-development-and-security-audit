// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ErrorDemo {
    // 自定义 error：只存 4 字节选择器
    error InsufficientBalance(uint256 available, uint256 required);
    error Unauthorized(address caller);
    error ZeroAmount();

    // 方式 1：require 字符串（旧方式）
    function withdrawOld(uint256 amount) external pure {
        require(amount > 0, "Amount must be > 0");
        // 字符串 "Amount must be > 0" 编码进字节码，约 2,562 gas
    }

    // 方式 2：custom error（推荐）
    function withdrawNew(uint256 amount, uint256 balance) external pure {
        if (amount == 0) revert ZeroAmount();
        if (amount > balance) revert InsufficientBalance(balance, amount);
        // 只消耗约 91 gas（4 字节选择器 + 参数编码）
    }

    // 带 error 的交易回滚时，前端可以解码出结构化错误信息
    // 而 require 字符串只能得到一个 Error(string) 类型的回滚
}
