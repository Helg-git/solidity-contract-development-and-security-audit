// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ModifierOrder {
    uint256 public count = 0;

    modifier inc() {
        count += 1;  // 第一次执行
        _;          // 执行函数体或下一个 modifier
        count += 1;  // 最后执行
    }

    modifier double() {
        count *= 2;  // 第二次执行
        _;
        count *= 2;  // 倒数第二次
    }

    // 执行顺序：inc前 -> double前 -> 函数体 -> double后 -> inc后
    function foo() external inc double {
        count += 0;
    }
}
