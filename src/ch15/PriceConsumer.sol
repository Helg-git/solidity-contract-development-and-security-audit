// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/// @title PriceConsumer - 使用 Chainlink Price Feed 获取 ETH/USD 价格
contract PriceConsumer {
    AggregatorV3Interface internal priceFeed;

    constructor() {
        priceFeed = AggregatorV3Interface(
            0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        );
    }

    /// @notice 获取最新价格
    /// @return price 带有 8 位小数的价格（如 20000000000 = $2000.00）
    function getLatestPrice() public view returns (int256) {
        (
            uint80 roundId,
            int256 price,
            ,
            uint256 updatedAt,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();

        // 安全检查：价格数据不能太久
        require(block.timestamp - updatedAt < 1 hours, "Stale price");

        return price;
    }
}
