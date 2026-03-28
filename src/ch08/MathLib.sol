// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library MathLib {
    // internal 函数会被内联，不产生调用
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    // 注意：library 函数只能是 internal 或 public
    // public 函数会被编译成 delegatecall
}

contract MyContract {
    using MathLib for uint256;

    function compare(uint256 a, uint256 b) public pure returns (uint256) {
        // 编译后等价于 MathLib.max(a, b)
        // internal 函数直接内联，没有额外调用开销
        return a.max(b);
    }
}
