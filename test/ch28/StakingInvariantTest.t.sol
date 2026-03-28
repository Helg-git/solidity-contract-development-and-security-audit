// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

/// @title StakingInvariantTest - Foundry Invariant Testing 示例
/// @notice 使用不变量测试随机调用合约函数序列，验证系统级属性
contract StakingInvariantTest is Test {
    SimpleToken token;
    SimpleStaking staking;
    Handler handler;
    address[] public actors;

    function setUp() public {
        token = new SimpleToken();
        staking = new SimpleStaking(address(token));
        handler = new Handler(token, staking);

        // 创建 10 个测试用户，每人分配 1000 token
        for (uint256 i = 0; i < 10; i++) {
            address actor = address(uint160(i + 1));
            actors.push(actor);
            token.mint(actor, 1000 ether);
        }
        // 设置 target 合约（Handler）
        targetContract(address(handler));
        targetSender(address(handler));
    }

    // 不变量1：合约中的 token 总量 = 所有用户质押量之和
    function invariant_totalStakedEqualsSum() public view {
        uint256 totalStaked = staking.totalStaked();
        uint256 sum = 0;
        for (uint256 i = 0; i < actors.length; i++) {
            sum += staking.stakedBalanceOf(actors[i]);
        }
        assertEq(totalStaked, sum);
    }

    // 不变量2：没有人能取出超过自己质押的量
    function invariant_noOverdraw() public view {
        for (uint256 i = 0; i < actors.length; i++) {
            assertLe(
                token.balanceOf(actors[i]),
                1000 ether // 初始 mint 量
            );
        }
    }
}

/// @title Handler - 封装所有用户操作的 Handler 合约
contract Handler is Test {
    SimpleToken token;
    SimpleStaking staking;
    address public currentActor;

    constructor(SimpleToken _token, SimpleStaking _staking) {
        token = _token;
        staking = _staking;
    }

    function setActor(address actor) public {
        currentActor = actor;
        vm.startPrank(actor);
    }

    function deposit(uint256 amount) public {
        amount = bound(amount, 1, token.balanceOf(currentActor));
        token.approve(address(staking), amount);
        staking.deposit(amount);
        vm.stopPrank();
    }

    function withdraw(uint256 amount) public {
        amount = bound(amount, 1, staking.stakedBalanceOf(currentActor));
        staking.withdraw(amount);
        vm.stopPrank();
    }

    function claimRewards() public {
        staking.claimRewards();
        vm.stopPrank();
    }
}

/// @title SimpleToken - 简化版 ERC20 Token
contract SimpleToken {
    mapping(address => uint256) public balanceOf;
    uint256 public totalSupply;

    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
        totalSupply += amount;
    }
}

/// @title SimpleStaking - 简化版 Staking 合约
contract SimpleStaking {
    SimpleToken public token;
    uint256 public totalStaked;
    mapping(address => uint256) public stakedBalanceOf;

    constructor(address _token) {
        token = SimpleToken(_token);
    }

    function deposit(uint256 amount) external {
        token.transferFrom(msg.sender, address(this), amount);
        stakedBalanceOf[msg.sender] += amount;
        totalStaked += amount;
    }

    function withdraw(uint256 amount) external {
        require(stakedBalanceOf[msg.sender] >= amount, "Insufficient");
        stakedBalanceOf[msg.sender] -= amount;
        totalStaked -= amount;
        token.transfer(msg.sender, amount);
    }

    function claimRewards() external {
        // 简化：实际应有奖励逻辑
    }
}
