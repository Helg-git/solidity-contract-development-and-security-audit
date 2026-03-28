// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../../src/ch25/ImplementationV1.sol";
import "../../src/ch25/Proxy.sol";

/// @title SelectorClashTest - 函数选择器冲突检测测试
contract SelectorClashTest is Test {
    function test_checkSelectorClash() public view {
        // 获取代理合约的所有函数选择器
        bytes4[] memory proxySelectors = new bytes4[](2);
        proxySelectors[0] = Proxy.upgradeTo.selector;
        proxySelectors[1] = Proxy.owner.selector;

        // 获取实现合约的所有函数选择器
        bytes4[] memory implSelectors = new bytes4[](2);
        implSelectors[0] = ImplementationV1.transfer.selector;
        implSelectors[1] = ImplementationV1.initialize.selector;

        // 检查是否有冲突
        for (uint i = 0; i < proxySelectors.length; i++) {
            for (uint j = 0; j < implSelectors.length; j++) {
                if (proxySelectors[i] == implSelectors[j]) {
                    fail("Selector clash detected!");
                }
            }
        }
    }
}
