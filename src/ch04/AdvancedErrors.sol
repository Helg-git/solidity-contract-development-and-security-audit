// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

error InsufficientBalance(uint256 available, uint256 required);
error Unauthorized(address caller);
error ZeroAddress();

contract AdvancedErrors {
    mapping(address => uint256) public balances;
    
    function transfer(address to, uint256 amount) external {
        uint256 bal = balances[msg.sender];
        if (amount > bal) revert InsufficientBalance(bal, amount);
        if (to == address(0)) revert ZeroAddress();
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}
