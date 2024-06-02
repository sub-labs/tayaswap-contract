// SPDX-License-Identifier: MIT
import "forge-std/Script.sol";

pragma solidity ^0.8.25;

import "../src/TayaswapFactory.sol";

contract DeployFactory is Script {
    function run() external returns (TayaswapFactory factory) {
        vm.startBroadcast();
        factory = new TayaswapFactory(address(msg.sender));
        vm.stopBroadcast();
    }
}
