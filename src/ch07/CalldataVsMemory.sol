// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract CalldataVsMemory {
    // memory：复制参数到 memory，花费 3 Gas/byte
    function processMemory(uint256[] memory data) external pure returns (uint256) {
        uint256 s;
        for (uint256 i = 0; i < data.length; i++) { s += data[i]; }
        return s;
    }

    // calldata：直接引用调用数据，零复制成本
    function processCalldata(uint256[] calldata data) external pure returns (uint256) {
        uint256 s;
        for (uint256 i = 0; i < data.length; i++) { s += data[i]; }
        return s;
    }
}
