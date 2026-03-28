// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title TransientReentrancyGuard - Transient Storage 版重入锁
/// @notice 使用 EIP-1153 Transient Storage 实现，gas 成本极低（需 Cancun 升级）
abstract contract TransientReentrancyGuard {
    uint8 constant _NOT_ENTERED = 0;
    uint8 constant _ENTERED = 1;

    modifier nonReentrant() {
        assembly {
            // tload(0) 读取临时存储位置 0
            if tload(0) { revert(0, 0) }
            // tstore(0, 1) 写入临时存储位置 0
            tstore(0, 1)
        }
        _;
        assembly {
            // 执行完毕，清除标记
            tstore(0, 0)
        }
    }
}
