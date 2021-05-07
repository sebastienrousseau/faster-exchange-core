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
/* jshint esversion: 6 */
const FasterExchangeDistribution = artifacts.require('../contracts/FasterExchangeTokenDistribution.sol');
/* jshint unused:false */
module.exports = async (deployer, network) => {
  const currentTime = Date.now();
  const fromNow = 129600 * 1000; // Start distribution in 1 hour
  const startTime = (currentTime + fromNow) / 1000;

  await deployer.deploy(FasterExchangeDistribution, startTime);

  console.log(`
    --------------------------------------------------------------
    ----- Faster Exchange Network Smart contracts successfully deployed -----
    --------------------------------------------------------------
    - Contract address: ${FasterExchangeDistribution.address}
    - Distribution starts in: ${fromNow / 1000 / 60} minutes
    - Local Time: ${new Date(currentTime + fromNow)}
    --------------------------------------------------------------
  `);
};
