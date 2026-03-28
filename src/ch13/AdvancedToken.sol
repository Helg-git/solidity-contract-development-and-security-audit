// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/AccessControl.sol";

bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

/// @title AdvancedToken - AccessControl 模式，多角色复杂协议
contract AdvancedToken is AccessControl {
    constructor() {
        _grantRole(MINTER_ROLE, msg.sender);
    }

    /// @notice 只有 MINTER 角色才能铸造
    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {}

    /// @notice 管理员可以添加新的 MINTER
    function addMinter(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(MINTER_ROLE, account);
    }
}
