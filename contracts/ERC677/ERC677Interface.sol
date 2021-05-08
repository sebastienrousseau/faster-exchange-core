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
 * Implements ERC677 token standard: https://github.com/ethereum/EIPs/issues/677
 *
 * Allow tokens to be transferred to contracts and have the contract trigger logic for
 * how to respond to receiving the tokens within a single transaction.
 *
 */
// solhint-disable
pragma solidity 0.8.2;

import '../ERC20/ERC20.sol';

/**
 * @title ERC677 interface, an extension of ERC20 token standard
 * Interface for required functionality in the ERC677 standard
 * for non-fungible tokens.
 */
contract ERC677Interface is ERC20 {
    /// @return total amount of tokens
    uint256 public totalSupply;

    /**
     * @notice ERC677Interface::transferAndCall
     * @return transfer success
     * @return bool
     * @dev transfer token to a contract address with additional data if the recipient is a contact.
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     * @param _data The extra data to be passed to the receiving contract.
     */
    function transferAndCall(
        address receiver,
        uint256 amount,
        bytes memory data
    ) public returns (bool success);

    // solhint-disable-next-line no-simple-event-func-name
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value,
        bytes data
    );
}
