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
pragma solidity 0.5.16;

import "../interfaces/token/IERC677.sol";
import "../ERC20/ERC20.sol";
import "../ERC677/ERC677Receiver.sol";
import "../math/SafeMath.sol";


contract ERC677 is IERC677, ERC20 {
    using SafeMath for uint256;
    uint256 private constant MAX_UINT256 = 2**256 - 1;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowed;

    /// @notice ERC677Token::isContract
    /// @notice Confirm spender. Retrieve the size of the code on target address, this needs assembly.
    /// @param _addr The address to check if it's a contract.
    /// @return success Whether the transfer was successful or not
    function isContract(address _addr) public view returns (bool success) {
        uint256 intcodesize;
        /* solium-disable-next-line */
        assembly {
            // retrieve the size of the code on target address, this needs assembly
            intcodesize := extcodesize(_addr)
        }
        return (intcodesize > 0);
    }

    /// @notice ERC677Token::tokenFallback
    /// @notice Standard ERC677 function that will handle incoming token transfers.
    /// @param _receiver Token sender address.
    /// @param _amount Amount of tokens.
    /// @param _data Transaction metadata.
    function tokenFallback(
        address _receiver,
        uint256 _amount,
        bytes memory _data
    ) private 
    {
        ERC677Receiver receiver = ERC677Receiver(_receiver);
        receiver.tokenFallback(msg.sender, _amount, _data);
    }
}
