// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract StringTraps {
    // 陷阱一：bytes(string).length 返回的是字节数，不是字符数
    function getByteLength(string memory s) external pure returns (uint256) {
        // "你好" 的 bytes(s).length == 6，不是 2（每个中文字符 3 字节）
        return bytes(s).length;
    }

    // 陷阱二：string 不能直接比较相等
    // 正确做法：用 keccak256 哈希后再比较
    function stringsEqual(string memory a, string memory b) external pure returns (bool) {
        // string 是引用类型，== 比较的是指针地址而不是内容
        // 用 keccak256 哈希后再比较才是正确的做法
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
}
