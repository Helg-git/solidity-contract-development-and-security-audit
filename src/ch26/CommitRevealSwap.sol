// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title CommitRevealSwap - commit-reveal 方案防 Front-running
/// @notice 用户先提交哈希，再揭示交易内容，防止攻击者抢跑
contract CommitRevealSwap {
    mapping(bytes32 => bool) public commits;
    mapping(bytes32 => SwapData) public swaps;

    struct SwapData {
        address user;
        address tokenIn;
        address tokenOut;
        uint256 amountIn;
        uint256 minAmountOut;
        bool revealed;
    }

    // 阶段 1：提交哈希
    function commit(bytes32 hash) external {
        require(!commits[hash], "Already committed");
        commits[hash] = true;
    }

    // 阶段 2：揭示交易内容
    function reveal(
        address tokenIn,
        address tokenOut,
        uint256 amountIn,
        uint256 minAmountOut,
        bytes32 secret
    ) external {
        // 验证哈希匹配
        bytes32 hash = keccak256(
            abi.encodePacked(
                msg.sender, tokenIn, tokenOut, amountIn, minAmountOut, secret
            )
        );
        require(commits[hash], "Not committed");
        require(!swaps[hash].revealed, "Already revealed");

        swaps[hash] = SwapData({
            user: msg.sender,
            tokenIn: tokenIn,
            tokenOut: tokenOut,
            amountIn: amountIn,
            minAmountOut: minAmountOut,
            revealed: true
        });

        // 执行实际交换
        _executeSwap(tokenIn, tokenOut, amountIn, minAmountOut);
    }

    function _executeSwap(
        address tokenIn,
        address tokenOut,
        uint256 amountIn,
        uint256 minAmountOut
    ) internal {
        // 实际的 DEX 交换逻辑
    }
}
