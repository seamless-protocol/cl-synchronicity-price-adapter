// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
import {wstETHSynchronicityPriceAdapter} from '../src/contracts/wstETHSynchronicityPriceAdapter.sol';
import {stETHtoETHSynchronicityPriceAdapter} from '../src/contracts/stETHtoETHSynchronicityPriceAdapter.sol';
import {CLSynchronicityPriceAdapterPegToBase} from '../src/contracts/CLSynchronicityPriceAdapterPegToBase.sol';
import {BaseAggregatorsMainnet, BaseAggregatorsArbitrum, BaseAggregatorsOptimism} from '../src/lib/BaseAggregators.sol';

contract DeployStETHMainnetV2 is Script {
  function run() external {
    vm.startBroadcast();

    new stETHtoETHSynchronicityPriceAdapter('stETH/ETH');

    vm.stopBroadcast();
  }
}

contract DeployWstETHMainnetV3 is Script {
  address public constant STETH = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84;

  function run() external {
    vm.startBroadcast();

    new wstETHSynchronicityPriceAdapter(
      BaseAggregatorsMainnet.ETH_USD_AGGREGATOR,
      STETH,
      'wstETH/ETH/USD'
    );

    vm.stopBroadcast();
  }
}

contract DeployWstETHArbitrum is Script {
  function run() external {
    vm.startBroadcast();

    new CLSynchronicityPriceAdapterPegToBase(
      BaseAggregatorsArbitrum.ETH_USD_AGGREGATOR,
      BaseAggregatorsArbitrum.WSTETH_STETH_AGGREGATOR,
      8,
      'wstETH/ETH/USD'
    );

    vm.stopBroadcast();
  }
}

contract DeployWstETHOptimism is Script {
  function run() external {
    vm.startBroadcast();

    new CLSynchronicityPriceAdapterPegToBase(
      BaseAggregatorsOptimism.ETH_USD_AGGREGATOR,
      BaseAggregatorsOptimism.WSTETH_STETH_AGGREGATOR,
      8,
      'wstETH/ETH/USD'
    );

    vm.stopBroadcast();
  }
}
