// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {Counter} from "../../src/ch01/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    // 每个测试前自动执行（类似 JUnit 的 @Before）
    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function test_SetNumber() public {
        counter.setNumber(42);
        assertEq(counter.number(), 42);
    }
}
