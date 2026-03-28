// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title PriceCalculator - 精度损失漏洞示例
/// @notice 整数除法截断小数，导致价格计算为 0
contract PriceCalculator {
    uint256 public pricePerItem = 1 ether; // 每件 1 ETH
    uint256 public totalItems = 3;         // 总共 3 件

    // 计算每件商品的价格（按总量均摊）
    // 1 ether / 3 = 0.333... 截断为 0！
    function getPricePerItem() public view returns (uint256) {
        return pricePerItem / totalItems;
    }
}
