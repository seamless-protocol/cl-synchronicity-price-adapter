// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';

import {wstETHtoETHSynchronicityPriceAdapter} from '../src/contracts/wstETHtoETHSynchronicityPriceAdapter.sol';
import {BaseAggregatorsMainnet} from '../src/lib/BaseAggregators.sol';

contract wstETHtoETHSynchronicityPriceAdapterTest is Test {
  address public constant STETH = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 17446450);
  }

  function testLatestAnswer() public {
    wstETHtoETHSynchronicityPriceAdapter adapter = new wstETHtoETHSynchronicityPriceAdapter(
      STETH,
      'wstETH/stETH/ETH'
    );

    int256 price = adapter.latestAnswer();

    assertApproxEqAbs(
      uint256(price),
      1127777393383760000, // value calculated manually for selected block
      100000000000000
    );
  }
}
