// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "./Ownable.sol";
import "./Token.sol";
import "./FeeReceiver.sol";

contract Flokicyberpunk is Ownable, Token, FeeReceiver
{
    mapping(address => Player) players;

    uint public minimalWithdrawalBalance;

    constructor(address _token) FeeReceiver(msg.sender) Token(_token)
    {
        owner = msg.sender;
    }

    receive() external payable { }
    fallback() external payable { }

    event Payed(address indexed player);
    event Withdrawn(address indexed player, uint amount);

    function pay(uint amount) external 
    {
        require(token.transferFrom(msg.sender, address(this), amount));

        transferFee(amount);     

        emit Payed(msg.sender);
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
}

struct Player
{
    uint balance;
}