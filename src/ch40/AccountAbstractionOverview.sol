// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 简单的 Account Abstraction 钱包接口
interface IAccount {
    // 验证 UserOperation 的签名
    function validateUserOp(
        bytes calldata userOp,
        bytes32 userOpHash,
        uint256 missingAccountFunds
    ) external returns (uint256 validationData);
}

// UserOperation 的核心字段（简化版）
struct UserOperation {
    address sender;
    uint256 nonce;
    bytes initCode;
    bytes callData;
    uint256 callGasLimit;
    uint256 verificationGasLimit;
    uint256 preVerificationGas;
    uint256 maxFeePerGas;
    uint256 maxPriorityFeePerGas;
    bytes paymasterAndData;
    bytes signature;
}

// Entry Point 合约负责处理 UserOperation
// Paymaster 合约负责赞助 gas 费用
// Bundler 负责打包 UserOperation 提交到链上
