// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ReceiveFallbackDemo {
    address public owner;
    uint256 public received;

    event Received(address sender, uint256 amount);
    event FallbackCalled(address sender, uint256 amount, bytes data);

    constructor() {
        owner = msg.sender;
    }

    // 纯 ETH 转账时调用（msg.data 为空）
    receive() external payable {
        received += msg.value;
        emit Received(msg.sender, msg.value);
    }

    // 函数不存在或 receive 未定义时的兜底
    fallback() external payable {
        // 可以用来处理意外的调用，或者记录日志
        emit FallbackCalled(msg.sender, msg.value, msg.data);
    }

    // 如果没有 receive 也没有 fallback，任何 ETH 转入都会 revert
    // 这也是为什么有些合约需要 receive() 才能接收收益
}
