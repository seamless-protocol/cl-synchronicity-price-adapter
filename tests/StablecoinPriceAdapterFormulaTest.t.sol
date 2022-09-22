// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';

import {StablecoinPriceAdapter} from '../src/contracts/StablecoinPriceAdapter.sol';
import {IChainlinkAggregator} from '../src/interfaces/IChainlinkAggregator.sol';

contract StablecoinPriceAdapterFormulaTest is Test {

  IChainlinkAggregator public constant ETH_USD_AGGREGATOR = 
    IChainlinkAggregator(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);

  function setUp() public {}

  function testFormula() public {
    uint256 TESTS = 10;
  
    int256 ethPrice = ETH_USD_AGGREGATOR.latestAnswer();
    uint8 ethAggregatorDecimals = ETH_USD_AGGREGATOR.decimals();

    for (uint256 i = 1; i <= TESTS; i++) {
      address mockAggregator = address(0);
      int256 mockPrice = ethPrice / int256(i);
      _setMockPrice(mockAggregator, mockPrice);

      StablecoinPriceAdapter adapter = new StablecoinPriceAdapter(
        address(ETH_USD_AGGREGATOR),
        mockAggregator
      );

      int256 price = adapter.latestAnswer();
      int256 expectedPriceInEth = int256(1 ether / i);

      int256 maxDiff = int256(10 ** (ethAggregatorDecimals));
      assertApproxEqAbs(uint256(price), uint256(expectedPriceInEth), uint256(maxDiff));
    }
  }

  function _setMockPrice(address mockAggregator, int256 mockPrice) internal {
      bytes memory latestAnswerCall = abi.encodeWithSignature("latestAnswer()");
      bytes memory decimalsCall = abi.encodeWithSignature("decimals()");

      vm.mockCall(mockAggregator, latestAnswerCall, abi.encode(mockPrice));
      vm.mockCall(mockAggregator, decimalsCall, abi.encode(8));
  }
}