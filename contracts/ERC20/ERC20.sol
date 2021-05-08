// SPDX-License-Identifier: MIT
/**
 *
 *  Faster Exchange
 *  The High-Performance Transaction Credits Platform
 *
 *  Copyright 2021 Sebastien Rousseau. All rights reserved.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 *
 */

/**
 * Implements ERC20 token standard: https://github.com/ethereum/EIPs/issues/20
 */
// solhint-disable
pragma solidity 0.5.16;

import "../Interfaces/IERC20.sol";
import "../Math/SafeMath.sol";


contract ERC20 {
    using SafeMath for uint256;
    uint256 private constant MAX_UINT256 = 2**256 - 1;
    /*
  NOTE:
  The following variables are OPTIONAL vanities. One does not have to include them.
  They allow one to customise the token contract & in no way influences the core functionality.
  Some wallets/interfaces might not even bother to look at this information.
  */
    string public name; //fancy name: eg Simon Bucks
    uint8 public decimals; //How many decimals to show.
    string public symbol; //An identifier: eg SBX
    string public supply; //An identifier: eg SBX
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /// @notice Constructor to create an ERC20 token
    /// @param _initialAmount Amount of the new token
    /// @param _tokenName Name of the new token
    /// @param _decimalUnits Number of decimals of the new token
    /// @param _tokenSymbol Token Symbol for the new token
    constructor(
        string memory _tokenName,
        string memory _tokenSymbol,
        uint256 _initialAmount,
        uint8 _decimalUnits
    ) public {
        balances[msg.sender] = _initialAmount; // Give the creator all initial tokens
        decimals = _decimalUnits; // Amount of decimals for display purposes
        name = _tokenName; // Set the name for display purposes
        symbol = _tokenSymbol; // Set the symbol for display purposes
    }

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return success Whether the transfer was successful or not

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value, "amount of the number needed");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /// @notice send `_amount` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _amount The amount of token to be transferred
    /// @return success Whether the transfer was successful or not
    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) public returns (bool success) 
    {
        require(
            balances[_from] >= _amount &&
                allowed[_from][msg.sender] >= _amount &&
                _amount > 0 &&
                balances[_to] + _amount > balances[_to]
        );
        balances[_from] -= _amount;
        allowed[_from][msg.sender] -= _amount;
        balances[_to] += _amount;
        emit Transfer(_from, _to, _amount);
        return true;
    }

    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of tokens to be approved for transfer
    /// @return success Whether the approval was successful or notv
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return remaining An uint256 representing the amount of the remaining tokens allowed to spent
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
}
