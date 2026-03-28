// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title ERC-4626 代币化金库标准接口
/// @notice 让 yield-bearing 协议有一个统一的接口
interface IERC4626 {
    /// @notice 金库底层资产
    function asset() external view returns (address);

    /// @notice 存入资产，返回获得的份额
    function deposit(uint256 assets, address receiver) external returns (uint256 shares);

    /// @notice 取出资产
    function withdraw(uint256 assets, address receiver, address owner) external returns (uint256 shares);

    /// @notice 存入获得多少份额（查询）
    function convertToShares(uint256 assets) external view returns (uint256 shares);

    /// @notice 份额能取多少资产（查询）
    function convertToAssets(uint256 shares) external view returns (uint256 assets);
}
