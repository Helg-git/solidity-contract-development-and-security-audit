// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../../src/ch16/SimpleAMM.sol";

/// @title MockToken - 简单的 Mock ERC-20 代币，用于测试
contract MockToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

/// @title AMMTest - 用 Fuzz Testing 验证 AMM 核心不变量
contract AMMTest is Test {
    SimpleAMM amm;
    MockToken tokenX;
    MockToken tokenY;

    function setUp() public {
        tokenX = new MockToken("TokenX", "TX");
        tokenY = new MockToken("TokenY", "TY");
        amm = new SimpleAMM(address(tokenX), address(tokenY));

        tokenX.mint(address(this), 10000e18);
        tokenY.mint(address(this), 10000e18);
        tokenX.approve(address(amm), type(uint256).max);
        tokenY.approve(address(amm), type(uint256).max);

        amm.addLiquidity(10000e18, 10000e18);
    }

    /// @notice Fuzz 测试：随机 swap 不会违反不变量
    function testFuzz_swap(uint256 swapAmount) public {
        swapAmount = bound(swapAmount, 1, 1000e18);

        uint256 kBefore = amm.reserveX() * amm.reserveY();

        tokenX.approve(address(amm), swapAmount);
        amm.swapXForY(swapAmount);

        uint256 kAfter = amm.reserveX() * amm.reserveY();

        // 考虑手续费，kAfter 应该 >= kBefore
        // （因为手续费留在池子里，k 值实际上会增加）
        assertGe(kAfter, kBefore * 9997 / 10000); // 允许 0.03% 的舍入误差
    }
}
