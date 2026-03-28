// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract MyContractV2 is UUPSUpgradeable, OwnableUpgradeable {
    uint256 public value; // V1 已有

    // V2 新增变量 - 只能在末尾追加！
    uint256 public newValue;

    // Storage Gap：预留 50 个空槽
    uint256[50] private __gap;

    function initialize(uint256 _value) public initializer {
        __UUPSUpgradeable_init();
        __Ownable_init(msg.sender);
        value = _value;
    }

    // V2 新增函数
    function incrementBoth() external {
        value++;
        newValue++;
    }

    // 必须重写：UUPS 升级授权
    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyOwner
    {}
}
