// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title TransparentProxy - 透明代理的简化实现
/// @notice 教学简化版。生产环境请使用 OpenZeppelin 的 TransparentUpgradeableProxy
contract TransparentProxy {
    address public implementation;
    address public admin;

    constructor(address _impl, address _admin) {
        implementation = _impl;
        admin = _admin;
    }

    fallback() external payable {
        // admin 的调用不转发（防止选择器冲突）
        require(msg.sender != admin, "Admin cannot fallback");

        // 普通用户调用：delegatecall 到逻辑合约
        (bool success,) = implementation.delegatecall(msg.data);
        require(success, "Delegatecall failed");
    }

    /// @notice 管理员升级逻辑合约
    function upgradeTo(address newImpl) external {
        require(msg.sender == admin, "Not admin");
        implementation = newImpl;
    }
}
