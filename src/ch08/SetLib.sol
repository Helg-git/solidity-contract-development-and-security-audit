// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library SetLib {
    struct Data {
        mapping(address => bool) isMember;
        address[] members;
    }

    // 直接操作调用者的 storage
    function add(Data storage self, address account) public {
        require(!self.isMember[account], "already member");
        self.isMember[account] = true;
        self.members.push(account);
    }

    function contains(Data storage self, address account) public view returns (bool) {
        return self.isMember[account];
    }
}

contract MySet {
    using SetLib for SetLib.Data;
    SetLib.Data private mySet; // storage 里存数据

    function join(address account) external {
        // delegatecall 到 SetLib.add，操作 mySet 的 storage
        mySet.add(account);
    }

    function isMember(address account) external view returns (bool) {
        return mySet.contains(account);
    }
}
