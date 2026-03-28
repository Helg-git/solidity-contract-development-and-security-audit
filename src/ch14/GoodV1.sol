// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/// @title GoodV1 - 正确做法：使用 initialize + initializer
contract GoodV1 is Initializable {
    uint256 public owner;

    /// @notice initializer 保证只执行一次
    function initialize() public initializer {
        owner = msg.sender;
    }
}
