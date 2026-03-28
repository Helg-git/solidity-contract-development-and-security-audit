// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title ReentrancyGuard - Storage 版重入锁（OpenZeppelin 风格）
/// @notice 使用 storage 变量记录重入状态，兼容性好但 gas 较高
abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;
    uint256 private _status;

    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }
}
