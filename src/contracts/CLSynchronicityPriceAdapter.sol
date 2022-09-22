// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {IChainlinkAggregator} from '../interfaces/IChainlinkAggregator.sol';
import {ICLSynchronicityPriceAdapter} from '../interfaces/ICLSynchronicityPriceAdapter.sol';

contract CLSynchronicityPriceAdapter is ICLSynchronicityPriceAdapter   {
    IChainlinkAggregator public immutable ethUsdAggregator;
    IChainlinkAggregator public immutable assetUsdAggregator;

    uint8 public immutable DECIMALS;
    int256 public immutable DECIMALS_MULTIPLIER;
    
    constructor(
        address ethUsdAggregatorAddress,
        address assetUsdAggregatorAddress,
        uint8 decimals
    ) {
        ethUsdAggregator = IChainlinkAggregator(ethUsdAggregatorAddress);
        assetUsdAggregator = IChainlinkAggregator(assetUsdAggregatorAddress);

        uint8 assetUsdAggregatorDecimals = assetUsdAggregator.decimals();
        uint8 ethUsdAggregatorDecimals = ethUsdAggregator.decimals();

        DECIMALS = decimals;

        DECIMALS_MULTIPLIER = 
          _calcDecimalsMultiplier(
            assetUsdAggregatorDecimals,
            ethUsdAggregatorDecimals,
            DECIMALS
          );
    }

    function latestAnswer() override external view returns (int256) {
        int256 assetPrice = assetUsdAggregator.latestAnswer();
        int256 ethPrice = ethUsdAggregator.latestAnswer();
        
        return (assetPrice * DECIMALS_MULTIPLIER) / ethPrice;
    }

    function _calcDecimalsMultiplier(
        uint8 assetDecimals, 
        uint8 ethDecimals,
        uint8 resultDecimals
    ) internal pure returns(int256) {
        int256 multiplier = int256(10 ** resultDecimals);
        if (assetDecimals < ethDecimals) {
            multiplier *= int256(10 ** (ethDecimals - assetDecimals));
        } else {
            multiplier /= int256(10 ** (assetDecimals - ethDecimals));
        }
        return multiplier;
    }
}