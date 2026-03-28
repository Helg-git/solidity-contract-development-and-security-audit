// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./IERC20Permit.sol";

/// @title 使用 permit 的场景（一笔交易完成授权+转账）
contract PermitClaimer {
    /// @notice 使用 permit 一次性完成授权+转账
    /// @param token 支持 permit 的 ERC20 代币
    /// @param amount 授权额度
    /// @param deadline 签名过期时间
    /// @param v, r, s ECDSA 签名
    function claimTokensWithPermit(
        IERC20Permit token,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        // 1. 先用 permit 设置授权（不需要 owner 发交易）
        token.permit(msg.sender, address(this), amount, deadline, v, r, s);
        // 2. 立即从 msg.sender 转账（同一笔交易）
        token.transferFrom(msg.sender, address(this), amount);
    }
}
