// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title WormholeBridge - 简化的 Wormhole 签名验证（漏洞示意）
/// @notice system 操作的签名验证不完整，攻击者构造虚假跨链消息
contract WormholeBridge {
    address public guardian;

    // 验证消息签名
    function verifyVM(bytes calldata vm) internal returns (bool) {
        bytes32 hash = hashVM(vm);
        bytes memory sig = getSignature(vm);
        address signer = recover(hash, sig);

        // 漏洞：system 操作的签名验证不完整
        // 当消息类型为 system 操作时，hashVM 跳过了部分字段的哈希计算
        require(signer == guardian, "Invalid signer");
        return true;
    }

    // 处理跨链消息
    function processMessage(bytes calldata vm) external {
        require(verifyVM(vm), "Verification failed");
        _mint(getRecipient(vm), getAmount(vm));
    }

    function hashVM(bytes calldata vm) internal pure returns (bytes32) {
        return keccak256(vm);
    }

    function getSignature(bytes calldata vm) internal pure returns (bytes memory) {
        return "";
    }

    function recover(bytes32 hash, bytes memory sig) internal pure returns (address) {
        return address(0);
    }

    function getRecipient(bytes calldata vm) internal pure returns (address) {
        return address(0);
    }

    function getAmount(bytes calldata vm) internal pure returns (uint256) {
        return 0;
    }

    function _mint(address to, uint256 amount) internal {
        // 简化的 mint 逻辑
    }
}
