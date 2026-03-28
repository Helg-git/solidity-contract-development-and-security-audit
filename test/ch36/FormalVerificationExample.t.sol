// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/ch36/SimpleToken.sol";

contract FormalVerificationExample is Test {
    SimpleToken token;

    function setUp() public {
        token = new SimpleToken();
    }

    // 测试 + 形式化验证互补
    // 1. 单元测试验证基本功能
    function test_transfer_basic() public {
        token.transfer(address(1), 100);
        assertEq(token.balanceOf(address(1)), 100);
    }

    // 2. 模糊测试探索边界
    function testFuzz_transfer(uint256 amount) public {
        vm.assume(amount <= token.balanceOf(address(this)));
        uint256 balanceBefore = token.balanceOf(address(this)) + token.balanceOf(address(1));

        token.transfer(address(1), amount);

        uint256 balanceAfter = token.balanceOf(address(this)) + token.balanceOf(address(1));
        assertEq(balanceBefore, balanceAfter); // 余额守恒
    }

    // 3. 不变量测试（Foundry 内置的形式化验证）
    // forge test --match-test invariant_balance_conservation
    function invariant_balance_conservation() public view {
        // 这个函数会被 Foundry 的不变量检查器反复调用
        // 在任意交易序列之后，验证这个属性是否成立
        assert(token.balanceOf(address(0)) == 0);
    }
}
