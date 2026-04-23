// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Bank {
    mapping(address => uint256) private balances;

    // Deposit ETH
    function deposit() external payable {
        require(msg.value > 0, "Send ETH");
        balances[msg.sender] += msg.value;
    }

    // Withdraw ETH
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Not enough balance");

        balances[msg.sender] -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }

    // Check balance
    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }
}
