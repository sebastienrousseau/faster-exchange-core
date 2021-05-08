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
 * Implements ERC721 token standard: https://github.com/ethereum/EIPs/issues/721
 */
// solhint-disable
pragma solidity 0.5.16;


/**
 * Interface for required functionality in the ERC721 standard
 * for non-fungible tokens.
 */
contract ERC721Interface {
    // Function
    function totalSupply() public view returns (uint256 _totalSupply);

    function balanceOf(address _owner) public view returns (uint256 _balance);

    function ownerOf(uint256 _tokenId) public view returns (address _owner);

    function approve(address _to, uint256 _tokenId) public;

    function getApproved(uint256 _tokenId) public view returns (address _approved);

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public;

    function transfer(address _to, uint256 _tokenId) public;

    function implementsERC721() public view returns (bool _implementsERC721);

    // Events
    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
}
