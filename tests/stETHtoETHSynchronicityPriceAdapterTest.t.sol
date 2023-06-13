// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';

import {stETHtoETHSynchronicityPriceAdapter} from '../src/contracts/stETHtoETHSynchronicityPriceAdapter.sol';
import {BaseAggregatorsMainnet} from '../src/lib/BaseAggregators.sol';

contract stETHtoETHSynchronicityPriceAdapterTest is Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 17446450);
  }

  function testLatestAnswer() public {
    stETHtoETHSynchronicityPriceAdapter adapter = new stETHtoETHSynchronicityPriceAdapter(
      'stETH/ETH'
    );

    int256 price = adapter.latestAnswer();

    assertEq(uint256(price), 1000000000000000000);
  }
}
