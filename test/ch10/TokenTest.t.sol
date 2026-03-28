// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

interface IERC20 {
    function balanceOf(address) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function transfer(address, uint256) external returns (bool);
    function approve(address, uint256) external returns (bool);
    function transferFrom(address, address, uint256) external returns (bool);
}

interface IToken is IERC20 {
    constructor(string memory name, string memory symbol, uint256 initialSupply);
}

// 简单的 ERC20 Token 用于测试
contract Token is IERC20 {
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory _name, string memory _symbol, uint256 _initialSupply) {
        name = _name;
        symbol = _symbol;
        totalSupply = _initialSupply;
        balanceOf[msg.sender] = _initialSupply;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(balanceOf[from] >= amount, "insufficient balance");
        require(allowance[from][msg.sender] >= amount, "insufficient allowance");
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        allowance[from][msg.sender] -= amount;
        return true;
    }
}

// Fuzz 测试
contract TokenFuzzTest is Test {
    Token token;

    function setUp() public {
        token = new Token("Test", "TST", 1000);
    }

    function testFuzz_Transfer(address to, uint256 amount) public {
        vm.assume(to != address(0));
        vm.assume(amount <= token.balanceOf(address(this)));

        uint256 balanceBefore = token.balanceOf(to);
        token.transfer(to, amount);
        assertEq(token.balanceOf(to), balanceBefore + amount);
    }

    function testFuzz_TotalSupplyNeverChanges(
        address to1, uint256 amount1,
        address to2, uint256 amount2
    ) public {
        vm.assume(to1 != address(0) && to2 != address(0));
        vm.assume(amount1 + amount2 <= token.balanceOf(address(this)));

        uint256 supplyBefore = token.totalSupply();
        token.transfer(to1, amount1);
        token.transfer(to2, amount2);
        assertEq(token.totalSupply(), supplyBefore);
    }
}

// Handler：封装对目标合约的各种操作
contract Handler is Test {
    Token token;
    address alice;
    address bob;

    function setUp() public {
        token = new Token("Test", "TST", 1000);
        alice = makeAddr("alice");
        bob = makeAddr("bob");
        token.transfer(alice, 500);
        token.transfer(bob, 500);
    }

    function getToken() external view returns (Token) {
        return token;
    }

    // Foundry 会随机调用这些 public 函数
    function transfer_random(uint256 amount) public {
        amount = bound(amount, 0, token.balanceOf(alice));
        vm.prank(alice);
        token.approve(address(this), amount);
        token.transferFrom(alice, bob, amount);
    }
}

// Invariant 测试合约
contract TokenInvariantTest is Test {
    Handler handler;

    function setUp() public {
        handler = new Handler();
        targetContract(address(handler));
    }

    // 不变量：总供应量永远不变
    function invariant_totalSupply() public {
        assertEq(handler.getToken().totalSupply(), 1000);
    }
}
