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

pragma solidity 0.8.2;


// Proof of Existence contract, version 1
contract ProofOfExistence {

    event ProofCreated(bytes32 documentHash, uint256 timestamp);

    address public owner = msg.sender;
    mapping (bytes32 => uint256) hashesById;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function notarizeHash(bytes32 documentHash) public onlyOwner {
        uint256 timestamp = block.timestamp;
        hashesById[documentHash] = timestamp;
        emit ProofCreated(documentHash, timestamp);
    }

    function doesProofExist(bytes32 documentHash) public view returns (uint256) {
        if (hashesById[documentHash] != 0) {
            return hashesById[documentHash];
        }
    }
}

