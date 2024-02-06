// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "./Ownable.sol";

contract Operable is Ownable
{
    address public operator;

    event OperatorUpdated(address indexed newOperator);

    constructor()
    {
        operator = msg.sender;
    }

    modifier onlyOperator() 
    {
        require(msg.sender == operator, "You're not the operator");
        _;
    }

    function setOperator(address newOperator) external onlyOwner
    {
        require(newOperator != address(0), "Incorrect address");

        operator = newOperator;

        emit OperatorUpdated(operator);
    }
}