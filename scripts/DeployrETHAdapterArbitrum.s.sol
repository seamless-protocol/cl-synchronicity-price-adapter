// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
import {CLrETHSynchronicityPriceAdapter} from '../src/contracts/CLrETHSynchronicityPriceAdapter.sol';
import {BaseAggregatorsArbitrum} from '../src/lib/BaseAggregators.sol';

contract DeployrETHArbitrum is Script {
  address public constant RETH = 0xEC70Dcb4A1EFa46b8F2D97C310C9c4790ba5ffA8;

  function run() external {
    vm.startBroadcast();

    new CLrETHSynchronicityPriceAdapter(
      BaseAggregatorsArbitrum.ETH_USD_AGGREGATOR,
      RETH,
      'rETH/ETH/USD'
    );

    vm.stopBroadcast();
  }
}
