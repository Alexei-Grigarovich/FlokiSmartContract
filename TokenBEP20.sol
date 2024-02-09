// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "./IBEP20.sol";
import "./Ownable.sol";

abstract contract Token is Ownable
{
    IBEP20 public token;

    constructor(address _token)
    {
        token = IBEP20(_token);
    }
}