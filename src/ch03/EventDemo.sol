// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract EventDemo {
    // 3 个 indexed 参数 + 2 个非 indexed 参数
    event Transfer(
        address indexed from,     // Topic 1：可以直接过滤
        address indexed to,       // Topic 2
        uint256 indexed tokenId,  // Topic 3：最多 3 个 indexed
        uint256 amount,           // Data 区：不能按值过滤
        string memo               // Data 区
    );

    // 陷阱：indexed 的 string/array 只存 keccak256 哈希
    event NameChanged(
        string indexed oldName,   // ⚠️ 只存哈希，无法反推原始字符串
        string indexed newName    // ⚠️ 搜索时只能用哈希值匹配
    );

    function transfer(address to, uint256 tokenId, uint256 amount, string calldata memo) external {
        emit Transfer(msg.sender, to, tokenId, amount, memo);
    }
}
