// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IFlashLoanReceiver.sol";

/// @title FlashBorrower - 闪电贷借款人示例（套利）
contract FlashBorrower is IFlashLoanReceiver {
    address public constant DEX_A = address(0);
    address public constant DEX_B = address(0);
    address public constant targetToken = address(0);

    /// @notice 闪电贷回调：在不同 DEX 之间套利
    function onFlashLoan(
        address asset,
        uint256 amount,
        uint256 fee
    ) external returns (bool) {
        // 1. 在 DEX A 用借来的资产买入目标代币
        // IUniswap(DEX_A).swap(asset, targetToken, amount);

        // 2. 在 DEX B 卖出目标代币换回原资产
        // uint256 received = IUniswap(DEX_B).swap(targetToken, asset, targetAmount);

        // 3. 还本付息
        IERC20(asset).transfer(msg.sender, amount + fee);
        return true;
    }
}
