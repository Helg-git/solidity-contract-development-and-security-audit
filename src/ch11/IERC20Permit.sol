// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title EIP-2612 Permit 接口
/// @notice 允许通过链下签名进行授权，一笔交易完成授权+操作
interface IERC20Permit {
    /// @notice permit 函数签名
    /// @param owner 代币持有者
    /// @param spender 被授权方
    /// @param value 授权额度
    /// @param deadline 签名过期时间
    /// @param v, r, s ECDSA 签名
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
}
