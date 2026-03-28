// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract MemorySafeExample {
    // 安全写法
    function safeExample() public pure returns (bytes32) {
        bytes32 val;
        assembly ("memory-safe") {
            let ptr := mload(0x40)        // 读取空闲内存指针
            mstore(ptr, 0xdeadbeef)       // 写入空闲区域
            mstore(0x40, add(ptr, 32))    // 更新空闲指针
            val := mload(ptr)
        }
        return val;
    }
}
