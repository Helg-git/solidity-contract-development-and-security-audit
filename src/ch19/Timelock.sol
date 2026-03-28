// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title Timelock - DAO 治理中的 Timelock 合约
contract Timelock {
    uint256 public constant MIN_DELAY = 2 days;
    mapping(bytes32 => bool) public queuedTransactions;
    mapping(bytes32 => uint256) public _timestamps;

    /// @notice 将交易入队等待执行
    function queue(
        address target,
        uint256 value,
        bytes calldata data,
        uint256 predecessor,
        bytes32 salt,
        uint256 delay
    ) external {
        require(delay >= MIN_DELAY, "Insufficient delay");
        bytes32 id = keccak256(abi.encode(target, value, data, predecessor, salt));
        queuedTransactions[id] = true;
        _timestamps[id] = block.timestamp + delay;
    }

    /// @notice 延迟期过后执行交易
    function execute(
        address target,
        uint256 value,
        bytes calldata data,
        uint256 predecessor,
        bytes32 salt
    ) external payable {
        bytes32 id = keccak256(abi.encode(target, value, data, predecessor, salt));
        require(queuedTransactions[id], "Not queued");
        require(block.timestamp >= _timestamps[id], "Delay not passed");
        (bool success,) = target.call{value: value}(data);
        require(success, "Execution failed");
        queuedTransactions[id] = false;
    }
}
