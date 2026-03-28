// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title IPriceOracle - 价格预言机接口
interface IPriceOracle {
    /// @notice 获取指定资产的价格
    function getPrice(address asset) external view returns (uint256);
}
