// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract BytesDemo {
    // 适合用 bytes32：长度固定且已知
    bytes32 public constant HASH_ZERO = keccak256("");

    // 适合用 bytes：长度不固定
    function process(bytes memory data) external pure returns (bytes32) {
        // 动态数据，长度不固定
        return keccak256(data);
    }
}
