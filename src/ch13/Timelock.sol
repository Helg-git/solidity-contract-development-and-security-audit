// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title Timelock - 延迟执行合约，给恶意操作一个缓冲期
contract Timelock {
    uint256 public constant MIN_DELAY = 2 days;

    mapping(bytes32 => bool) public queued;

    /// @notice 生成交易的唯一哈希
    function _getId(
        address target,
        uint256 value,
        bytes calldata data,
        uint256 eta
    ) internal pure returns (bytes32) {
        return keccak256(abi.encode(target, value, data, eta));
    }

    /// @notice 交易入队
    function queue(address target, uint256 value, bytes calldata data, uint256 eta) external {
        require(eta >= block.timestamp + MIN_DELAY, "Too soon");
        require(eta <= block.timestamp + 30 days, "Too far");

        bytes32 id = _getId(target, value, data, eta);
        queued[id] = true;
    }

    /// @notice 延迟期过后执行交易
    function execute(address target, uint256 value, bytes calldata data, uint256 eta) external payable {
        require(block.timestamp >= eta, "Too early");
        require(block.timestamp <= eta + 14 days, "Stale");

        bytes32 id = _getId(target, value, data, eta);
        require(queued[id], "Not queued");
        queued[id] = false;

        (bool success,) = target.call{value: value}(data);
        require(success, "Failed");
    }

    /// @notice 取消已入队的交易
    function cancel(address target, uint256 value, bytes calldata data, uint256 eta) external {
        bytes32 id = _getId(target, value, data, eta);
        queued[id] = false;
    }
}
