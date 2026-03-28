// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title BadV1 - 错误示范：使用 constructor 的可升级合约
contract BadV1 {
    uint256 public owner;

    constructor() {
        owner = msg.sender; // 只在 V1 部署时执行
    }

    // 当 Proxy 升级到 V2 时，V2 的 constructor 不会执行！
    // 因为 constructor 是在创建合约字节码时执行的，delegatecall 不触发它
}
