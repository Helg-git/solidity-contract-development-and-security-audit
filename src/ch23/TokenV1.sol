// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title TokenV1 - 0.8 默认溢出保护示例
/// @notice Solidity 0.8 编译器默认插入溢出检查，无需 SafeMath
contract TokenV1 {
    mapping(address => uint256) public balance;

    function deposit() external payable {
        // 0.8 编译器自动插入溢出检查
        balance[msg.sender] += msg.value;
    }

    /// @notice unchecked 的正确用法：循环变量递增不会溢出
    function safeLoop(uint256 n) external {
        uint256 sum;
        for (uint256 i = 0; i < n; ) {
            sum += i;
            unchecked { ++i; } // 节省 gas
        }
    }

    /// @notice unchecked 的错误用法：如果 amount 极大，会溢出
    function dangerousMint(uint256 amount) external {
        unchecked {
            balance[msg.sender] += amount; // 没有保护!
        }
    }
}
