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
 *  Abstract contract for the full ERC223 Token standard. https://github.com/ethereum/EIPs/issues/223
 */

// solhint-disable
pragma solidity 0.8.2;

import './ERC223.sol';

contract ERC223Interface is ERC223 {
    /**
     * @notice ERC223Interface::totalSupply
     * @return totalSupply total amount of tokens
     */
    uint256 public totalSupply;

    /**
     * @notice ERC223Interface::balanceOf
     * @return balance
     */
    function balanceOf(address _owner) public virtual returns (uint256 balance);

    /**
     * @notice ERC223Interface::transfer
     * @param _to The address of the recipient
     * @param _value The amount of token to be transferred
     * @return success transfer success
     */
    function transfer(address _to, uint256 _value)
        public
        virtual
        returns (bool success);

    /**
     * @notice ERC223Interface::transfer223
     * @param _to The address of the recipient
     * @param _value The amount of token to be transferred
     * @return success transfer success
     */
    function transfer223(
        address _to,
        uint256 _value,
        bytes memory data
    ) public virtual returns (bool success);

    /**
     * @notice ERC223Interface::transfer223
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value The amount of token to be transferred
     * @return success transfer success
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public virtual returns (bool success);

    /**
     * @notice ERC223Interface::approve
     * @param _spender The address of the account able to transfer the tokens
     * @param _value The amount of token to be transferred
     * @return success transfer success
     */
    function approve(address _spender, uint256 _value)
        public
        virtual
        returns (bool success);

    /**
     * @notice ERC223Interface::allowance
     * @param _owner The address of the account owning tokens
     * @param _spender The address of the account able to transfer the tokens
     * @return remaining the amount allowance
     */
    function allowance(address _owner, address _spender)
        public
        virtual
        pure
        returns (uint256 remaining);

    // solhint-disable-next-line no-simple-event-func-name
    event Transfer(address _from, address _to, uint256 _value);
    event Transfer223(address _from, address _to, uint256 _value, bytes data);
    event Approval(address _owner, address _spender, uint256 _value);
}
