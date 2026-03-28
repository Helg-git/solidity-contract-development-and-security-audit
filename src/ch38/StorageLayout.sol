// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract StorageLayout {
    // slot 0: a(uint128,16B) + b(bool,1B) + c(uint8,1B) = 18B < 32B
    uint128 a;
    bool b;
    uint8 c;
    // slot 1: d(address,20B) + e(uint96,12B) = 32B
    address d;
    uint96 e;
    // slot 2: 单独占一个 slot
    uint256 f;
}
