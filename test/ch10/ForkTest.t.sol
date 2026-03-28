// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

interface IERC20 {
    function balanceOf(address) external view returns (uint256);
    function transfer(address, uint256) external returns (bool);
}

contract ForkTest is Test {
    IERC20 usdc;
    address whale = 0x28C6c06298d514Db089934071355E5743bf21d60;

    function setUp() public {
        vm.createSelectFork("mainnet");
        usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    }

    function test_WhaleBalance() public view {
        assertTrue(usdc.balanceOf(whale) > 1000e6);
    }

    function test_TransferFromWhale() public {
        uint256 amount = 1000e6;
        vm.deal(whale, 1 ether);
        vm.prank(whale);
        usdc.transfer(address(this), amount);
        assertEq(usdc.balanceOf(address(this)), amount);
    }
}
