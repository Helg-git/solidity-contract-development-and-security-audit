// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./UserOperation.sol";
import "./EntryPoint.sol";

// 简化的钱包合约
contract SimpleAccount is IAccount {
    address public owner;
    EntryPoint private immutable entryPoint;

    uint256 internal constant SIG_VALIDATION_FAILED = 1;

    constructor(address _entryPoint) {
        entryPoint = EntryPoint(payable(_entryPoint));
    }

    function validateUserOp(
        UserOperation calldata userOp,
        bytes32 userOpHash,
        uint256 missingAccountFunds
    ) external returns (uint256 validationData) {
        // 1. 验证只有 EntryPoint 可以调用
        require(msg.sender == address(entryPoint), "Not EntryPoint");

        // 2. 验证签名（可以使用任何验证逻辑）
        bytes32 hash = userOpHash.toEthSignedMessageHash();
        if (owner != hash.recover(userOp.signature)) {
            return SIG_VALIDATION_FAILED;
        }

        // 3. 如果需要预存 gas 费，转入 ETH
        if (missingAccountFunds > 0) {
            payable(address(entryPoint)).sendValue(missingAccountFunds);
        }

        return 0; // 验证通过
    }

    function execute(bytes calldata callData) external {
        // 只有 owner 或 EntryPoint 可以调用
        require(msg.sender == owner || msg.sender == address(entryPoint), "Unauthorized");
        (bool success, bytes memory data) = address(this).call(callData);
        // 执行结果处理...
    }
}
