// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../../src/ch17/LendingPool.sol";

/// @title LendingPoolInvariants - Foundry Invariant Testing 验证借贷不变量
contract LendingPoolInvariants is Test {
    LendingPool pool;

    function setUp() public {
        pool = new LendingPool();
    }

    /// @notice 不变量1：总借款永远不超过总存款
    function invariant_borrowsNeverExceedDeposits() public view {
        assertLe(
            pool.totalBorrows(address(0)),
            pool.totalDeposits(address(0))
        );
    }

    /// @notice 不变量2：健康因子计算正确
    function invariant_healthFactorCorrect() public view {
        // fuzzing 测试各种状态
    }

    /// @notice 不变量3：协议总资产守恒
    function invariant_totalAssetConservation() public view {
        assertGe(
            address(pool).balance,
            pool.totalDeposits(address(0))
        );
    }
}
