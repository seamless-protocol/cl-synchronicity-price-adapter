// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';

import {ArcProposalPayloadStablecoinsPriceAdapter} from '../src/contracts/ArcProposalPayloadStablecoinsPriceAdapter.sol';
import {StablecoinPriceAdapter} from '../src/contracts/StablecoinPriceAdapter.sol';
import {TimelockHelpers, ITimelockExecutor} from './helpers/TimelockHelpers.sol';
import {AaveV2EthereumArc} from 'aave-address-book/AaveAddressBook.sol';

contract ArcProposalPayloadStablecoinsPriceAdapterTest is
  Test,
  ArcProposalPayloadStablecoinsPriceAdapter
{
  function setUp() public {}

  function testProposal() public {
    (
      address[] memory assets,
      address[] memory aggregators
    ) = _initAssetAggregators();

    ArcProposalPayloadStablecoinsPriceAdapter payload = new ArcProposalPayloadStablecoinsPriceAdapter();

    ITimelockExecutor.SPropQueueParams memory queueParams = TimelockHelpers
      .createProposalParamsForOneTarget({
        target: address(payload),
        value: 0,
        signature: 'execute()',
        calldatabytes: '',
        withDelegatecall: true
      });

    uint256 delay = TimelockHelpers.getTimelockExecutorDelay();
    uint256 actionSetId = TimelockHelpers.queueActionSet(vm, queueParams);
    vm.warp(block.timestamp + delay + 1);
    TimelockHelpers.executeActionSet(actionSetId);

    _validate(assets, aggregators);
  }

  function _validate(address[] memory assets, address[] memory aggregators)
    internal
  {
    //Check if source for every asset is changed
    for (uint8 i = 0; i < assets.length; i++) {
      address newSource = AaveV2EthereumArc.ORACLE.getSourceOfAsset(assets[i]);
      address assetUsdAggregator = address(
        StablecoinPriceAdapter(newSource).assetUsdAggregator()
      );
      assertTrue(assetUsdAggregator == aggregators[i]);
    }
  }
}
