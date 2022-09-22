// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import "forge-std/console.sol";

import {ProposalPayloadStablecoinsPriceAdapter} from '../src/contracts/ProposalPayloadStablecoinsPriceAdapter.sol';
import {CLSynchronicityPriceAdapter} from '../src/contracts/CLSynchronicityPriceAdapter.sol';
import {GovHelpers, IAaveGov} from './helpers/AaveGovHelpers.sol';
import {AaveV2Ethereum} from "aave-address-book/AaveAddressBook.sol";

contract ProposalPayloadStablecoinsPriceAdapterTest is 
  Test, 
  ProposalPayloadStablecoinsPriceAdapter 
{
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('ethereum'), 15588955);
  }

  function testProposal() public {
    (
      address[] memory assets,
      address[] memory aggregators
    ) = _initAssetAggregators();

    ProposalPayloadStablecoinsPriceAdapter payload = new ProposalPayloadStablecoinsPriceAdapter();

    IAaveGov.SPropCreateParams memory createParams = GovHelpers.createProposalParamsForOneTarget({
      executor: GovHelpers.SHORT_EXECUTOR,
      target: address(payload),
      value: 0,
      signature: 'execute()',
      calldatabytes: '',
      withDelegatecall: true,
      ipfsHash: bytes32(0)
    });

    uint256 proposalId = GovHelpers.createProposal(vm, createParams);

    GovHelpers.passVoteAndExecute(vm, proposalId);

    _validate(assets, aggregators);
  }

  function _validate(address[] memory assets, address[] memory aggregators) internal {

    //Check if source for every asset is changed
    for (uint8 i = 0; i < assets.length; i++) {
      address newSource = AaveV2Ethereum.ORACLE.getSourceOfAsset(assets[i]);
      address assetUsdAggregator = address(
        CLSynchronicityPriceAdapter(newSource).ASSET_TO_PEG()
      );
      assertTrue(assetUsdAggregator == aggregators[i]);
    }    
  }
}