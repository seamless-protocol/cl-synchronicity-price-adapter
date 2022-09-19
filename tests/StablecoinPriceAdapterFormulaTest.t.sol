// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import "forge-std/console.sol";

import {StablecoinPriceAdapter} from '../src/contracts/StablecoinPriceAdapter.sol';
import {IChainlinkAggregator} from '../src/interfaces/IChainlinkAggregator.sol';
import {MockAggregator} from './mock/MockAggregator.sol';

contract StablecoinPriceAdapterFormulaTest is Test {

  IChainlinkAggregator public constant ETH_USD_AGGREGATOR = 
    IChainlinkAggregator(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);

  function setUp() public {}

  function testFormula() public {

    uint256 TESTS = 10;
  
    int256 ethPrice = ETH_USD_AGGREGATOR.latestAnswer();
    
    for (uint256 i = 1; i <= TESTS; i++) {
      
      MockAggregator aggregator = new MockAggregator(
        ethPrice / int256(i), 
        ETH_USD_AGGREGATOR.decimals()
      ); 

      StablecoinPriceAdapter adapter = new StablecoinPriceAdapter(
        address(ETH_USD_AGGREGATOR),
        address(aggregator)
      );

      int256 price = adapter.latestAnswer();
      int256 expectedPriceInEth = int256(1 ether / i);

      int256 maxDiff = int256(10 ** (aggregator.decimals()));
      assertTrue(_abs(price - expectedPriceInEth) < maxDiff);
    }
  }

  function _abs(int256 x) internal pure returns(int256) {
    return (x > 0) ? x : -x;
  }
}