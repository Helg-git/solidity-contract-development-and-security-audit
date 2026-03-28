// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract PackingDemo {
    // 不 Pack：4 个 slot
    struct UserBad {
        uint256 id; uint128 age; address owner; bool active;
    }

    // Pack：3 个 slot（省 25%）
    struct UserGood {
        bool active; address owner; uint128 age; uint256 id;
    }
}
