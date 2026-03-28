// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract V1 {
    uint256 public x;
    uint256[49] private __gap;
}

contract V2 is V1 {
    uint256 public y; // slot 50，不会覆盖 x
}
