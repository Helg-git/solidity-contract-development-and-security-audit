// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract GasModelDemo {
    uint256 private count; // storage 槽位 0

    function demo(uint256 newVal) external {
        // 第一次 SLOAD：冷访问 2100 Gas
        // 同一交易内再次 SLOAD：热访问 100 Gas
        uint256 current = count;
        // SSTORE Gas 取决于 current 和 newVal 的关系
        count = newVal;
    }

    function zeroOut() external {
        // 从非零改为零（热访问）：净消耗 200 Gas（5000 - 4800 退款）
        count = 0;
    }
}
