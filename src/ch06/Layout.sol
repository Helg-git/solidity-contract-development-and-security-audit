// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Layout {
    uint256 a;  // slot 0: 0-31 字节
    address b;  // slot 1: 0-19 字节
    bool c;     // slot 1: 20 字节（和 b 共享一个 slot）
    uint256 d;  // slot 2: 0-31 字节
}
