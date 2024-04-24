// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "./mocks/ERC20Mintable.sol";
import "../src/Pair.sol";
import "forge-std/console.sol";

contract PairTest is Test {
    ERC20Mintable public token0;
    ERC20Mintable public token1;
    Pair pair;

    function setUp() public {
        token0 = new ERC20Mintable("TOKEN 0", "TKN");
        token1 = new ERC20Mintable("TOKEN 1", "RKN");
        pair = new Pair(address(token0), address(token1));
        console.log(msg.sender);
        token0.mint(1 ether, msg.sender);
        token1.mint(1 ether, msg.sender);
    }

    function testMintBootstrap() public {
        hoax(msg.sender);
    
 
        token0.transfer(address(pair), 1 ether);
         hoax(msg.sender);
        token1.transfer(address(pair), 1 ether);

        pair.mint();

        // assertEq(pair.balanceOf(address(this)), 1 ether - 1000);

        // assertEq(pair.totalSupply(), 1 ether);
    }
}
