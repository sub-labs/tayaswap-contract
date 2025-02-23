// SPDX-License-Identifier: MIT
import "forge-std/Script.sol";

pragma solidity ^0.8.25;

import "../src/TayaswapRouter.sol";

contract DeployRouter is Script {
    function run() external returns (TayaswapRouter router) {
        vm.startBroadcast();
        router = new TayaswapRouter(
            address(0x2487100F1716EC5B1cd11F3ccEc14fCeDc8AC2fE), address(0x760AfE86e5de5fa0Ee542fc7B7B713e1c5425701)
        );
        vm.stopBroadcast();
    }
}
