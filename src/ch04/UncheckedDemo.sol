// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract UncheckedDemo {
    uint256 public total;
    
    function process(uint256[] memory data) external {
        uint256 len = data.length;
        for (uint256 i = 0; i < len; ) {
            total += data[i];
            unchecked { ++i; } // 安全：length 保证不会溢出
        }
    }
}
