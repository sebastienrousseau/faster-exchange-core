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
 * Implements ERC677 token standard: https://github.com/ethereum/EIPs/issues/677
 */
// solhint-disable
pragma solidity 0.8.2;

import '../ERC677/ERC677Interface.sol';
import '../ERC677/ERC677Receiver.sol';
import '../Math/SafeMath.sol';

contract ERC677 is ERC677Interface {
    using SafeMath for uint256;
    uint256 private constant MAX_UINT256 = 2**256 - 1;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowed;

    // using SafeMath for uint256;
    // uint256 constant private MAX_UINT256 = 2**256 - 1;
    // mapping (address => uint256) public balances;
    // mapping (address => mapping (address => uint256)) public allowed;
    /*
  NOTE:
  The following variables are OPTIONAL vanities. One does not have to include them.
  They allow one to customise the token contract and in no way influences the core functionality.
  Some wallets/interfaces might not even bother to look at this information.
  */
    // string public name;                     //fancy name: eg Simon Bucks
    // uint8 public decimals;                  //How many decimals to show.
    // string public symbol;                   //An identifier: eg SBX

    /**
     * @notice Constructor to create an ERC677 token
     * @param _initialAmount Amount of the new token
     * @param _tokenName Name of the new token
     * @param _decimalUnits Number of decimals of the new token
     * @param _tokenSymbol Token Symbol for the new token
     */

    // function ERC677(
    //   uint256 _initialAmount,
    //   string _tokenName,
    //   uint8 _decimalUnits,
    //   string _tokenSymbol
    // ) public
    // {
    //   balances[msg.sender] = _initialAmount;  // Give the creator all initial tokens
    //   totalSupply = _initialAmount;           // Update total supply
    //   name = _tokenName;                      // Set the name for display purposes
    //   decimals = _decimalUnits;               // Amount of decimals for display purposes
    //   symbol = _tokenSymbol;                  // Set the symbol for display purposes
    // }

    /**
     * ERC677Token::isContract
     * @notice confirm spender
     * @dev Retrieve the size of the code on target address, this needs assembly.
     * @param _addr  The address to check if it's a contract.
     * @return bool
     */
    function isContract(address _addr) public view returns (bool success) {
        uint256 intcodesize;
        /* solium-disable-next-line */
        assembly {
            // retrieve the size of the code on target address, this needs assembly
            intcodesize := extcodesize(_addr)
        }
        return (intcodesize > 0);
    }

    /**
     * @notice ERC677Token::transferAndCall
     * @notice Transfers tokens to receiver, via ERC20's transfer(address,uint256) function
     * @notice send `_amount` token to `_receiver` from `msg.sender`
     * @param _receiver The address of the recipient
     * @param _amount The amount of token to be transferred
     */
    function transferAndCall(
        address _receiver,
        uint256 _amount,
        bytes memory _data
    ) public returns (bool success) {
        super.transfer(_receiver, _amount);

        emit Transfer(msg.sender, _receiver, _amount, _data);

        // call receiver
        if (isContract(_receiver)) {
            tokenFallback(_receiver, _amount, _data);
        }
        return true;
    }

    /**
     * ERC677Token::tokenFallback
     * @dev Standard ERC677 function that will handle
     * incoming token transfers.
     * @param _receiver Token sender address.
     * @param _amount Amount of tokens.
     * @param _data Transaction metadata.
     */
    function tokenFallback(
        address _receiver,
        uint256 _amount,
        bytes memory _data
    ) private {
        ERC677Receiver receiver = ERC677Receiver(_receiver);
        receiver.tokenFallback(msg.sender, _amount, _data);
    }
}
