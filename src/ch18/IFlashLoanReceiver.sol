// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title IFlashLoanReceiver - 闪电贷接收者接口
interface IFlashLoanReceiver {
    /// @notice 闪电贷回调函数
    /// @param asset 借贷资产地址
    /// @param amount 借贷金额
    /// @param fee 手续费
    /// @return 是否成功处理
    function onFlashLoan(
        address asset,
        uint256 amount,
        uint256 fee
    ) external returns (bool);
}
