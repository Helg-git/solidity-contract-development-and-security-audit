// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 代理合约：存储数据 + 转发调用
contract Proxy {
    address public implementation; // 槽位 0：逻辑合约地址
    address public admin;          // 槽位 1：管理员

    constructor(address _implementation) {
        implementation = _implementation;
        admin = msg.sender;
    }

    // 管理员升级逻辑合约
    function upgradeTo(address _newImpl) external {
        require(msg.sender == admin, "not admin");
        implementation = _newImpl;
    }

    // fallback：所有未匹配的函数调用都走这里
    fallback() external payable {
        (bool success, ) = implementation.delegatecall(msg.data);
        require(success, "delegatecall failed");
    }
}

// 逻辑合约 V1
contract LogicV1 {
    uint256 public value; // 槽位 2（代理合约前两个槽位已被占用）

    function setValue(uint256 _value) external {
        value = _value;
    }
}
