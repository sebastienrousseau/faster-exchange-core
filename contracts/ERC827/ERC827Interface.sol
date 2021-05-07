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
 * Implements ERC827 token standard: https://github.com/ethereum/EIPs/issues/827
 *
 * Interface of a ERC827 token, following the ERC20 standard with extra
 * methods to transfer value and data and execute calls in transfers and
 * approvals.
 *
 */
// solhint-disable
pragma solidity 0.5.16;

import '../ERC20/ERC20Interface.sol';

/**
 * @title ERC827 interface, an extension of ERC20 token standard
 * Interface for required functionality in the ERC827 standard
 * for non-fungible tokens.
 */
contract ERC827Interface is ERC20Interface {
    // Function
    function approve(
        address _spender,
        uint256 _value,
        bytes memory _data
    ) public returns (bool);

    function transfer(
        address _to,
        uint256 _value,
        bytes memory _data
    ) public returns (bool);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value,
        bytes memory _data
    ) public returns (bool);
}
