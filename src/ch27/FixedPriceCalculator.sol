// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title FixedPriceCalculator - 精度损失修复方案
/// @notice 使用先乘后除和向上取整来修复精度问题
contract FixedPriceCalculator {
    uint256 public pricePerItem = 1 ether; // 10^18 wei
    uint256 public totalItems = 3;

    /// @notice 正确做法一：先乘后除
    function getTotalPrice(uint256 quantity) public view returns (uint256) {
        return (pricePerItem * quantity) / totalItems;
    }

    /// @notice 正确做法二：向上取整（适用于"宁多收不少收"的场景）
    function getTotalPriceCeil(uint256 quantity) public view returns (uint256) {
        return (pricePerItem * quantity + totalItems - 1) / totalItems;
    }
}
