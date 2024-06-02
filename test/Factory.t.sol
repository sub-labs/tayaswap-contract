// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Test,console} from "forge-std/Test.sol";
import {TayaswapFactory} from "../src/TayaswapFactory.sol";
import {ITayaswapPair} from "../src/interfaces/ITayaswapPair.sol";

contract FactoryTest is Test {
    TayaswapFactory factory;

    function setUp() external {
        TayaswapFactory _factory = new TayaswapFactory(address(0));
        factory = _factory;
    }

    function testfeeToSetter() external view {
        assertEq(factory.feeToSetter(), address(0));
    }

    function testDeployPair() external {
        address pair = factory.createPair(
            address(0xf08A50178dfcDe18524640EA6618a1f965821715), address(0x779877A7B0D9E8603169DdbD7836e478b4624789)
        );
        ITayaswapPair pairinterface = ITayaswapPair(pair);
        assertEq(pairinterface.factory(), address(factory));

    }
}
