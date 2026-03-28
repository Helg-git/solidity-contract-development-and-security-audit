// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

/// @title NFTMarket - 简化的 NFT 市场合约
contract NFTMarket is ERC721Holder {
    uint256 private _listingId;

    struct Listing {
        address seller;
        address nftContract;
        uint256 tokenId;
        uint256 price;
        bool active;
    }

    mapping(uint256 => Listing) public listings;
    uint256 public feeRate = 250; // 2.5%，精度 10000

    /// @notice 卖家挂单：先 approve 市场合约，再调用 list
    function list(address nftContract, uint256 tokenId, uint256 price) external {
        IERC721(nftContract).safeTransferFrom(msg.sender, address(this), tokenId);
        listings[_listingId] = Listing(msg.sender, nftContract, tokenId, price, true);
        _listingId++;
    }

    /// @notice 买家购买
    function buy(uint256 listingId) external payable {
        Listing storage l = listings[listingId];
        require(l.active, "Listing not active");
        require(msg.value >= l.price, "Insufficient payment");

        l.active = false;
        IERC721(l.nftContract).safeTransferFrom(address(this), msg.sender, l.tokenId);

        uint256 fee = msg.value * feeRate / 10000;
        payable(l.seller).transfer(msg.value - fee);
    }

    /// @notice 卖家取消挂单
    function cancel(uint256 listingId) external {
        Listing storage l = listings[listingId];
        require(msg.sender == l.seller, "Not seller");
        require(l.active, "Not active");

        l.active = false;
        IERC721(l.nftContract).safeTransferFrom(address(this), l.seller, l.tokenId);
    }
}
