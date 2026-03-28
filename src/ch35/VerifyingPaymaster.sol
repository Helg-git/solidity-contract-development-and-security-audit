// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./UserOperation.sol";
import "./EntryPoint.sol";

contract VerifyingPaymaster is IPaymaster {
    address public owner;
    mapping(bytes32 => uint256) public hashes;

    // 设置可信签名者（通常是 dApp 的后端服务）
    address public verifyingSigner;

    EntryPoint private immutable entryPoint;

    uint256 internal constant SIG_VALIDATION_FAILED = 1;

    constructor(address _entryPoint, address _signer) {
        entryPoint = EntryPoint(payable(_entryPoint));
        owner = msg.sender;
        verifyingSigner = _signer;
    }

    // 验证是否愿意为这笔操作代付 gas
    function validatePaymasterUserOp(
        UserOperation calldata userOp,
        bytes32 userOpHash,
        uint256 maxCost
    ) external view override returns (bytes memory context, uint256 validationData) {
        // userOp.paymasterAndData 的前 20 字节是 Paymaster 地址
        // 后面的字节是 dApp 后端的签名
        bytes memory sig = userOp.paymasterAndData[20:];

        // 验证签名：只有可信的 dApp 后端才能让这个 Paymaster 代付
        bytes32 hash = userOpHash.toEthSignedMessageHash();
        if (verifyingSigner != hash.recover(sig)) {
            return ("", SIG_VALIDATION_FAILED);
        }

        // 检查 Paymaster 的余额是否足够
        if (address(this).balance < maxCost) {
            return ("", SIG_VALIDATION_FAILED);
        }

        // 返回 context（传递给 postOp）
        return ("", 0); // 0 = 验证通过
    }

    // dApp 后端充值 Paymaster
    function deposit() external payable {}
}
