// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title FlashLoanDefense - 闪电贷防御：一次性回调限制
contract FlashLoanDefense {
    mapping(address => bool) public hasReceivedFlashLoan;

    /// @notice 限制每个地址只能接收一次闪电贷
    function flashLoan(address receiver, uint256 amount) external {
        require(!hasReceivedFlashLoan[receiver], "Already received");
        hasReceivedFlashLoan[receiver] = true;
        // ... 执行闪电贷逻辑
    }
}
