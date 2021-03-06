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


// Proof of Existence contract, version 2
// solhint-disable 
pragma solidity 0.5.16;


contract ProofOfExistence2 {
  // state
  bytes32[] private proofs;

  // store a proof of existence in the contract state
  // *transactional function*
  function storeProof(bytes32 proof) public {
    if (proofs.length >= 255) {revert();}
    proofs.push(proof);
  }

  // calculate and store the proof for a document
  // *transactional function*
  function notarize(string memory document) public {
    bytes32 proof = calculateProof(document);
    storeProof(proof);
  }

  // helper function to get a document's sha256
  // *read-only function*
  function calculateProof(string memory document) payable public returns (bytes32) {
    return sha256(abi.encodePacked(document));
  }

  // check if a document has been notarized
  // *read-only function*
  function checkDocument(string memory document) payable public returns (bool) {
    bytes32 proof = calculateProof(document);
    return hasProof(proof);
  }

  // returns true if proof is stored
  // *read-only function*
  function hasProof(bytes32 proof) payable public returns (bool) {
    for (uint8 i = 0; i < proofs.length; i++) {
      if (proofs[i] == proof) {
        return true;
        }
      }
    return false;
  }
}
