// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
import {CLwstETHSynchronicityPriceAdapter} from '../src/contracts/CLwstETHSynchronicityPriceAdapter.sol';
import {CLSynchronicityPriceAdapterPegToBase} from '../src/contracts/CLSynchronicityPriceAdapterPegToBase.sol';
import {BaseAggregatorsMainnet, BaseAggregatorsArbitrum, BaseAggregatorsOptimism} from '../src/lib/BaseAggregators.sol';

contract DeployWstETHMainnet is Script {
  address public constant STETH = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84;

  function run() external {
    vm.startBroadcast();

    new CLwstETHSynchronicityPriceAdapter(
      BaseAggregatorsMainnet.ETH_USD_AGGREGATOR,
      BaseAggregatorsMainnet.STETH_ETH_AGGREGATOR,
      8,
      STETH,
      'wstETH/stETH/ETH/USD'
    );

    vm.stopBroadcast();
  }
}

contract DeployWstETHArbitrum is Script {
  function run() external {
    vm.startBroadcast();

    new CLSynchronicityPriceAdapterPegToBase(
      BaseAggregatorsArbitrum.STETH_USD_AGGREGATOR,
      BaseAggregatorsArbitrum.WSTETH_ETH_AGGREGATOR,
      8,
      'wstETH/stETH/USD'
    );

    vm.stopBroadcast();
  }
}

contract DeployWstETHOptimism is Script {
  function run() external {
    vm.startBroadcast();

    new CLSynchronicityPriceAdapterPegToBase(
      BaseAggregatorsOptimism.STETH_USD_AGGREGATOR,
      BaseAggregatorsOptimism.WSTETH_ETH_AGGREGATOR,
      8,
      'wstETH/stETH/USD'
    );

    vm.stopBroadcast();
  }
}
