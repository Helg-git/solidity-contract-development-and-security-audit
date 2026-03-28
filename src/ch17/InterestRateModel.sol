// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title InterestRateModel - 利用率驱动的利率模型
contract InterestRateModel {
    uint256 public constant OPTIMAL_UTILIZATION = 80e18; // 最优利用率 80%
    uint256 public constant BASE_RATE = 2e16;            // 基础利率 2%
    uint256 public constant SLOPE_1 = 4e16;              // 80%前斜率
    uint256 public constant SLOPE_2 = 75e16;             // 80%后斜率

    /// @notice 根据利用率计算借款利率
    function getBorrowRate(uint256 utilization) public pure returns (uint256) {
        if (utilization <= OPTIMAL_UTILIZATION) {
            return BASE_RATE + (utilization * SLOPE_1) / 1e18;
        } else {
            uint256 excessUtil = utilization - OPTIMAL_UTILIZATION;
            return BASE_RATE + (OPTIMAL_UTILIZATION * SLOPE_1) / 1e18
                + (excessUtil * SLOPE_2) / 1e18;
        }
    }

    /// @notice 根据利用率计算存款利率
    function getSupplyRate(uint256 utilization) public pure returns (uint256) {
        return getBorrowRate(utilization) * utilization / 1e18;
    }
}
