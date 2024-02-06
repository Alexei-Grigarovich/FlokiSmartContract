// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "./Ownable.sol";
import "./Operable.sol";
import "./Token.sol";
import "./FeeReceiver.sol";

contract Flokicyberpunk is Ownable, Operable, Token, FeeReceiver
{
    mapping(address => Player) players;

    uint public minimalWithdrawalBalance;

    constructor(address _token) FeeReceiver(msg.sender) Token(_token)
    {
        owner = msg.sender;
    }

    receive() external payable { }
    fallback() external payable { }

    event Payed(address indexed player, uint amount);
    event Withdrawn(address indexed player, uint amount);

    function pay(uint amount) external 
    {
        require(!players[msg.sender].isPaid, "You've already paid");
        require(token.transferFrom(msg.sender, address(this), amount));

        players[msg.sender].isPaid = true;
        transferFee(amount);

        emit Payed(msg.sender, amount);
    }

    function withdraw() external 
    {
        uint balance = players[msg.sender].balance;
        players[msg.sender].balance = 0;

        require(balance > minimalWithdrawalBalance, "You have no balance");
        require(token.transfer(msg.sender, balance), "The contract doesn't have enough balance");

        emit Withdrawn(msg.sender, balance);
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

    function balanceOf() public view returns (uint balance)
    {
        return players[msg.sender].balance;
    }
}

struct Player
{
    uint balance;
    bool isPaid;
}