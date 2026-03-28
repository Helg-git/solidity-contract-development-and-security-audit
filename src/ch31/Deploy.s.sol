// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/ch31/Token.sol";
import "../src/ch31/Staking.sol";

contract Deploy is Script {
    function run() external {
        // 从环境变量读取部署者私钥
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        // 部署 Token 合约
        Token token = new Token("My Token", "MTK");
        console.log("Token deployed at:", address(token));

        // 部署 Staking 合约
        Staking staking = new Staking(address(token));
        console.log("Staking deployed at:", address(staking));

        vm.stopBroadcast();

        // 保存部署地址到文件
        // forge script 会自动生成 broadcast/ 目录
    }
}
