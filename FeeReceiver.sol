// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "./Ownable.sol";
import "./TokenBEP20.sol";

abstract contract FeeReceiver is Ownable, Token
{
    address public feeRecipient;

    uint public feePercentage;

    constructor(address _feeRecipient)
    {
        feeRecipient = _feeRecipient;
        feePercentage = 30;
    }

    function transferFee(uint totalAmount) internal 
    {
        uint fee = (totalAmount * feePercentage) / 100;
        require(token.transfer(feeRecipient, fee));
    }

    function setFeeRecipient(address newFeeRecipient) external onlyOwner
    {
        require(newFeeRecipient != address(0), "Incorrect address");

        feeRecipient = newFeeRecipient;
    }

    function setFeePercentage(uint newFeePercentage) external onlyOwner
    {
        feePercentage = newFeePercentage;
    }
}