// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
import {CLSynchronicityPriceAdapterPegToBase} from '../src/contracts/CLSynchronicityPriceAdapterPegToBase.sol';
import {BaseAggregatorsPolygon} from '../src/lib/BaseAggregatorsPolygon.sol';

contract DeployWstETHPolygon is Script {
  function run() external {
    vm.startBroadcast();

    new CLSynchronicityPriceAdapterPegToBase(
      BaseAggregatorsPolygon.ETH_USD_AGGREGATOR,
      BaseAggregatorsPolygon.WSTETH_ETH_AGGREGATOR,
      8,
      'wstETH/ETH/USD'
    );

    vm.stopBroadcast();
  }
}
