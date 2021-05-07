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

    bytes32 public proof;
    address public owner = msg.sender;

    function existence() public {
        owner = msg.sender; // save the owner.
    }

    function doc2sha(string document) public returns (bytes32) {
        return sha256(document); // convert the document string to bytes32 (sha256)
    }

    function store(string memory document) public {
        proof = doc2sha(document); // then save it into a constant called proof.
    }

    function destroy() public {
        if (msg.sender == owner) {
            selfdestruct(owner); // if you want to delete the existence of the document and recieve the ether, then this would help!
        }
    }
}

