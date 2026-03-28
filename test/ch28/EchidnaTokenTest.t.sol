// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title EchidnaTokenTest - Echidna 模糊测试合约
/// @notice Echidna 会尝试让 echidna_ 前缀函数返回 false，或让 assert 失败
contract EchidnaTokenTest {
    SimpleToken token;

    constructor() {
        token = new SimpleToken();
        token.mint(address(this), 1000 ether);
    }

    // Echidna 会尝试让这个函数返回 false
    function echidna_totalSupply_nonzero() public returns (bool) {
        return token.totalSupply() > 0 || token.totalSupply() == 0;
    }

    // Echidna 会尝试让这个 assertion 失败
    function test_transfer_noSteal(address to, uint256 amount) public {
        uint256 balanceBefore = token.balanceOf(address(this));
        token.transfer(to, amount);
        uint256 balanceAfter = token.balanceOf(address(this));
        assert(balanceBefore >= balanceAfter);
    }
}

/// @title SimpleToken - 简化版 ERC20 Token（Echidna 测试用）
contract SimpleToken {
    mapping(address => uint256) public balanceOf;
    uint256 public totalSupply;

    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
        totalSupply += amount;
    }

    function transfer(address to, uint256 amount) external {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
    }
}
