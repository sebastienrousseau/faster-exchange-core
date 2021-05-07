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
pragma solidity 0.5.16;

import './ERC223.sol';

contract ERC223Factory {
    mapping(address => address[]) public created;
    mapping(address => bool) public isERC223; //verify without having to do a bytecode check.
    bytes public ERC223ByteCode; // solhint-disable-line var-name-mixedcase

    function createToken() public returns (address) {
        //upon creation of the factory, deploy a ERC223 (parameters are meaningless) and store the bytecode provably.
        address verifiedToken =
            createERC223(
                1000000,
                'Faster Exchange Transaction Credits',
                0,
                'Faster Exchange'
            );
        ERC223ByteCode = codeAt(verifiedToken);
    }

    //verifies if a contract that has been deployed is a Human Standard Token.
    //NOTE: This is a very expensive function, and should only be used in an eth_call. ~800k gas
    function verifyERC223(address _tokenContract) public view returns (bool) {
        bytes memory fetchedTokenByteCode = codeAt(_tokenContract);

        if (fetchedTokenByteCode.length != ERC223ByteCode.length) {
            return false; //clear mismatch
        }

        //starting iterating through it if lengths match
        for (uint256 i = 0; i < fetchedTokenByteCode.length; i++) {
            if (fetchedTokenByteCode[i] != ERC223ByteCode[i]) {
                return false;
            }
            return true;
        }
    }

    function createERC223(
        uint256 _initialAmount,
        string memory _name,
        uint8 _decimals,
        string memory _symbol
    ) public returns (address) {
        ERC223 newToken =
            (new ERC223(_initialAmount, _name, _decimals, _symbol));
        created[msg.sender].push(address(newToken));
        isERC223[address(newToken)] = true;
        //the factory will own the created tokens. You must transfer them.
        newToken.transfer(msg.sender, _initialAmount);
        return address(newToken);
    }

    //for now, keeping this internal. Ideally there should also be a live version of this that
    // any contract can use, lib-style.
    //retrieves the bytecode at a specific address.
    function codeAt(address _addr)
        internal
        view
        returns (bytes memory outputCode)
    {
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            // solhint-disable-line no-inline-assembly
            // retrieve the size of the code, this needs assembly
            let size := extcodesize(_addr)
            // allocate output byte array - this could also be done without assembly
            // by using outputCode = new bytes(size)
            outputCode := mload(0x40)
            // new "memory end" including padding
            mstore(
                0x40,
                add(outputCode, and(add(add(size, 0x20), 0x1f), not(0x1f)))
            )
            // store length in memory
            mstore(outputCode, size)
            // actually retrieve the code, this needs assembly
            extcodecopy(_addr, add(outputCode, 0x20), 0, size)
        }
    }
}
