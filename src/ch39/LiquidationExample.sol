// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 清算条件判断与执行逻辑示例
contract LiquidationExample {
    uint256 public liquidationThreshold = 80; // 80% 清算阈值
    uint256 public closeFactor = 50; // 50% 单次清算比例
    uint256 public liquidationIncentive = 105; // 5% 清算折扣
    uint256 public price;

    mapping(address => uint256) public userDebt;
    mapping(address => uint256) public userCollateral;

    // 清算条件：借贷率 > 清算阈值
    // debtValue / collateralValue > liquidationThreshold
    function canLiquidate(address user) public view returns (bool) {
        uint256 debtValue = userDebt[user];
        uint256 collateralValue = userCollateral[user] * price;
        return debtValue * 1e18 > collateralValue * liquidationThreshold;
    }

    // 清算执行
    function liquidate(address user, uint256 repayAmount) external {
        require(canLiquidate(user), "Not liquidatable");
        uint256 maxRepay = userDebt[user] * closeFactor / 1e18;
        uint256 actualRepay = repayAmount < maxRepay ? repayAmount : maxRepay;
        // 计算可 seize 的抵押品
        uint256 seizeAmount = actualRepay * liquidationIncentive * price / 1e18;
        // 执行转移...
    }
}
