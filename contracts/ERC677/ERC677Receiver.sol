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
 *  Abstract contract for the full ERC677 Token standard. https://github.com/ethereum/EIPs/issues/677
 */

// solhint-disable
pragma solidity 0.5.16;


/**
 * @title Contract that will work with ERC677 tokens.
 */
contract ERC677Receiver {
    /// @notice ERC677Receiver
    /// @notice Standard ERC677 function that will handle incoming token transfers.
    /// @param _from  Token sender address.
    /// @param _amount Amount of tokens.
    /// @param _data  Transaction metadata.
    function tokenFallback(
        address _from,
        uint256 _amount,
        bytes calldata _data
    ) external returns (bool);
}
