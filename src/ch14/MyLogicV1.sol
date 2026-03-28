// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/// @title MyLogicV1 - UUPS 逻辑合约必须包含升级函数
contract MyLogicV1 is UUPSUpgradeable {
    uint256 public value;

    function initialize() public {
        // 用 initialize 代替 constructor
        value = 100;
    }

    function getVersion() external pure returns (string memory) {
        return "V1";
    }

    /// @notice UUPS 要求逻辑合约实现此函数
    function _authorizeUpgrade(address) internal override {
        // 权限检查：只有 proxy 的 admin 才能升级
        // 通常配合 AccessControl 使用
    }
}
