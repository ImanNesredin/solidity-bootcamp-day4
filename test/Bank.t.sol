// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Bank.sol";

contract BankTest is Test {
    Bank bank;

    address user = address(1);

    function setUp() public {
        bank = new Bank();

        // Give user 10 ETH
        vm.deal(user, 10 ether);
    }

    // Test deposit
    function testDeposit() public {
        vm.prank(user);
        bank.deposit{value: 1 ether}();

        uint256 balance = bank.getBalance(user);
        assertEq(balance, 1 ether);
    }

    // Test withdraw
    function testWithdraw() public {
        vm.startPrank(user);

        bank.deposit{value: 2 ether}();
        bank.withdraw(1 ether);

        uint256 balance = bank.getBalance(user);
        assertEq(balance, 1 ether);

        vm.stopPrank();
    }

    // Cannot withdraw more than balance
    function testCannotWithdrawTooMuch() public {
        vm.prank(user);
        bank.deposit{value: 1 ether}();

        vm.prank(user);
        vm.expectRevert("Not enough balance");
        bank.withdraw(2 ether);
    }

    // Balance updates correctly
    function testBalanceUpdates() public {
        vm.startPrank(user);

        bank.deposit{value: 3 ether}();
        bank.withdraw(1 ether);

        uint256 balance = bank.getBalance(user);
        assertEq(balance, 2 ether);

        vm.stopPrank();
    }

    // Revert works
    function testDepositZeroReverts() public {
        vm.prank(user);
        vm.expectRevert("Send ETH");
        bank.deposit{value: 0}();
    }
}