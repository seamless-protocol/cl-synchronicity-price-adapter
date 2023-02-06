// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
import {CLrETHSynchronicityPriceAdapter} from '../src/contracts/CLrETHSynchronicityPriceAdapter.sol';
import {BaseAggregators} from '../src/lib/BaseAggregators.sol';

contract DeploycbETH is Script {
  address public constant RETH = 0xae78736Cd615f374D3085123A210448E74Fc6393;

  function run() external {
    vm.startBroadcast();

    new CLrETHSynchronicityPriceAdapter(BaseAggregators.ETH_USD_AGGREGATOR, RETH, 'rETH/ETH/USD');

    vm.stopBroadcast();
  }
}
