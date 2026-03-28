// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract MyContractV1 is Initializable {
    address public owner;
    uint256 public value;

    // Storage Gap：预留 50 个空槽
    uint256[50] private __gap;

    function initialize(address _owner, uint256 _value) public initializer {
        owner = _owner;
        value = _value;
    }
}
