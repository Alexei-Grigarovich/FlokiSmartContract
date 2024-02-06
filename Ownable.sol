// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

abstract contract Ownable
{
    address public owner;

    event OwnerUpdated(address indexed newOwner);

    constructor()
    {
        owner = msg.sender;
    }

    modifier onlyOwner() 
    {
        require(msg.sender == owner, "You're not the owner");
        _;
    }

    function transferOwnership(address newOwner) external onlyOwner
    {
        require(newOwner != address(0), "Incorrect address");

        owner = newOwner;

        emit OwnerUpdated(owner);
    }
}