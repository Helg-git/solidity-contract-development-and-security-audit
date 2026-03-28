// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../../src/ch01/Counter.sol";

contract CounterTestV2 is Test {
    Counter counter;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(10);
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 11);
    }

    function test_Set() public {
        counter.setNumber(42);
        assertEq(counter.number(), 42);
    }

    function test_RevertWhenZero() public {
        vm.expectRevert("Value cannot be zero");
        counter.setNumber(0);
    }
}
