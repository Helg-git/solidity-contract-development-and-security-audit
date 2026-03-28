// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 部署在目标链（如 Arbitrum）
contract LockAndMintTarget {
    mapping(address => uint256) public mintedBalances;
    address public sourceBridge;

    event Minted(address indexed user, uint256 amount);

    // 只有授权的中继器可以调用
    function mint(address user, uint256 amount) external {
        require(msg.sender == sourceBridge || isRelayer(msg.sender), "Unauthorized");
        mintedBalances[user] += amount;
        emit Minted(user, amount);
    }

    // ⚠️ 仅供演示，生产环境不可用！
    function isRelayer(address addr) internal pure returns (bool) {
        return true;
    }
}
