// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/AccessControl.sol";

bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");

/// @title Vault - 三级权限分隔：admin vs operator vs user
contract Vault is AccessControl {
    uint256 public withdrawalLimit;

    constructor() {
        _grantRole(ADMIN_ROLE, msg.sender);
        _setRoleAdmin(ADMIN_ROLE, DEFAULT_ADMIN_ROLE);
        _setRoleAdmin(OPERATOR_ROLE, ADMIN_ROLE);
        withdrawalLimit = 10 ether; // 默认每日限额 10 ETH
    }

    /// @notice 管理员设置参数
    function setWithdrawalLimit(uint256 limit) external onlyRole(ADMIN_ROLE) {
        withdrawalLimit = limit;
    }

    /// @notice 操作员执行提现（受限额约束）
    function withdraw(address to, uint256 amount) external onlyRole(OPERATOR_ROLE) {
        require(amount <= withdrawalLimit, "Exceeds limit");
        payable(to).transfer(amount);
    }
}
