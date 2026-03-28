// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title SimpleVault - Ownable 模式，简单合约的最佳选择
contract SimpleVault is Ownable {
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
