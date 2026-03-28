// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

/// @title GameItems - ERC-1155 多代币合约，支持批量操作
contract GameItems is ERC1155 {
    uint256 public constant GOLD = 0;      // 金币（同质化）
    uint256 public constant SWORD = 1;     // 传说之剑（唯一）
    uint256 public constant POTION = 3;    // 药水（半同质化）

    constructor() ERC1155("https://game.example/api/item/{id}.json") {
        _mint(msg.sender, GOLD, 10**18, "");
        _mint(msg.sender, SWORD, 1, "");
        _mint(msg.sender, POTION, 100, "");
    }
}
