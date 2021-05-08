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

pragma solidity 0.5.16;


// Proof of Existence contract, version 1
contract ProofOfExistence {
    event ProofCreated(uint256 indexed id, bytes32 documentHash);

    address public owner;

    mapping(uint256 => bytes32) hashesById;

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the owner is allowed."
        );
        _;
    }

    modifier noHashExistsYet(uint256 id) {
        require(hashesById[id] == "", "No hash exists for this id.");
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function notarizeHash(uint256 id, bytes32 documentHash)
        public
        onlyOwner
        noHashExistsYet(id)
    {
        hashesById[id] = documentHash;

        emit ProofCreated(id, documentHash);
    }

    function doesProofExist(uint256 id, bytes32 documentHash)
        public
        view
        returns (bool)
    {
        return hashesById[id] == documentHash;
    }
}