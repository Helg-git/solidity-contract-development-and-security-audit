// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract AssemblyCaller {
    // 用汇编调用外部合约的 balanceOf
    function getBalance(address token, address account)
        external view returns (uint256)
    {
        assembly ("memory-safe") {
            let selector := 0x70a08231  // balanceOf(address)
            mstore(0x00, selector)
            mstore(0x04, account)

            let success := staticcall(
                gas(),          // 剩余 gas
                token,          // 目标合约
                0x00,           // 输入数据起始
                0x24,           // 输入数据长度
                0x00,           // 输出写入位置
                0x20            // 期望返回 32 字节
            )
        }
    }
}
