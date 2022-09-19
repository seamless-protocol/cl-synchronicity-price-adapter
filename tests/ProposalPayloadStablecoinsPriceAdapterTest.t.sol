// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import "forge-std/console.sol";

import {ProposalPayloadStablecoinsPriceAdapter} from '../src/contracts/ProposalPayloadStablecoinsPriceAdapter.sol';
import {StablecoinPriceAdapter} from '../src/contracts/StablecoinPriceAdapter.sol';
import {GovHelpers, IAaveGov} from './helpers/AaveGovHelpers.sol';
import {AaveV2Ethereum} from "aave-address-book/AaveAddressBook.sol";

contract ProposalPayloadStablecoinsPriceAdapterTest is 
  Test, 
  ProposalPayloadStablecoinsPriceAdapter 
{
  function setUp() public {}

  function testProposal() public {
    (
      address[] memory assets,
      address[] memory aggregators
    ) = _initAssetAggregators();

    ProposalPayloadStablecoinsPriceAdapter payload = new ProposalPayloadStablecoinsPriceAdapter();

    address[] memory targets = new address[](1);
    targets[0] = address(payload);
    uint256[] memory values = new uint256[](1);
    values[0] = 0;
    string[] memory signatures = new string[](1);
    signatures[0] = 'execute()';
    bytes[] memory calldatas = new bytes[](1);
    calldatas[0] = '';
    bool[] memory withDelegatecalls = new bool[](1);
    withDelegatecalls[0] = true;

    IAaveGov.SPropCreateParams memory createParams = IAaveGov
      .SPropCreateParams({
        executor: GovHelpers.SHORT_EXECUTOR,
        targets: targets,
        values: values,
        signatures: signatures,
        calldatas: calldatas,
        withDelegatecalls: withDelegatecalls,
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
        StablecoinPriceAdapter(newSource).assetUsdAggregator()
      );
      assertTrue(assetUsdAggregator == aggregators[i]);
    }    
  }
}