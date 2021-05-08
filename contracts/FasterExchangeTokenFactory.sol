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


// solhint-disable 
pragma solidity 0.8.2;


import './FasterExchangeToken.sol';

contract FasterExchangeTokenFactory {

  mapping(address => address[]) public created;
  mapping(address => bool) public isFasterExchangeToken;
  bytes public FasterExchangeTokenByteCode;

  function createToken()  public returns (address) {
    address verifiedToken = createFasterExchangeToken(
      1000000, 
      'Faster Exchange Transaction Credits', 
      0, 
      'Faster Exchange'
      );
    FasterExchangeTokenByteCode = codeAt(verifiedToken);
  }

  function verifyFasterExchangeToken(address _tokenContract) public view returns (bool) {
    bytes memory fetchedTokenByteCode = codeAt(_tokenContract);
    if (fetchedTokenByteCode.length != FasterExchangeTokenByteCode.length) {
      return false; 
      }
    for (uint i = 0; i < fetchedTokenByteCode.length; i++) {
      if (fetchedTokenByteCode[i] != FasterExchangeTokenByteCode[i]) {
        return false;
          }
      return true;
      }
  }
  
  function createFasterExchangeToken(
    uint256 initialAmount, 
    string memory tokenName, 
    uint8 tokenDecimals, 
    string memory tokenSymbol) 
    public 
  returns (address) 
  {
    FasterExchangeToken newToken = (new FasterExchangeToken(initialAmount, tokenName, tokenDecimals, tokenSymbol));
    created[msg.sender].push(address(newToken));
    isFasterExchangeToken[address(newToken)] = true;
    newToken.transfer(msg.sender, initialAmount); 
    return address(newToken);
  }

  //retrieves the bytecode at a specific address.
  function codeAt(address _addr) internal view returns (bytes memory outputCode) { 
    assembly {
      // retrieve the size of the code, this needs assembly
      let size := extcodesize(_addr)
      // allocate output byte array - this could also be done without assembly
      // by using outputCode = new bytes(size)
      outputCode := mload(0x40)
      // new "memory end" including padding
      mstore(0x40, add(outputCode, and(add(add(size, 0x20), 0x1f), not(0x1f))))
      // store length in memory
      mstore(outputCode, size)
      // actually retrieve the code, this needs assembly
      extcodecopy(_addr, add(outputCode, 0x20), 0, size)
    }
  }
}