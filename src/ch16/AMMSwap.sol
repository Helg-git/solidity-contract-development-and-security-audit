// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./SimpleAMM.sol";

/// @title AMMSwap - Swap 计算与执行
contract AMMSwap is SimpleAMM {
    /// @notice 计算输入 dx 能得到多少 dy（含手续费）
    function getAmountOut(uint256 dx, uint256 reserveX, uint256 reserveY) public pure returns (uint256 dy) {
        require(dx > 0, "Insufficient input");
        require(reserveX > 0 && reserveY > 0, "Insufficient liquidity");

        // 扣除手续费
        uint256 fee = dx * FEE_RATE / 10000;
        uint256 inputWithFee = dx - fee;

        // dy = y * dx / (x + dx)
        dy = (reserveY * inputWithFee) / (reserveX + inputWithFee);

        return dy;
    }

    /// @notice 执行 swap：X -> Y
    function swapXForY(uint256 dx) external returns (uint256 dy) {
        dy = getAmountOut(dx, reserveX, reserveY);

        tokenX.transferFrom(msg.sender, address(this), dx);
        tokenY.transfer(msg.sender, dy);

        reserveX += dx;
        reserveY -= dy;
    }

    /// @notice 执行 swap：Y -> X
    function swapYForX(uint256 dy) external returns (uint256 dx) {
        dx = getAmountOut(dy, reserveY, reserveX);

        tokenY.transferFrom(msg.sender, address(this), dy);
        tokenX.transfer(msg.sender, dx);

        reserveY += dy;
        reserveX -= dx;
    }
}
