// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract HTLC {
    struct Swap {
        bytes32 secretHash;
        uint256 amount;
        uint256 timeout;
        address sender;
        address receiver;
        bool claimed;
        bool refunded;
    }

    mapping(bytes32 => Swap) public swaps;

    event SwapCreated(bytes32 indexed swapId, bytes32 secretHash);
    event SwapClaimed(bytes32 indexed swapId, bytes32 secret);
    event SwapRefunded(bytes32 indexed swapId);

    // 创建交换：锁定资金 + 设置哈希锁和时间锁
    function createSwap(
        bytes32 secretHash,
        uint256 timeout,
        address receiver
    ) external payable returns (bytes32) {
        bytes32 swapId = keccak256(abi.encodePacked(
            msg.sender, receiver, msg.value, block.timestamp, secretHash
        ));

        swaps[swapId] = Swap({
            secretHash: secretHash,
            amount: msg.value,
            timeout: timeout,
            sender: msg.sender,
            receiver: receiver,
            claimed: false,
            refunded: false
        });

        emit SwapCreated(swapId, secretHash);
        return swapId;
    }

    // 领取：提供正确的 preimage（原像）
    function claim(bytes32 swapId, bytes32 secret) external {
        Swap storage swap = swaps[swapId];
        require(swap.receiver == msg.sender, "Not receiver");
        require(!swap.claimed, "Already claimed");
        require(keccak256(abi.encodePacked(secret)) == swap.secretHash, "Wrong secret");

        swap.claimed = true;
        payable(msg.sender).transfer(swap.amount);
        emit SwapClaimed(swapId, secret);
    }

    // 退款：超时后发起方可取回
    function refund(bytes32 swapId) external {
        Swap storage swap = swaps[swapId];
        require(swap.sender == msg.sender, "Not sender");
        require(!swap.claimed, "Already claimed");
        require(!swap.refunded, "Already refunded");
        require(block.timestamp >= swap.timeout, "Not timed out");

        swap.refunded = true;
        payable(msg.sender).transfer(swap.amount);
        emit SwapRefunded(swapId);
    }
}
