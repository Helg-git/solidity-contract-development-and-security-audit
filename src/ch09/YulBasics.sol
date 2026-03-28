// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract YulBasics {
    function example() public pure returns (uint256 result) {
        assembly {
            let x := 42         // 声明变量并赋值
            let y := add(x, 8)  // 调用 EVM 操作码 add
            result := y         // 返回值赋给 Solidity 变量
        }
    }

    function scopeDemo() public pure returns (uint256) {
        assembly {
            let a := 10      // a 作用域开始
            {
                let b := 20  // b 只在这个块内可见
                a := add(a, b) // a = 30
            }
            // b 在这里不可访问，a 仍然是 30
        }
    }

    function sumTo(uint256 n) public pure returns (uint256 total) {
        assembly {
            for { let i := 1 } lt(i, n) { i := add(i, 1) } {
                total := add(total, i)
            }
        }
    }
}
