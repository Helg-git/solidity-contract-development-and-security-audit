// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract GasOptimization {
    uint256[] public items;
    
    function sum() external view returns (uint256 total) {
        uint256 len = items.length; // 读一次 storage
        uint256[] memory _items = items; // 缓存到 memory
        for (uint256 i = 0; i < len; ) {
            total += _items[i];
            unchecked { ++i; } // unchecked 省溢出检查
        }
    }
}
