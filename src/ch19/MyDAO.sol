// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";

/// @title MyDAO - DAO 治理合约
contract MyDAO is Governor, GovernorVotes, GovernorTimelockControl {
    constructor(IVotes _token, Timelock _timelock)
        Governor("MyDAO")
        GovernorVotes(_token)
        GovernorTimelockControl(_timelock)
    {}

    /// @notice 1 个区块后开始投票
    function votingDelay() public pure override returns (uint256) {
        return 1;
    }

    /// @notice 约 1 周的投票期
    function votingPeriod() public pure override returns (uint256) {
        return 45818;
    }

    /// @notice 法定人数 10 万票
    function quorum(uint256 blockNumber)
        public pure override returns (uint256)
    {
        return 100000e18;
    }

    /// @notice 至少持有 1000 票才能提案
    function proposalThreshold() public pure override returns (uint256) {
        return 1000e18;
    }
}
