// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

/// @title VaultFuzzTest - Foundry Fuzz Testing 示例
/// @notice 使用模糊测试自动发现 Vault 合约的边界条件问题
contract VaultFuzzTest is Test {
    Vault vault;

    function setUp() public {
        vault = new Vault();
    }

    // Foundry 会自动生成随机的 amount 参数
    function testFuzz_deposit(uint256 amount) public {
        vm.assume(amount > 0);
        vm.assume(amount < 1000 ether);

        vault.deposit{value: amount}();
        assertEq(vault.balances(address(this)), amount);
    }

    // 测试取款不超过余额
    function testFuzz_withdraw(uint256 depositAmount, uint256 withdrawAmount) public {
        vm.assume(depositAmount > 0 && depositAmount < 1000 ether);
        vm.assume(withdrawAmount <= depositAmount);

        vault.deposit{value: depositAmount}();
        vault.withdraw(withdrawAmount);
        assertEq(vault.balances(address(this)), depositAmount - withdrawAmount);
    }

    // 反向模糊测试：确保超过余额的取款一定失败
    function testFuzz_cannotWithdrawMoreThanBalance(
        uint256 depositAmount,
        uint256 withdrawAmount
    ) public {
        vm.assume(depositAmount > 0 && depositAmount < 1000 ether);
        vm.assume(withdrawAmount > depositAmount);

        vault.deposit{value: depositAmount}();
        vm.expectRevert();
        vault.withdraw(withdrawAmount);
    }
}

/// @title Vault - 被测试的合约（简化版）
contract Vault {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        require(msg.value > 0, "Must deposit something");
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }
}
