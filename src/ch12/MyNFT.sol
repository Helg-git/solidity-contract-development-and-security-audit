// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/// @title MyNFT - 使用自增计数器生成 tokenId
contract MyNFT is ERC721 {
    uint256 private _nextTokenId;

    constructor() ERC721("MyNFT", "MNFT") {}

    /// @notice 自增铸造，tokenId 从 0 开始
    function mint(address to) external returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _mint(to, tokenId);
        return tokenId;
    }
}
