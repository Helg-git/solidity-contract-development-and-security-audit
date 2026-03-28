# Solidity 智能合约开发与安全审计 — 配套代码仓库

> 配套代码仓库 | Solidity 0.8.24+ | Foundry

## 📦 仓库说明

本仓库是掘金小册《Solidity 智能合约开发与安全审计》的配套代码仓库，包含：
- 📝 可直接运行的 Solidity 合约示例（基础语法 → DeFi 协议 → 安全审计）
- 🧪 Foundry 测试代码（单元测试 / Fuzz 测试 / Invariant 测试）
- 🔒 真实漏洞案例复现代码（The DAO / Parity / Wormhole / Ronin / Curve）

> 💡 **所有代码均可在 Foundry 环境直接运行，无需购买专栏即可使用。**

## 🚀 快速开始

```bash
# 1. 安装 Foundry
curl -L https://foundry.paradigm.xyz | bash && foundryup

# 2. 克隆仓库
git clone https://github.com/Helg-git/solidity-contract-development-and-security-audit.git
cd solidity-contract-development-and-security-audit

# 3. 安装依赖（OpenZeppelin）
forge install OpenZeppelin/openzeppelin-contracts --no-commit

# 4. 编译所有合约
forge build

# 5. 运行测试
forge test -vvv
```

## 📁 仓库结构

```
solidity-contract-development-and-security-audit/
├── README.md                           # 本文件
├── foundry.toml                        # Foundry 配置
├── src/
│   ├── ch01/                           # 第 1 章：Foundry 环境搭建
│   │   └── Counter.sol
│   ├── ch02/                           # 第 2 章：类型系统
│   │   ├── GasOptimization.sol
│   │   ├── BytesDemo.sol
│   │   └── StringTraps.sol
│   ├── ch03/                           # 第 3 章：modifier/event/error
│   │   ├── ModifierDemo.sol
│   │   ├── EventDemo.sol
│   │   ├── ErrorDemo.sol
│   │   └── ReceiveFallbackDemo.sol
│   ├── ch04/                           # 第 4 章：0.8.x 新特性
│   │   ├── UncheckedDemo.sol
│   │   ├── TransientReentrancyGuard.sol
│   │   └── AdvancedErrors.sol
│   ├── ch06/                           # 第 6 章：Storage 布局
│   │   ├── Layout.sol
│   │   ├── StorageGap.sol
│   │   └── PackingDemo.sol
│   ├── ch07/                           # 第 7 章：Gas 优化
│   ├── ch08/                           # 第 8 章：delegatecall
│   ├── ch09/                           # 第 9 章：Yul 汇编
│   ├── ch10/                           # 第 10 章：Foundry 测试
│   ├── ch11/                           # 第 11 章：ERC-20
│   ├── ch12/                           # 第 12 章：NFT/ERC-721/ERC-1155
│   ├── ch13/                           # 第 13 章：访问控制
│   ├── ch14/                           # 第 14 章：可升级合约
│   ├── ch15/                           # 第 15 章：预言机
│   ├── ch16/                           # 第 16 章：AMM/DEX
│   ├── ch17/                           # 第 17 章：借贷协议
│   ├── ch18/                           # 第 18 章：闪电贷
│   ├── ch19/                           # 第 19 章：DAO 治理
│   ├── ch22/                           # 第 22 章：重入攻击
│   ├── ch23/                           # 第 23 章：整数溢出/访问控制
│   ├── ch24/                           # 第 24 章：闪电贷攻击
│   ├── ch25/                           # 第 25 章：delegatecall 漏洞
│   ├── ch26/                           # 第 26 章：Front-running/MEV
│   ├── ch27/                           # 第 27 章：逻辑漏洞
│   ├── ch29/                           # 第 29 章：真实漏洞案例
│   ├── ch31/                           # 第 31 章：Foundry 工程化
│   ├── ch32/                           # 第 32 章：合约升级实践
│   ├── ch33/                           # 第 33 章：Gas 优化进阶
│   ├── ch34/                           # 第 34 章：跨链/L2
│   ├── ch35/                           # 第 35 章：账户抽象 ERC-4337
│   ├── ch36/                           # 第 36 章：形式化验证
│   ├── ch37/                           # 第 37 章：审计报告示例
│   ├── ch38/                           # 第 38 章：面试题代码
│   ├── ch39/                           # 第 39 章：安全/DeFi 面试题
│   └── ch40/                           # 第 40 章：总结
└── test/
    ├── ch01/                           # Counter 单元测试
    ├── ch07/                           # Gas 模型测试
    ├── ch10/                           # Foundry 测试（Fuzz/Invariant/Fork）
    ├── ch16/                           # AMM Fuzz 测试
    ├── ch17/                           # 借贷协议 Invariant 测试
    ├── ch22/                           # 重入攻击利用测试
    ├── ch25/                           # 选择器冲突测试
    ├── ch27/                           # 逻辑漏洞测试
    ├── ch28/                           # Fuzz/Invariant/Echidna 测试
    ├── ch29/                           # Curve 选择器冲突测试
    ├── ch33/                           # 存储打包验证测试
    └── ch36/                           # 形式化验证示例测试
```

