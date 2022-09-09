// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import "forge-std/console.sol";

import {ProposalPayloadStablecoinsPriceAdapter} from '../src/contracts/ProposalPayloadStablecoinsPriceAdapter.sol';
import {GovHelpers, IAaveGov} from './helpers/AaveGovHelpers.sol';
import {IAaveOracle} from '../src/interfaces/IAaveOracle.sol';
import {IChainlinkAggregator} from '../src/interfaces/IChainlinkAggregator.sol';

contract ProposalPayloadStablecoinsPriceAdapterTest is Test {
  IAaveOracle public constant AAVE_ORACLE = 
    IAaveOracle(0xA50ba011c48153De246E5192C8f9258A2ba79Ca9);

  function setUp() public {}

  function testProposal() public {

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
    _validate();
  }

  function _validate() internal {
    // TODO: validation
  }
}