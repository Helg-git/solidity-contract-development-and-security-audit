// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

// 演示：修复 unchecked return value 的标准写法
contract SafeTransferExample {
    using SafeERC20 for IERC20;

    // 修复前：直接调用 transfer，没有检查返回值
    // IERC20(token).transfer(to, amount);  // ❌ 危险

    // 修复后：使用 SafeERC20 的 safeTransfer，自动检查返回值
    function safeTransferToken(address token, address to, uint256 amount) external {
        IERC20(token).safeTransfer(to, amount); // ✅ 安全
    }
}
