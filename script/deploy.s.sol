// SPDX-License-Identifier: MIT
import "forge-std/Script.sol";

pragma solidity 0.8.25;

import "../src/SwapFactory.sol";

contract DeployFactory is Script {
    function run() external returns (SwapFactory factory) {
        vm.startBroadcast();
        factory = new SwapFactory(address(msg.sender));
        vm.stopBroadcast();
    }
}