## 📋 代码案例速查

### Part 1：基础与 EVM 原理（ch01-10）

| 目录 | 内容 | 难度 |
|------|------|------|
| `ch01/` | Foundry Counter 合约 + 测试 | ⭐ |
| `ch02/` | 类型系统：值类型、引用类型、string 陷阱 | ⭐⭐ |
| `ch03/` | modifier `_` 陷阱、event indexed、custom error | ⭐⭐ |
| `ch04/` | unchecked 块、transient storage、custom types | ⭐⭐ |
| `ch06/` | Storage slot 编码、变量打包、Storage Gap | ⭐⭐⭐ |
| `ch07/` | SSTORE gas、存储缓存、calldata vs memory | ⭐⭐⭐ |
| `ch08/` | delegatecall 代理模式、函数选择器 | ⭐⭐⭐ |
| `ch09/` | Yul 汇编：内存操作、bytes 处理、数组反转 | ⭐⭐⭐⭐ |

### Part 2：合约开发实战（ch11-19）

| 目录 | 内容 | 难度 |
|------|------|------|
| `ch11/` | ERC-20 从零实现、Permit (EIP-2612)、ERC-4626 | ⭐⭐⭐ |
| `ch12/` | ERC-721 NFT、ERC-1155 多代币、NFT 市场 | ⭐⭐⭐ |
| `ch13/` | Ownable、RBAC、多签钱包、三级权限分隔 | ⭐⭐⭐ |
| `ch14/` | UUPS 代理、透明代理、Storage Collision 演示 | ⭐⭐⭐⭐ |
| `ch15/` | Chainlink 预言机、TWAP 防操纵 | ⭐⭐⭐ |
| `ch16/` | AMM 恒定乘积、流动性管理、Swap 计算 | ⭐⭐⭐⭐ |
| `ch17/` | 借贷协议核心、利率模型 | ⭐⭐⭐⭐ |
| `ch18/` | 闪电贷实现、套利示例、一次性回调防御 | ⭐⭐⭐⭐ |
| `ch19/` | 治理代币、Governor、Timelock | ⭐⭐⭐⭐ |

### Part 3：安全审计实战（ch22-29）

| 目录 | 内容 | 难度 |
|------|------|------|
| `ch22/` | 重入攻击（漏洞版 + CEI 修复版 + ReentrancyGuard） | ⭐⭐⭐ |
| `ch23/` | 整数溢出、tx.origin 钓鱼 | ⭐⭐ |
| `ch24/` | 闪电贷攻击框架 | ⭐⭐⭐⭐ |
| `ch25/` | delegatecall 漏洞、选择器冲突、Storage Collision | ⭐⭐⭐⭐ |
| `ch26/` | Commit-Reveal 防 MEV | ⭐⭐⭐ |
| `ch27/` | 精度损失、边界条件、自毁攻击 | ⭐⭐⭐ |
| `ch29/` | Ronin 多签绕过、Wormhole 签名伪造、Curve 选择器冲突 | ⭐⭐⭐⭐⭐ |

### Part 4：工程化与面试（ch31-40）

| 目录 | 内容 | 难度 |
|------|------|------|
| `ch31/` | Foundry Script 部署、foundry.toml 配置 | ⭐⭐ |
| `ch32/` | UUPS 升级实践（V1→V2 + Storage Gap） | ⭐⭐⭐⭐ |
| `ch33/` | 存储 vs 计算优化、via-ir 管线 | ⭐⭐⭐ |
| `ch34/` | 跨链桥、HTLC、L2 环境感知 | ⭐⭐⭐⭐ |
| `ch35/` | ERC-4337 EntryPoint、SimpleAccount、Paymaster | ⭐⭐⭐⭐⭐ |
| `ch36/` | SMTChecker 断言、不变量测试 | ⭐⭐⭐ |

## 📋 环境要求

- Foundry (forge >= 0.2.0)
- Solidity 0.8.24+
- Node.js 18+（可选）

## 🔗 相关链接

- 📖 **掘金小册主页**（即将上架）
- 🐛 问题反馈：[GitHub Issues](https://github.com/Helg-git/solidity-contract-development-and-security-audit/issues)

## 📄 License

MIT
