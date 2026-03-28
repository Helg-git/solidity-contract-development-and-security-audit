// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 部署在源链（如 Ethereum）
contract LockAndMintSource {
    mapping(address => uint256) public lockedBalances;
    address public targetBridge;

    event Locked(address indexed user, uint256 amount);

    function lock(uint256 amount) external payable {
        require(msg.value == amount, "Wrong amount");
        lockedBalances[msg.sender] += amount;
        emit Locked(msg.sender, amount);
    }
}
