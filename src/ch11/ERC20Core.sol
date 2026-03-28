// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title OpenZeppelin 的核心设计模式（简化版）
/// @notice 演示 private 状态 + internal 操作函数 + virtual 钩子的设计模式
abstract contract ERC20 {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /// @notice 用 private + getter 函数，而不是 public mapping
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /// @notice transfer 调用 _transfer，_transfer 里调用钩子
    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "ERC20: transfer from zero");
        require(to != address(0), "ERC20: transfer to zero");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: insufficient balance");
        unchecked {
            _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    /// @notice 钩子函数，子合约可以重写
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}
