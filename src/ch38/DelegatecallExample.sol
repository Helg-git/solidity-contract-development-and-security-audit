// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Implementation {
    uint256 public value; // slot 0
    function setValue(uint256 _value) external {
        value = _value;
    }
}

contract Proxy {
    uint256 public value; // slot 0 - 必须与 Implementation 一致
    address public implementation; // slot 1

    function setValue(uint256 _value) external {
        (bool success, ) = implementation.delegatecall(
            abi.encodeWithSignature("setValue(uint256)", _value)
        );
        require(success, "delegatecall failed");
    }
}
