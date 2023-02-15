// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';

import {CLwstETHSynchronicityPriceAdapter} from '../src/contracts/CLwstETHSynchronicityPriceAdapter.sol';
import {BaseAggregatorsMainnet} from '../src/lib/BaseAggregators.sol';

contract CLwstETHSynchronicityPriceAdapterTest is Test {
  address public constant STETH = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 15588955);
  }

  function testLatestAnswer() public {
    CLwstETHSynchronicityPriceAdapter adapter = new CLwstETHSynchronicityPriceAdapter(
      BaseAggregatorsMainnet.ETH_USD_AGGREGATOR,
      BaseAggregatorsMainnet.STETH_ETH_AGGREGATOR,
      18,
      STETH,
      'wstETH/stETH/ETH/USD'
    );

    int256 price = adapter.latestAnswer();

    assertApproxEqAbs(
      uint256(price),
      1408000000000000000000, // value calculated manually for selected block
      1000000000000000000
    );
  }
}
