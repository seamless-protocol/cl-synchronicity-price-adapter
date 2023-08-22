// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
import {sDAISynchronicityPriceAdapter} from '../src/contracts/sDAISynchronicityPriceAdapter.sol';
import {BaseAggregatorsMainnet} from '../src/lib/BaseAggregators.sol';

contract DeploysDAIMainnet is Script {
  function run() external {
    vm.startBroadcast();

    new sDAISynchronicityPriceAdapter(
      BaseAggregatorsMainnet.DAI_USD_AGGREGATOR,
      BaseAggregatorsMainnet.SDAI_POT,
      'sDAI/DAI/USD'
    );

    vm.stopBroadcast();
  }
}
