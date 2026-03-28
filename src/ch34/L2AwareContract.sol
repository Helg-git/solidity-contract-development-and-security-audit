// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract L2AwareContract {
    uint256 public value;

    // 注意 1: L2 的 block.timestamp 和 L1 不同步
    function timeAware() external view returns (uint256) {
        return block.timestamp;
    }

    // 注意 2: L2 的 block.number 是 L2 的区块号，不是 L1 的
    function blockNum() external view returns (uint256) {
        return block.number;
    }

    // 注意 3: gas 相关
    function gasCheck() external view returns (uint256) {
        return gasleft();
    }
}
