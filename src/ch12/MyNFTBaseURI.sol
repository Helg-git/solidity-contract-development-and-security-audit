// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

/// @title MyNFTBaseURI - BaseURI 模式的 metadata 返回
contract MyNFTBaseURI is ERC721URIStorage {
    string private _baseURI;

    constructor() ERC721("MyNFT", "MNFT") {
        _baseURI = "https://api.mynft.com/metadata/";
    }

    /// @notice tokenURI(42) 返回 "https://api.mynft.com/metadata/42"
    function _baseURI() internal view override returns (string memory) {
        return _baseURI;
    }
}
