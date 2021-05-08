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
 * Implements ERC223 token standard: https://github.com/ethereum/EIPs/issues/223
 */
// solhint-disable
pragma solidity 0.8.2;

import '../ERC223/IERC223.sol';
import './ERC223Receiver.sol';
import '../Math/SafeMath.sol';

contract ERC223 is IERC223 {
    using SafeMath for uint256;
    uint256 private constant MAX_UINT256 = 2**256 - 1;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowed;
    /*
  NOTE:
  The following variables are OPTIONAL vanities. One does not have to include them.
  They allow one to customise the token contract and in no way influences the core functionality.
  Some wallets/interfaces might not even bother to look at this information.
  */
    string public name; //fancy name: eg Simon Bucks
    uint8 public decimals; //How many decimals to show.
    string public symbol; //An identifier: eg SBX

    /**
     * @notice Constructor to create an ERC223 token
     * @param _initialAmount Amount of the new token
     * @param _tokenName Name of the new token
     * @param _decimalUnits Number of decimals of the new token
     * @param _tokenSymbol Token Symbol for the new token
     */

    constructor(
        uint256 _initialAmount,
        string memory _tokenName,
        uint8 _decimalUnits,
        string memory _tokenSymbol
    ) public {
        balances[msg.sender] = _initialAmount; // Give the creator all initial tokens
        totalSupply = _initialAmount; // Update total supply
        name = _tokenName; // Set the name for display purposes
        decimals = _decimalUnits; // Amount of decimals for display purposes
        symbol = _tokenSymbol; // Set the symbol for display purposes
    }

    /**
     * @notice ERC223Token::transfer
     * @notice Classic ERC20 transfer confirmation
     * @notice send `_value` token to `_to` from `msg.sender`
     * @param _to The address of the recipient
     * @param _value The amount of token to be transferred
     * @return success whether the transfer was successful or not
     */
    function transfer(address _to, uint256 _value)
        public
        override
        returns (bool success)
    {
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     * @notice ERC223Token::transfer223
     * @notice ERC223 confirmation
     * @notice send `_amount` token to `_to` from `msg.sender`
     * @param _to The address of the recipient
     * @param _amount The amount of token to be transferred
     * @param _data The amount of token to be transferred
     * @return success whether the transfer was successful or not
     */
    function transfer223(
        address _to,
        uint256 _amount,
        bytes memory _data
    ) public override returns (bool success) {
        if (_amount > 0 && _amount <= balances[msg.sender] && isContract(_to)) {
            balances[msg.sender] = balances[msg.sender].sub(_amount);
            balances[_to] = balances[_to].add(_amount);

            // Call ERC223Receiver
            if (isContract(_to)) {
                ERC223Receiver to = ERC223Receiver(_to);
                to.tokenFallback(msg.sender, _amount, _data);
            }

            emit Transfer223(msg.sender, _to, _amount, _data);
            return true;
        } else {
            return false;
        }
    }

    /**
     * @notice ERC223Token::transferFrom
     * @notice Check sender
     * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value The amount of token to be transferred
     * @return success whether the transfer was successful or not
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public override returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        if (allowance < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        emit Transfer(_from, _to, _value);
        return true;
    }

    /**
     * ERC223Token::balanceOf
     * @notice The balance
     * @param _owner The address from which the balance will be retrieved
     * @return balance uint256
     */
    function balanceOf(address _owner) public override returns (uint256 balance) {
        return balances[_owner];
    }

    /**
     * ERC223Token::approve
     * @notice confirm spender
     * @notice `msg.sender` approves `_spender` to spend `_value` tokens
     * @param _spender The address of the account able to transfer the tokens
     * @param _value The amount of tokens to be approved for transfer
     * @return success Whether the approval was successful or not
     */
    function approve(address _spender, uint256 _value)
        public
        override
        returns (bool success)
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * ERC223Token::allowance
     * @notice amount allowance
     * @param _owner The address of the account owning tokens
     * @param _spender The address of the account able to transfer the tokens
     * @return remaining amount of remaining tokens allowed to spent
     */

    function allowance(address _owner, address _spender)
        public
        override
        pure
        returns (uint256 remaining)
    {
        return allowed[_owner][_spender];
    }

    /**
     * ERC223Token::isContract
     * @notice confirm spender
     * @dev Retrieve the size of the code on target address, this needs assembly.
     * @param _addr  The address to check if it's a contract.
     * @return success bool
     */
    function isContract(address _addr) public view returns (bool success) {
        uint256 intcodesize;
        /* solium-disable-next-line */
        assembly {
            // retrieve the size of the code on target address, this needs assembly
            intcodesize := extcodesize(_addr)
        }
        return (intcodesize > 0);
    }
}
