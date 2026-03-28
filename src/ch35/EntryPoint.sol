// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 简化的 IAccount 接口
interface IAccount {
    function validateUserOp(
        UserOperation calldata userOp,
        bytes32 userOpHash,
        uint256 missingAccountFunds
    ) external returns (uint256 validationData);
}

// 简化的 IPaymaster 接口
interface IPaymaster {
    function validatePaymasterOp(
        UserOperation calldata userOp,
        bytes32 userOpHash,
        uint256 maxCost
    ) external view returns (bytes memory context, uint256 validationData);
}

// 简化的 EntryPoint 逻辑
contract EntryPoint {
    uint256 internal constant SIG_VALIDATION_FAILED = 1;

    // Bundler 调用的入口函数
    function handleOps(UserOperation[] calldata ops, address payable beneficiary) external {
        for (uint256 i = 0; i < ops.length; i++) {
            UserOperation calldata op = ops[i];

            // 1. 验证：调用钱包合约的 validateUserOp
            uint256 validationData = IAccount(op.sender).validateUserOp{
                gas: op.verificationGasLimit
            }(op, opHash(op), missingAccountBalance);

            // 2. 如果有 Paymaster，验证 Paymaster 的意愿
            if (op.paymasterAndData.length > 0) {
                address paymaster = address(uint160(bytes20(op.paymasterAndData)));
                IPaymaster(paymaster).validatePaymasterOp(op, opHash(op), maxCost);
            }

            // 3. 执行：调用钱包合约执行 callData
            (bool success, ) = op.sender.call{gas: op.callGasLimit}(op.callData);
        }
    }

    function opHash(UserOperation calldata userOp) internal view returns (bytes32) {
        return keccak256(abi.encode(userOp));
    }

    function missingAccountBalance() internal pure returns (uint256) {
        return 0;
    }

    function maxCost() internal pure returns (uint256) {
        return 0;
    }
}
