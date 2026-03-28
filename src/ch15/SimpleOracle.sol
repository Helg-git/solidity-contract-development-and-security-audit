// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title SimpleOracle - 简化的预言机合约
contract SimpleOracle {
    address public owner;
    int256 public price;
    uint256 public lastUpdated;

    event PriceUpdated(int256 newPrice, uint256 timestamp);

    constructor() {
        owner = msg.sender;
    }

    /// @notice 预言机节点更新价格
    function updatePrice(int256 _price) external {
        require(msg.sender == owner, "Only oracle");
        require(_price > 0, "Invalid price");
        price = _price;
        lastUpdated = block.timestamp;
        emit PriceUpdated(_price, block.timestamp);
    }

    /// @notice 消费者获取价格
    function getPrice() external view returns (int256) {
        require(lastUpdated > 0, "No price set");
        require(block.timestamp - lastUpdated < 1 hours, "Stale price");
        return price;
    }
}
