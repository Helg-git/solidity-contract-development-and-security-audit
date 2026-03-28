// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title FixedWormholeBridge - 修复后的 Wormhole 签名验证
/// @notice 分离 system 消息和普通消息的验证逻辑，完善签名验证
contract FixedWormholeBridge {
    address public guardian;

    // 普通消息：只接受 guardian 签名
    function verifyVM(bytes calldata vm) internal returns (bool) {
        bytes32 hash = hashVM(vm);
        bytes memory sig = getSignature(vm);

        // 修复：明确指定预期的签名者，不接受任何"特权"地址
        address signer = recover(hash, sig);
        require(signer == guardian, "Invalid signer: not guardian");

        return true;
    }

    // 系统消息：通过单独的、受保护的方式处理
    function processSystemMessage(bytes calldata vm) external onlyOwner {
        _processInternal(vm);
    }

    function processMessage(bytes calldata vm) external {
        require(verifyVM(vm), "Verification failed");
        _mint(getRecipient(vm), getAmount(vm));
    }

    modifier onlyOwner() {
        require(msg.sender == guardian, "Not owner");
        _;
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

    function _mint(address to, uint256 amount) internal {}
    function _processInternal(bytes calldata vm) internal {}
}
