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
 * Implements ERC777 token standard: https://github.com/ethereum/EIPs/issues/777
 */
// solhint-disable
pragma solidity 0.5.16;


/**
 * Interface for required functionality in the ERC721 standard
 * for non-fungible tokens.
 */
contract ERC777Token {
    // Function
    function name() public pure returns (string memory);

    function symbol() public pure returns (string memory);

    function totalSupply() public pure returns (uint256);

    function granularity() public pure returns (uint256);

    function balanceOf(address owner) public pure returns (uint256);

    function send(address to, uint256 amount) public;

    function send(
        address to,
        uint256 amount,
        bytes memory userData
    ) public;

    function authorizeOperator(address operator) public;

    function revokeOperator(address operator) public;

    function isOperatorFor(address operator, address tokenHolder) public pure returns (bool);

    function operatorSend(
        address from,
        address to,
        uint256 amount,
        bytes memory userData,
        bytes memory operatorData
    ) public;

    // Events
    event Sent(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 amount,
        bytes userData,
        bytes operatorData
    ); // solhint-disable-next-line separate-by-one-line-in-contract
    event Minted(address indexed operator, address indexed to, uint256 amount, bytes operatorData);
    event Burned(address indexed operator, address indexed from, uint256 amount, bytes userData, bytes operatorData);
    event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
    event RevokedOperator(address indexed operator, address indexed tokenHolder);
}
