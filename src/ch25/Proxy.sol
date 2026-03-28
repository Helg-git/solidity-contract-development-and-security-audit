// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title Proxy - 有权限提升漏洞的代理合约
/// @notice upgradeTo 没有权限检查，任何人都可以替换实现合约
contract Proxy {
    address public implementation;
    address public owner;

    constructor(address _impl) {
        implementation = _impl;
        owner = msg.sender;
    }

    // 危险：任何人都可以更换实现合约
    function upgradeTo(address _newImpl) external {
        implementation = _newImpl;
    }

    fallback() external payable {
        (bool success, ) = implementation.delegatecall(msg.data);
        require(success);
    }
}
