// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ModifierDemo {
    address public owner;
    uint256 public count;

    constructor() {
        owner = msg.sender;
    }

    // _ 前的代码先执行，_ 后的代码在函数体执行完后执行
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _; // 函数体插入点
        count++; // 函数执行完后再执行这里
    }

    // 多个 modifier：从左到右嵌套
    // onlyOwner 先执行 → nonZero 后执行
    modifier nonZero(uint256 val) {
        require(val > 0, "Must be > 0");
        _;
    }

    // 执行顺序：
    // 1. onlyOwner 检查 msg.sender == owner
    // 2. nonZero 检查 val > 0
    // 3. 函数体执行
    // 4. nonZero 的 _ 之后（无）
    // 5. onlyOwner 的 _ 之后：count++
    function increment(uint256 val) external onlyOwner nonZero(val) {
        count += val;
    }
}
