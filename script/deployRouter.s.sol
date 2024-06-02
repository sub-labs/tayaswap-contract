// SPDX-License-Identifier: MIT
import "forge-std/Script.sol";

pragma solidity ^0.8.25;

import "../src/TayaswapRouter.sol";

contract DeployRouter is Script {
    function run() external returns (TayaswapRouter router) {
        vm.startBroadcast();
        router = new TayaswapRouter(
            address(0x4ae239A57053FA2F664a42D2b43E607C6827f45d), address(0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9)
        );
        vm.stopBroadcast();
    }
}
