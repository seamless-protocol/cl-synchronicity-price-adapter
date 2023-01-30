// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';

import {CLSynchronicityPriceAdapterPegToBase} from '../src/contracts/CLSynchronicityPriceAdapterPegToBase.sol';
import {IChainlinkAggregator} from '../src/interfaces/IChainlinkAggregator.sol';
import {BaseAggregators} from '../src/lib/BaseAggregators.sol';

contract CLSynchronicityPriceAdapterPegToBaseTest is Test {
  uint256 public constant START_BLOCK = 15588955;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), START_BLOCK);
  }

  function testLatestAnswer() public {
    CLSynchronicityPriceAdapterPegToBase adapter = new CLSynchronicityPriceAdapterPegToBase(
      BaseAggregators.ETH_USD_AGGREGATOR,
      BaseAggregators.STETH_ETH_AGGREGATOR,
      18,
      'stETH/ETH/USD'
    );

    int256 price = adapter.latestAnswer();

    assertApproxEqAbs(
      uint256(price),
      1295000000000000000000, // value calculated manually for selected block
      1000000000000000000
    );
  }

  function testLatestAnswerWbtc() public {
    CLSynchronicityPriceAdapterPegToBase adapter = new CLSynchronicityPriceAdapterPegToBase(
      BaseAggregators.BTC_USD_AGGREGATOR,
      BaseAggregators.WBTC_BTC_AGGREGATOR,
      8,
      'wBTC/BTC/USD'
    );

    int256 price = adapter.latestAnswer();

    assertApproxEqAbs(
      uint256(price),
      1923700000000, // value calculated manually for selected block
      10 ** 8
    );
  }

  function testLatestAnswercbETH() public {
    // the feed is not availble at START_BLOCK yet
    uint256 START_BLOCK_CB_ETH = 16477236;
    vm.rollFork(START_BLOCK_CB_ETH);

    CLSynchronicityPriceAdapterPegToBase adapter = new CLSynchronicityPriceAdapterPegToBase(
      BaseAggregators.ETH_USD_AGGREGATOR,
      BaseAggregators.CBETH_ETH_AGGREGATOR,
      8,
      'cbETH/ETH/USD'
    );

    int256 price = adapter.latestAnswer();

    assertApproxEqAbs(
      uint256(price),
      162417252778, // value calculated manually for selected block (1003504805547725400 & 161850000000)
      10 ** 8
    );
  }

  function testLatestAnswerWbtcRelativelyBtcFeed() public {
    IChainlinkAggregator aggregator = IChainlinkAggregator(BaseAggregators.BTC_USD_AGGREGATOR);

    for (uint256 i; i < 10; i++) {
      CLSynchronicityPriceAdapterPegToBase adapter = new CLSynchronicityPriceAdapterPegToBase(
        BaseAggregators.BTC_USD_AGGREGATOR,
        BaseAggregators.WBTC_BTC_AGGREGATOR,
        8,
        'wBTC/BTC/USD'
      );

      int256 price = adapter.latestAnswer();
      int256 btcPrice = aggregator.latestAnswer();

      assertApproxEqRel(price, btcPrice, 0.0003e18); // 0.03%

      vm.rollFork(START_BLOCK + 500 * (i + 1));
    }
  }

  function testPegToBaseOracleReturnsNegative() public {
    address mockAggregator1 = address(0);
    address mockAggregator2 = address(1);

    _setMockPrice(mockAggregator1, -1, 4);
    _setMockPrice(mockAggregator2, 10000, 4);

    CLSynchronicityPriceAdapterPegToBase adapter = new CLSynchronicityPriceAdapterPegToBase(
      mockAggregator1,
      mockAggregator2,
      4,
      'MOCK'
    );

    int256 price = adapter.latestAnswer();

    assertEq(price, 0);
  }

  function testAssetToPegOracleReturnsZero() public {
    address mockAggregator1 = address(0);
    address mockAggregator2 = address(1);

    _setMockPrice(mockAggregator1, 10000, 4);
    _setMockPrice(mockAggregator2, 0, 4);

    CLSynchronicityPriceAdapterPegToBase adapter = new CLSynchronicityPriceAdapterPegToBase(
      mockAggregator1,
      mockAggregator2,
      4,
      'MOCK'
    );

    int256 price = adapter.latestAnswer();

    assertEq(price, 0);
  }

  function _setMockPrice(address mockAggregator, int256 mockPrice, uint256 decimals) internal {
    bytes memory latestAnswerCall = abi.encodeWithSignature('latestAnswer()');
    bytes memory decimalsCall = abi.encodeWithSignature('decimals()');

    vm.mockCall(mockAggregator, latestAnswerCall, abi.encode(mockPrice));
    vm.mockCall(mockAggregator, decimalsCall, abi.encode(decimals));
  }
}
