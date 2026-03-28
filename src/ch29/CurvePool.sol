// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title CurvePool - 简化的 Curve 池子（漏洞示意）
/// @notice Vyper 0.2.15-0.3.0 的 nonReentrant 实现存在缺陷，导致重入锁失效
contract CurvePool {
    bool private _locked;

    modifier nonReentrant() {
        require(!_locked, "Reentrancy");
        _locked = true;
        _;
        _locked = false;
    }

    // 函数 A：添加流动性
    function add_liquidity(uint256[2] calldata amounts, uint256 min_mint_amount)
        external
        nonReentrant
    {
        // ... 处理添加流动性逻辑
        // 漏洞：内部调用了 ERC20 的 transferFrom
        // 如果代币的 transferFrom 触发回调，重入锁可能已被释放
    }

    // 函数 B：兑换代币
    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy)
        external
        nonReentrant
    {
        // ... 处理兑换逻辑
    }
}
