// SPDX-License-Identifier: MIT
import "forge-std/Script.sol";

pragma solidity 0.8.25;

import "../src/SwapFactory.sol";
import "../src/SwapRouter.sol";

contract DeployFactory is Script {
    function run() external returns (SwapFactory factory, SwapRouter router) {
        vm.startBroadcast();
        factory = new SwapFactory(address(msg.sender));
        router = new SwapRouter(address(factory), address(0x760AfE86e5de5fa0Ee542fc7B7B713e1c5425701));
        vm.stopBroadcast();
    }
}
