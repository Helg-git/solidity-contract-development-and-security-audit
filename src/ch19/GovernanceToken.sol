// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

/// @title GovernanceToken - DAO 治理代币
contract GovernanceToken is ERC20Votes {
    constructor() ERC20("GovToken", "GOV") ERC20Permit("GovToken") {
        _mint(msg.sender, 1000000 * 1e18);
    }
}
