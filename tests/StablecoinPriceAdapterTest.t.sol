// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import "forge-std/console.sol";
import 'forge-std/Vm.sol';

import {StablecoinPriceAdapter} from "../src/contracts/StablecoinPriceAdapter.sol";
import {ProposalPayloadStablecoinsPriceAdapter} from '../src/contracts/ProposalPayloadStablecoinsPriceAdapter.sol';
import {GovHelpers, IAaveGov} from './helpers/AaveGovHelpers.sol';
import {IAaveOracle} from '../src/interfaces/IAaveOracle.sol';
import {IChainlinkAggregator} from '../src/interfaces/IChainlinkAggregator.sol';

contract ProposalPayloadStablecoinsPriceAdapterTest is Test {
  IAaveOracle public constant AAVE_ORACLE = 
    IAaveOracle(0xA50ba011c48153De246E5192C8f9258A2ba79Ca9);

  address public constant ETH_USD_AGGREGATOR = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;

  function setUp() public {}

  function testStablecoinPriceAdapter() public {

    address[] memory assets = new address[](7);
    address[] memory aggregators = new address[](7);
    address[] memory adapters = new address[](7);

    // USDT
    assets[0] = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    // DAI
    assets[1] = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    // FRAX
    assets[2] = 0x853d955aCEf822Db058eb8505911ED77F175b99e;
    // GUSD
    assets[3] = 0x056Fd409E1d7A124BD7017459dFEa2F387b6d5Cd;
    // LUSD
    assets[4] = 0x5f98805A4E8be255a32880FDeC7F6728C6568bA0;
    // USDC
    assets[5] = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    // USDP
    assets[6] = 0x8E870D67F660D95d5be530380D0eC0bd388289E1;

    // USDT/USD
    aggregators[0] = 0x3E7d1eAB13ad0104d2750B8863b489D65364e32D;
    // DAI/USD
    aggregators[1] = 0xAed0c38402a5d19df6E4c03F4E2DceD6e29c1ee9;
    // FRAX/USD
    aggregators[2] = 0xB9E1E3A9feFf48998E45Fa90847ed4D467E8BcfD;
    // GUSD/USD
    aggregators[3] = 0xa89f5d2365ce98B3cD68012b6f503ab1416245Fc;
    // LUSD/USD
    aggregators[4] = 0x3D7aE7E594f2f2091Ad8798313450130d0Aba3a0;
    // USDC/USD
    aggregators[5] = 0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6;
    // USDP/USD
    aggregators[6] = 0x09023c0DA49Aaf8fc3fA3ADF34C6A7016D38D5e3;


    // for each stable coin make price adapter
    for (uint8 i = 0; i < assets.length; i++) {
      StablecoinPriceAdapter adapter = new StablecoinPriceAdapter(
          ETH_USD_AGGREGATOR,
          aggregators[i]
      );

      adapters[i] = address(adapter);
    }

    for (uint8 i = 0; i < assets.length; i++) {
        uint256 currentPrice = AAVE_ORACLE.getAssetPrice(assets[i]);
        uint256 newPrice = uint256(StablecoinPriceAdapter(adapters[i]).latestAnswer());
            
        // TODO: how to assert prices
        console.log(currentPrice);
        console.log(newPrice);
    }
  }
}