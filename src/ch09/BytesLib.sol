// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library BytesLib {
    function concat(bytes memory a, bytes memory b)
        internal pure returns (bytes memory)
    {
        assembly ("memory-safe") {
            let len := add(mload(a), mload(b))
            let result := mload(0x40)
            mstore(result, len)

            let aData := add(a, 32)
            let bData := add(b, 32)
            let dest := add(result, 32)

            // mcopy 是 0.8.24+ 的内存复制操作码
            mcopy(dest, aData, mload(a))
            mcopy(add(dest, mload(a)), bData, mload(b))

            // 更新空闲指针（对齐到 32 字节）
            mstore(0x40, add(result, and(add(add(len, 32), 31), not(31))))
            return(add(result, 32), len)
        }
    }
}
