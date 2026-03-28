// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Implementation {
    uint256 public value; // 槽位 0

    function setValue(uint256 _value) external {
        value = _value;
        // 这里写入的 value 实际上是调用者（代理合约）的 storage 槽位 0
    }
}

contract Proxy {
    uint256 public value; // 槽位 0 —— 和 Implementation 的布局必须一致！
    address public implementation; // 槽位 1

    function delegateSetValue(uint256 _value) external {
        // delegatecall：用 Implementation 的代码，操作 Proxy 的 storage
        (bool success, ) = implementation.delegatecall(
            abi.encodeWithSignature("setValue(uint256)", _value)
        );
        require(success, "delegatecall failed");
    }
}
