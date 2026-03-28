// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../../src/ch07/GasModelDemo.sol";

contract GasDemoTest is Test {
    GasModelDemo demo;

    function setUp() public {
        demo = new GasModelDemo();
    }

    function test_increment() public {
        demo.demo(1);
    }

    function test_batchIncrement() public {
        demo.demo(10);
    }
}
