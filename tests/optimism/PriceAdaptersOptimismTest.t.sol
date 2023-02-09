// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// temporary commented due to rpc problems

// import {Test} from 'forge-std/Test.sol';

// import {CLSynchronicityPriceAdapterPegToBase} from '../../src/contracts/CLSynchronicityPriceAdapterPegToBase.sol';
// import {BaseAggregatorsOptimism} from '../../src/lib/BaseAggregators.sol';

// contract PriceAdaptersOptimismTest is Test {
//   function setUp() public {
//     vm.createSelectFork(vm.rpcUrl('optimism'), 73138329);
//   }

//   function testwstETHLatestAnswer() public {
//     CLSynchronicityPriceAdapterPegToBase adapter = new CLSynchronicityPriceAdapterPegToBase(
//       BaseAggregatorsOptimism.STETH_USD_AGGREGATOR,
//       BaseAggregatorsOptimism.WSTETH_ETH_AGGREGATOR,
//       8,
//       'wstETH/stETH/USD'
//     );
//     int256 price = adapter.latestAnswer();
//     assertApproxEqAbs(
//       uint256(price),
//       180278770000, // value calculated manually for selected block
//       10000
//     );
//   }
// }
