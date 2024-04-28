// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TokenBank} from "../src/ExtendedTokenBank.sol";
import {BaseERC20} from "../src/ExtendERC20.sol";
contract CounterTest is Test {
    TokenBank public tokenbank;
    BaseERC20 public erc20;
    address alice;
    uint256 depositETH; 
    function setUp() public {
        tokenbank = new TokenBank();
        erc20 = new BaseERC20();
        alice = makeAddr("alice");
        depositETH = 1 ether;
    }
    

    //调用转账前，先调用mint
    function test_mint() public{
        erc20._mint(alice, depositETH);
        assertEq(erc20.balanceOf(alice), depositETH);
    }

    // TokenHook中，调用扩展的ERC20中的transferExtended，转账后会完成回调
    // 由于其他功能都在tokenbank的测试中测试完毕，因此我们这里只测试这个功能
    function test_transferExtended()public {
        test_mint();
        address bob = makeAddr("bob");
        vm.prank(alice);
        erc20.transferExtended(address(tokenbank), bob, depositETH);
        assertEq(erc20.balanceOf(alice), 0);
        assertEq(erc20.balanceOf(bob), depositETH);
        assertEq(tokenbank.balances(address(erc20), bob), depositETH);
    }


}
