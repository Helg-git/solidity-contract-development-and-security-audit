// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ShortCircuitEval {
    // 优化前：贵的检查放前面
    function badCheck(address user) external view returns (bool) {
        return expensiveCheck() && user != address(0);
    }

    // 优化后：便宜的检查放前面
    function goodCheck(address user) external view returns (bool) {
        return user != address(0) && expensiveCheck();
        // user==0 时直接返回 false，不执行 expensiveCheck
    }

    function expensiveCheck() internal view returns (bool) {
        // 模拟一个昂贵的检查
        return true;
    }
}
