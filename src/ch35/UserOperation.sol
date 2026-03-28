// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// UserOperation 的核心字段（简化版）
struct UserOperation {
    address sender;           // 发送方（钱包合约地址）
    uint256 nonce;            // 防重放 nonce
    bytes initCode;           // 如果钱包不存在，用于创建钱包的字节码
    bytes callData;           // 钱包要执行的操作
    uint256 callGasLimit;     // 执行 callData 消耗的 gas 上限
    uint256 verificationGasLimit; // 验证签名消耗的 gas 上限
    uint256 preVerificationGas;  // 预验证消耗的 gas
    uint256 maxFeePerGas;     // 最大 gas 单价
    uint256 maxPriorityFeePerGas; // 优先费
    bytes paymasterAndData;   // Paymaster 地址 + 数据（可选）
    bytes signature;          // 用户签名
}
