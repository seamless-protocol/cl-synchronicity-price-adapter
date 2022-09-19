// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './StablecoinPriceAdapter.sol';
import {IAaveOracle} from 'aave-address-book/AaveV2.sol';
import {AaveV2EthereumArc} from 'aave-address-book/AaveAddressBook.sol';

/**
 * @title ArcProposalPayloadStablecoinsPriceAdapter
 * @author BGD Labs
 * @notice Aave governance payload to add price adapter for stable coins
 */
contract ArcProposalPayloadStablecoinsPriceAdapter {

  address public constant ETH_USD_AGGREGATOR =
    0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;

  function _initAssetAggregators()
    internal
    pure
    returns (address[] memory, address[] memory)
  {
    address[] memory assets = new address[](1);
    address[] memory aggregators = new address[](1);

    // TODO: add assets

    // USDT
    assets[0] = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    aggregators[0] = 0x3E7d1eAB13ad0104d2750B8863b489D65364e32D;

    return (assets, aggregators);
  }

  function execute() external {
    (
      address[] memory assets,
      address[] memory aggregators
    ) = _initAssetAggregators();
    address[] memory adapters = new address[](assets.length);

    // for each stable coin make price adapter
    for (uint8 i = 0; i < assets.length; i++) {
      StablecoinPriceAdapter adapter = new StablecoinPriceAdapter(
        ETH_USD_AGGREGATOR,
        aggregators[i]
      );

      adapters[i] = address(adapter);
    }

    // set new asset source for all stable coins
    AaveV2EthereumArc.ORACLE.setAssetSources(assets, adapters);
  }
}
