// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Pair is ERC20, ReentrancyGuard {
    address public factory;
    address public token0;
    address public token1;
    uint112 private reserve0;
    uint112 private reserve1;
    uint32 private blockTimestampLast;
    uint256 public constant MINIMUM_LIQUIDITY = 1000;

    error InsufficientLiquidityMinted();
    error InsufficientLiquidityBurned();
    error TransferFailed();
    error Locked();

    event Burn(address indexed sender, uint256 amount0, uint amount1);
    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Sync(uint256 reserve0, uint256 reserve1);

    constructor(address _token0, address _token1) ERC20("Clone", "CLN") {
        factory = msg.sender;
        token0 = _token0;
        token1 = _token1;
    }
    // function initialize(address _token0, address _token1) external {
    //     require(msg.sender == factory, "TayaSwap: FORBIDDEN");
    //     token0 = _token0;
    //     token1 = _token1;
    // }

    function mint() external nonReentrant {
        (uint112 _reserve0, uint112 _reserve1,) = getReserve();
        uint256 balance0 = IERC20(token0).balanceOf(address(this));
        uint256 balance1 = IERC20(token0).balanceOf(address(this));
        uint amount0 = balance0 - _reserve0;
        uint amount1 = balance1 - _reserve1;
        uint256 liquidity;
        if (totalSupply() == 0) {
            liquidity = Math.sqrt(amount0 * amount1) - MINIMUM_LIQUIDITY;
            _mint(address(0), MINIMUM_LIQUIDITY);
        } else {
            liquidity = Math.min(
                (amount0 * totalSupply()) / _reserve0,
                (amount1 * totalSupply()) / _reserve1
            );

            if (liquidity <= 0) revert InsufficientLiquidityMinted();
            _mint(msg.sender, liquidity);
            _update(balance0, balance1);

            emit Mint(msg.sender, amount0, amount1);
        }
    }

    function getReserve()
        public
        view
        returns (
            uint112 _reserve0,
            uint112 _reserve1,
            uint32 _blockTimestampLast
        )
    {
        _reserve0 = reserve0;
        _reserve1 = reserve1;
        _blockTimestampLast = blockTimestampLast;
    }

    function burn() public {
        uint256 balance0 = IERC20(token0).balanceOf(address(this));
        uint256 balance1 = IERC20(token1).balanceOf(address(this));
        uint256 liquidity = balanceOf(msg.sender);

        uint256 amount0 = (liquidity * balance0) / totalSupply();
        uint256 amount1 = (liquidity * balance1) / totalSupply();
        if (amount0 <= 0 || amount1 <= 0) revert InsufficientLiquidityBurned();

        _burn(msg.sender, liquidity);

        _safeTransfer(token0, msg.sender, amount0);
        _safeTransfer(token1, msg.sender, amount1);

        balance0 = IERC20(token0).balanceOf(address(this));
        balance1 = IERC20(token1).balanceOf(address(this));

        _update(balance0, balance1);

        emit Burn(msg.sender, amount0, amount1);
    }

    function _update(uint256 balance0, uint256 balance1) private {
        reserve0 = uint112(balance0);
        reserve1 = uint112(balance1);
    //    uint32 = block.timestamp;

        emit Sync(reserve0, reserve1);
    }
    function _safeTransfer(address token, address to, uint256 value) private {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSignature("transfer(address,uint256)", to, value)
        );
        if (!success || (data.length != 0 && !abi.decode(data, (bool))))
            revert TransferFailed();
    }
}
