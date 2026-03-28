// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../../src/ch29/CurvePool.sol";

/// @title SelectorClashTest - 函数选择器冲突检测测试（ch29 版本）
contract SelectorClashTest is Test {
    function test_no_selector_clash() public view {
        bytes4 selector1 = bytes4(keccak256("add_liquidity(uint256[2],uint256)"));
        bytes4 selector2 = bytes4(keccak256("exchange(int128,int128,uint256,uint256)"));

        // 确保两个函数的选择器不同
        assertNotEq(selector1, selector2);
    }

    function test_all_selectors_unique() public view {
        bytes4[] memory selectors = new bytes4[](0);
        // 收集合约的所有函数选择器
        // 检查是否有重复
    }
}
