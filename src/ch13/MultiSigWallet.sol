// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title MultiSigWallet - 简化的多签钱包合约
contract MultiSigWallet {
    address[] public owners;
    uint256 public required;
    uint256 private _txId;

    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool executed;
    }

    mapping(uint256 => mapping(address => bool)) public confirmations;
    mapping(uint256 => Transaction) public transactions;
    mapping(address => bool) public isOwner;

    event SubmitTransaction(address indexed owner, uint256 indexed txId);
    event ExecuteTransaction(uint256 indexed txId);

    constructor(address[] memory _owners, uint256 _required) {
        require(_owners.length >= _required, "Not enough owners");
        owners = _owners;
        required = _required;
        for (uint256 i = 0; i < _owners.length; i++) {
            isOwner[_owners[i]] = true;
        }
    }

    function submitTransaction(address to, uint256 value, bytes memory data) external returns (uint256) {
        uint256 txId = _txId++;
        transactions[txId] = Transaction(to, value, data, false);
        emit SubmitTransaction(msg.sender, txId);
        return txId;
    }

    function confirmTransaction(uint256 txId) external {
        require(isOwner[msg.sender], "Not owner");
        confirmations[txId][msg.sender] = true;
    }

    function executeTransaction(uint256 txId) external {
        require(_getConfirmationCount(txId) >= required, "Not enough confirms");
        Transaction storage tx_ = transactions[txId];
        require(!tx_.executed, "Already executed");

        tx_.executed = true;
        (bool success,) = tx_.to.call{value: tx_.value}(tx_.data);
        require(success, "Tx failed");

        emit ExecuteTransaction(txId);
    }

    function _getConfirmationCount(uint256 txId) internal view returns (uint256) {
        uint256 count = 0;
        for (uint256 i = 0; i < owners.length; i++) {
            if (confirmations[txId][owners[i]]) count++;
        }
        return count;
    }
}
