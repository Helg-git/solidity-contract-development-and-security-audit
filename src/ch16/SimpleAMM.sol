// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title SimpleAMM - AMM 核心逻辑：添加和移除流动性
contract SimpleAMM is ERC20 {
    IERC20 public tokenX;
    IERC20 public tokenY;

    uint256 public reserveX;
    uint256 public reserveY;
    uint256 public totalLP;

    uint256 public constant FEE_RATE = 30; // 0.3%，精度 10000

    constructor(address _tokenX, address _tokenY) ERC20("LP Token", "LPT") {
        tokenX = IERC20(_tokenX);
        tokenY = IERC20(_tokenY);
    }

    /// @notice 添加流动性
    function addLiquidity(uint256 amountX, uint256 amountY) external returns (uint256 lpMinted) {
        require(amountX > 0 && amountY > 0, "Amounts must be > 0");

        // 按池子当前比例计算应得的 LP 数量
        uint256 lpX = totalLP == 0 ? amountX : (amountX * totalLP) / reserveX;
        uint256 lpY = totalLP == 0 ? amountY : (amountY * totalLP) / reserveY;

        // 取较小的值，防止比例失调
        lpMinted = lpX < lpY ? lpX : lpY;

        // 实际存入的 Token 数量按 LP 比例计算
        uint256 actualX = (amountX * lpMinted) / (lpX == 0 ? 1 : lpX);
        uint256 actualY = (amountY * lpMinted) / (lpY == 0 ? 1 : lpY);

        // 转入 Token
        tokenX.transferFrom(msg.sender, address(this), actualX);
        tokenY.transferFrom(msg.sender, address(this), actualY);

        reserveX += actualX;
        reserveY += actualY;
        totalLP += lpMinted;

        _mint(msg.sender, lpMinted);
    }

    /// @notice 移除流动性
    function removeLiquidity(uint256 lpAmount) external returns (uint256 amountX, uint256 amountY) {
        require(lpAmount > 0, "Amount must be > 0");
        require(balanceOf(msg.sender) >= lpAmount, "Insufficient LP");

        // 按比例计算可取回的 Token
        amountX = (lpAmount * reserveX) / totalLP;
        amountY = (lpAmount * reserveY) / totalLP;

        reserveX -= amountX;
        reserveY -= amountY;
        totalLP -= lpAmount;

        _burn(msg.sender, lpAmount);

        tokenX.transfer(msg.sender, amountX);
        tokenY.transfer(msg.sender, amountY);
    }
}
