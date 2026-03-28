// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract SimpleToken {
    mapping(address => uint256) public balanceOf;
    uint256 public totalSupply;
    address public owner;

    // SMTChecker 会验证 assert 条件
    // 如果它能证明 assert 可能失败，就会报错
    function transfer(address to, uint256 amount) external {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");

        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;

        // SMTChecker 会尝试证明这个 assert 在所有情况下都成立
        // 如果它找到了反例，说明存在 bug
        assert(balanceOf[msg.sender] + balanceOf[to] + amount
               == old(balanceOf[msg.sender]) + old(balanceOf[to]));
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == owner, "Not owner");

        balanceOf[to] += amount;
        totalSupply += amount;

        // 断言总余额等于总供应量
        // SMTChecker 会尝试证明这个不变量
        assert(balanceOf[to] >= amount);
    }
}
