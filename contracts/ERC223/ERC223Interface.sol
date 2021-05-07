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
pragma solidity 0.5.16;

contract ERC223Interface {
    /**
     * @notice ERC223Interface::totalSupply
     * @return total amount of tokens
     * @return uint256
     */
    uint256 public totalSupply;

    /**
     * @notice ERC223Interface::balanceOf
     * @return balance
     * @return uint256
     */
    function balanceOf(address _owner) public returns (uint256 balance);

    /**
     * @notice ERC223Interface::transfer
     * @return transfer success
     * @return bool
     */
    function transfer(address _to, uint256 _value)
        public
        returns (bool success);

    /**
     * @notice ERC223Interface::transfer223
     * @return transfer success
     * @return bool
     */
    function transfer223(
        address _to,
        uint256 _value,
        bytes memory data
    ) public returns (bool success);

    /**
     * @notice ERC223Interface::transfer223
     * @return transfer success
     * @return bool
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success);

    /**
     * @notice ERC223Interface::approve
     * @return transfer success
     * @return bool
     */
    function approve(address _spender, uint256 _value)
        public
        returns (bool success);

    /**
     * @notice ERC223Interface::allowance
     * @return the amount allowance
     * @return uint256
     */
    function allowance(address _owner, address _spender)
        public
        pure
        returns (uint256 remaining);

    // solhint-disable-next-line no-simple-event-func-name
    event Transfer(address _from, address _to, uint256 _value);
    event Transfer223(address _from, address _to, uint256 _value, bytes data);
    event Approval(address _owner, address _spender, uint256 _value);
}
