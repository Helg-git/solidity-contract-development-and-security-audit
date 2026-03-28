// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title V2 - 存储布局示例（有 collision 问题）
contract V2 {
    uint256 public a; // slot 0（和 V1 一样，安全）
    uint256 public c; // slot 1（和 V1 的 b 冲突！）
    uint256 public d; // slot 2（新增，安全）
}
