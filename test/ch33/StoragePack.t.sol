// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

contract BadLayout {
    uint256 public amount;      // slot 0
    address public owner;       // slot 1
    bool    public isActive;    // slot 2
    uint128 public rewardDebt;  // slot 3
}

contract GoodLayout {
    bool    public isActive;    // slot 0, offset 0
    bool    public isVIP;       // slot 0, offset 1
    uint32  public lastUpdate;  // slot 0, offset 2
    address public owner;       // slot 0, offset 6
    uint128 public rewardDebt;  // slot 1, offset 0
    uint128 public amount;      // slot 1, offset 16
}

contract StoragePackTest is Test {
    BadLayout  bad;
    GoodLayout good;

    function setUp() public {
        bad  = new BadLayout();
        good = new GoodLayout();
    }

    function test_storageLayout() public view {
        // ---- BadLayout: 每个变量独占一个 slot（共 4 个） ----
        vm.store(address(bad), bytes32(uint256(0)), bytes32(uint256(111)));
        vm.store(address(bad), bytes32(uint256(1)), bytes32(uint256(222)));
        vm.store(address(bad), bytes32(uint256(2)), bytes32(uint256(333)));
        vm.store(address(bad), bytes32(uint256(3)), bytes32(uint256(444)));
        assert(vm.load(address(bad), bytes32(uint256(0))) == bytes32(uint256(111)));
        assert(vm.load(address(bad), bytes32(uint256(1))) == bytes32(uint256(222)));
        assert(vm.load(address(bad), bytes32(uint256(2))) == bytes32(uint256(333)));
        assert(vm.load(address(bad), bytes32(uint256(3))) == bytes32(uint256(444)));

        // ---- GoodLayout: 6 个变量打包到 2 个 slot ----
        vm.store(address(good), bytes32(uint256(0)), bytes32(uint256(1)));
        assert(vm.load(address(good), bytes32(uint256(0))) != bytes32(uint256(0)));

        vm.store(address(good), bytes32(uint256(1)), bytes32(uint256(555)));
        assert(vm.load(address(good), bytes32(uint256(1))) == bytes32(uint256(555)));

        // slot 2 应为空（未使用），证明总共只用了 2 个 slot
        assert(vm.load(address(good), bytes32(uint256(2))) == bytes32(uint256(0)));
    }
}
