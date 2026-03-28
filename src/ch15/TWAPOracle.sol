// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title TWAPOracle - 使用 TWAP 防御价格操纵
contract TWAPOracle {
    struct PricePoint {
        uint256 timestamp;
        uint256 price;
    }

    PricePoint[] public priceHistory;
    uint256 public constant TWAP_WINDOW = 30 minutes;

    /// @notice 更新价格
    function updatePrice(uint256 newPrice) external {
        priceHistory.push(PricePoint(block.timestamp, newPrice));

        // 清理过期数据：从数组头部移除超出时间窗口的记录
        uint256 cutoff = block.timestamp - TWAP_WINDOW;
        while (priceHistory.length > 0 && priceHistory[0].timestamp < cutoff) {
            // 将末尾元素移到头部，然后弹出末尾（避免 shift 的 O(n) 开销）
            priceHistory[0] = priceHistory[priceHistory.length - 1];
            priceHistory.pop();
        }
    }

    /// @notice 计算时间加权平均价格
    function getTWAP() public view returns (uint256) {
        require(priceHistory.length > 0, "No prices");

        uint256 totalTime;
        uint256 weightedSum;

        for (uint256 i = 1; i < priceHistory.length; i++) {
            uint256 dt = priceHistory[i].timestamp - priceHistory[i - 1].timestamp;
            uint256 avgPrice = (priceHistory[i].price + priceHistory[i - 1].price) / 2;
            weightedSum += avgPrice * dt;
            totalTime += dt;
        }

        require(totalTime > 0, "No time span");
        return weightedSum / totalTime;
    }
}
