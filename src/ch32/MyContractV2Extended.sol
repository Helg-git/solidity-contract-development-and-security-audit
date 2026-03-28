// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./MyContractV1.sol";

contract MyContractV2Extended is MyContractV1 {
    uint256 public newValue;

    // 更新版本号常量
    uint256 public constant VERSION = 2;

    event Upgraded(uint256 newVersion);

    // Storage Gap：预留 50 个空槽
    uint256[50] private __gap;

    function initializeV2() public reinitializer(2) {
        newValue = 0;
        emit Upgraded(VERSION);
    }
}
