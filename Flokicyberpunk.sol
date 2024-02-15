// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "./Ownable.sol";
import "./Operable.sol";
import "./TokenBEP20.sol";
import "./FeeReceiver.sol";

contract Flokicyberpunk is Ownable, Operable, Token, FeeReceiver
{
    mapping(address => Player) players;

    uint public paymentCost;
    uint public minimalWithdrawalBalance;

    constructor(address _token) FeeReceiver(msg.sender) Token(_token)
    {
        owner = msg.sender;
    }

    receive() external payable { }
    fallback() external payable { }

    event Payed(address indexed player, uint amount);
    event Withdrawn(address indexed player, uint amount);

    function pay() external 
    {
        require(!players[msg.sender].isPaid, "You've already paid");
        require(token.transferFrom(msg.sender, address(this), paymentCost), "Transfer failed");

        players[msg.sender].isPaid = true;
        transferFee(paymentCost);

        emit Payed(msg.sender, paymentCost);
    }

    function withdraw() external 
    {
        uint balance = players[msg.sender].balance;
        players[msg.sender].balance = 0;

        require(balance > minimalWithdrawalBalance, "You have no balance");
        require(token.transfer(msg.sender, balance), "The contract doesn't have enough balance");

        emit Withdrawn(msg.sender, balance);
    }

    function setPaymentCost(uint value) public onlyOwner
    {
        paymentCost = value;
    }

    function setMinimalWithdrawalBalance(uint value) public onlyOwner
    {
        minimalWithdrawalBalance = value;
    }

    function addBalance(address player, uint amount) public onlyOperator
    {
        players[player].balance += amount;
    }

    function resetPayment(address player) public onlyOperator
    {
        players[player].isPaid = false;
    }

    function getPaymentCost() public view returns (uint cost)
    {
        return paymentCost;
    }

    function getMinimalWithdrawalBalance() public view returns (uint)
    {
        return minimalWithdrawalBalance;
    }

    function balanceOf(address player) public view returns (uint balance)
    {
        return players[player].balance;
    }

    function paidOf(address player) public view returns (bool isPaid)
    {
        return players[player].isPaid;
    }
}

struct Player
{
    uint balance;
    bool isPaid;
}