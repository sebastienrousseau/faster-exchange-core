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
// solhint-disable
pragma solidity 0.5.16;

import "./FasterExchangeToken.sol";
import "./Ownable.sol";

/*
 * @title Faster Exchange Token initial distribution
 *
 * @dev Distribute purchasers, airdrop, reserve, and founder tokens
 */


contract FasterExchangeDistribution is Ownable {
    using SafeMath for uint256;

    FasterExchangeToken public fstXchg;

    uint256 private constant DECIMAL_FACTOR = 10**uint256(18);
    enum AllocationType { PRESALE, FOUNDER, AIRDROP, ADVISOR, RESERVE, BONUS1, BONUS2, BONUS3 }
    uint256 public constant INITIAL_SUPPLY   = 1000000000 * DECIMAL_FACTOR;
    uint256 public AVAILABLE_TOTAL_SUPPLY    = 1000000000 * DECIMAL_FACTOR;
    uint256 public AVAILABLE_PRESALE_SUPPLY  =  230000000 * DECIMAL_FACTOR; // 100% Released at Token Distribution (TD)
    uint256 public AVAILABLE_FOUNDER_SUPPLY  =  150000000 * DECIMAL_FACTOR; // 33% Released at TD +1 year -> 100% at TD +3 years
    uint256 public AVAILABLE_AIRDROP_SUPPLY  =   10000000 * DECIMAL_FACTOR; // 100% Released at TD
    uint256 public AVAILABLE_ADVISOR_SUPPLY  =   20000000 * DECIMAL_FACTOR; // 100% Released at TD +7 months
    uint256 public AVAILABLE_RESERVE_SUPPLY  =  513116658 * DECIMAL_FACTOR; // 6.8% Released at TD +100 days -> 100% at TD +4 years
    uint256 public AVAILABLE_BONUS1_SUPPLY  =    39053330 * DECIMAL_FACTOR; // 100% Released at TD +1 year
    uint256 public AVAILABLE_BONUS2_SUPPLY  =     9354408 * DECIMAL_FACTOR; // 100% Released at TD +2 years
    uint256 public AVAILABLE_BONUS3_SUPPLY  =    28475604 * DECIMAL_FACTOR; // 100% Released at TD +3 years

    uint256 public grandTotalClaimed = 0;
    uint256 public startTime;

  // Allocation with vesting information
    struct Allocation {
        uint8   allocationSupply; // Type of allocation
        uint256 endCliff;       // Tokens are locked until
        uint256 endVesting;     // This is when the tokens are fully unvested
        uint256 totalAllocated; // Total tokens allocated
        uint256 amountClaimed;  // Total tokens claimed
    }

    mapping (address => Allocation) public allocations;

    // List of admins
    mapping (address => bool) public airdropAdmins;

    // Keeps track of whether or not a 250 fstXchg airdrop has been made to a particular address
    mapping (address => bool) public airdrops;

    modifier onlyOwnerOrAdmin() {
        require(msg.sender == owner || airdropAdmins[msg.sender],"Only owner can call this function.");
        _;
    }

    event LogNewAllocation(address indexed _recipient, AllocationType indexed _fromSupply, uint256 _totalAllocated, uint256 _grandTotalAllocated);
    event LogfstXchgClaimed(address indexed _recipient, uint8 indexed _fromSupply, uint256 _amountClaimed, uint256 _totalAllocated, uint256 _grandTotalClaimed);

  /**
    * @dev Constructor function - Set the fstXchg token address
    * @param _startTime The time when FasterExchangeDistribution goes live
    */
    function fstXchgDistribution(uint256 _startTime) public {
        require(_startTime >= block.timestamp);
        require(
            AVAILABLE_TOTAL_SUPPLY == AVAILABLE_PRESALE_SUPPLY
            .add(AVAILABLE_FOUNDER_SUPPLY)
            .add(AVAILABLE_AIRDROP_SUPPLY)
            .add(AVAILABLE_ADVISOR_SUPPLY)
            .add(AVAILABLE_BONUS1_SUPPLY)
            .add(AVAILABLE_BONUS2_SUPPLY)
            .add(AVAILABLE_BONUS3_SUPPLY)
            .add(AVAILABLE_RESERVE_SUPPLY));
        startTime = _startTime;
        fstXchg = new FasterExchangeToken();
    }

  /**
    * @dev Allow the owner of the contract to assign a new allocation
    * @param _recipient The recipient of the allocation
    * @param _totalAllocated The total amount of fstXchg available to the receipient (after vesting)
    * @param _supply The fstXchg supply the allocation will be taken from
    */
    function setAllocation (address _recipient, uint256 _totalAllocated, AllocationType _supply) onlyOwner public {
        require(allocations[_recipient].totalAllocated == 0 && _totalAllocated > 0);
        require(_supply >= AllocationType.PRESALE && _supply <= AllocationType.BONUS3);
        require(_recipient != address(0));
        if (_supply == AllocationType.PRESALE) {
            AVAILABLE_PRESALE_SUPPLY = AVAILABLE_PRESALE_SUPPLY.sub(_totalAllocated);
            allocations[_recipient] = Allocation(uint8(AllocationType.PRESALE), 0, 0, _totalAllocated, 0);
        } else if (_supply == AllocationType.FOUNDER) {
            AVAILABLE_FOUNDER_SUPPLY = AVAILABLE_FOUNDER_SUPPLY.sub(_totalAllocated);
            allocations[_recipient] = Allocation(uint8(AllocationType.FOUNDER), startTime + 365 days, startTime + 1095 days, _totalAllocated, 0);
        } else if (_supply == AllocationType.ADVISOR) {
            AVAILABLE_ADVISOR_SUPPLY = AVAILABLE_ADVISOR_SUPPLY.sub(_totalAllocated);
            allocations[_recipient] = Allocation(uint8(AllocationType.ADVISOR), startTime + 209 days, 0, _totalAllocated, 0);
        } else if (_supply == AllocationType.RESERVE) {
            AVAILABLE_RESERVE_SUPPLY = AVAILABLE_RESERVE_SUPPLY.sub(_totalAllocated);
            allocations[_recipient] = Allocation(uint8(AllocationType.RESERVE), startTime + 100 days, startTime + 1460 days, _totalAllocated, 0);
        } else if (_supply == AllocationType.BONUS1) {
            AVAILABLE_BONUS1_SUPPLY = AVAILABLE_BONUS1_SUPPLY.sub(_totalAllocated);
            allocations[_recipient] = Allocation(uint8(AllocationType.BONUS1), startTime + 365 days, startTime + 365 days, _totalAllocated, 0);
        } else if (_supply == AllocationType.BONUS2) {
            AVAILABLE_BONUS2_SUPPLY = AVAILABLE_BONUS2_SUPPLY.sub(_totalAllocated);
            allocations[_recipient] = Allocation(uint8(AllocationType.BONUS2), startTime + 730 days, startTime + 730 days, _totalAllocated, 0);
        } else if (_supply == AllocationType.BONUS3) {
            AVAILABLE_BONUS3_SUPPLY = AVAILABLE_BONUS3_SUPPLY.sub(_totalAllocated);
            allocations[_recipient] = Allocation(uint8(AllocationType.BONUS3), startTime + 1095 days, startTime + 1095 days, _totalAllocated, 0);
        }
        AVAILABLE_TOTAL_SUPPLY = AVAILABLE_TOTAL_SUPPLY.sub(_totalAllocated);
        emit LogNewAllocation(_recipient, _supply, _totalAllocated, grandTotalAllocated());
    }

  /**
    * @dev Add an airdrop admin
    */
    function setAirdropAdmin(address _admin, bool _isAdmin) public onlyOwner {
        airdropAdmins[_admin] = _isAdmin;
    }

  /**
    * @dev perform a transfer of allocations
    * @param _recipient is a list of recipients
    */
    function airdropTokens(address[] memory _recipient) public onlyOwnerOrAdmin {
        require(block.timestamp >= startTime);
        uint airdropped;
        for (uint256 i = 0; i < _recipient.length; i++) {
            if (!airdrops[_recipient[i]]) {
                airdrops[_recipient[i]] = true;
                require(fstXchg.transfer(_recipient[i], 250 * DECIMAL_FACTOR));
                airdropped = airdropped.add(250 * DECIMAL_FACTOR);
            }
        }
        AVAILABLE_AIRDROP_SUPPLY = AVAILABLE_AIRDROP_SUPPLY.sub(airdropped);
        AVAILABLE_TOTAL_SUPPLY = AVAILABLE_TOTAL_SUPPLY.sub(airdropped);
        grandTotalClaimed = grandTotalClaimed.add(airdropped);
    }

  /**
    * @dev Transfer a recipients available allocation to their address
    * @param _recipient The address to withdraw tokens for
    */
    function transferTokens (address _recipient) public {
        require(allocations[_recipient].amountClaimed < allocations[_recipient].totalAllocated);
        require(block.timestamp >= allocations[_recipient].endCliff);
        require(block.timestamp >= startTime);
        uint256 newAmountClaimed;
        if (allocations[_recipient].endVesting > block.timestamp) {
            // Transfer available amount based on vesting schedule and allocation
            newAmountClaimed = allocations[_recipient]
                .totalAllocated.mul(block.timestamp.sub(startTime))
                .div(allocations[_recipient].endVesting.sub(startTime));
        } else {
            // Transfer total allocated (minus previously claimed tokens)
            newAmountClaimed = allocations[_recipient].totalAllocated;
        }
        uint256 tokensToTransfer = newAmountClaimed.sub(allocations[_recipient].amountClaimed);
        allocations[_recipient].amountClaimed = newAmountClaimed;
        require(fstXchg.transfer(_recipient, tokensToTransfer));
        grandTotalClaimed = grandTotalClaimed.add(tokensToTransfer);
        emit LogfstXchgClaimed(_recipient, allocations[_recipient].allocationSupply, tokensToTransfer, newAmountClaimed, grandTotalClaimed);
    }

    // Returns the amount of fstXchg allocated
    function grandTotalAllocated() public view returns (uint256) {
        return INITIAL_SUPPLY - AVAILABLE_TOTAL_SUPPLY;
    }

    // Allow transfer of accidentally sent ERC20 tokens
    function refundTokens(address _recipient, address _token) public onlyOwner {
        require(_token != address(fstXchg));
        IERC20 token = IERC20(_token);
        uint256 balance = token.balanceOf(address(this));
        require(token.transfer(_recipient, balance));
    }
}
