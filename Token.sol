// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Ownable.sol";

abstract contract Token is Ownable
{
    IERC20 public token;

    constructor(address _token)
    {
        token = IERC20(_token);
    }

    function setToken(address newTokenAddress) public onlyOwner
    {
        token = IERC20(newTokenAddress);
    }
}