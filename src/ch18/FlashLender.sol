// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IFlashLoanReceiver.sol";

/// @title FlashLender - 闪电贷核心合约
contract FlashLender {
    mapping(address => uint256) public balances;
    uint256 public constant FEE_RATE = 9; // 0.09%

    /// @notice 执行闪电贷
    /// @param asset 借贷资产地址
    /// @param amount 借贷金额
    function flashLoan(address asset, uint256 amount) external {
        uint256 balanceBefore = balances[asset];
        require(balances[asset] >= amount, "Insufficient balance");
        uint256 fee = amount * FEE_RATE / 10000;

        IERC20(asset).transfer(msg.sender, amount);
        require(
            IFlashLoanReceiver(msg.sender).onFlashLoan(asset, amount, fee),
            "Callback failed"
        );
        require(
            IERC20(asset).balanceOf(address(this)) >= balanceBefore + fee,
            "Insufficient repayment"
        );
    }
}
