// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {IChainlinkAggregator} from '../interfaces/IChainlinkAggregator.sol';
import {IStablecoinPriceAdapter} from '../interfaces/IStablecoinPriceAdapter.sol';

contract StablecoinPriceAdapter is IStablecoinPriceAdapter   {
    IChainlinkAggregator public immutable ethUsdAggregator;
    IChainlinkAggregator public immutable assetUsdAggregator;

    uint8 constant public resultDecimals = 18;
    int256 public immutable decimalsMultiplier;
    
    constructor(
        address ethUsdAggregatorAddress,
        address assetUsdAggregatorAddress
    ) {
        ethUsdAggregator = IChainlinkAggregator(ethUsdAggregatorAddress);
        assetUsdAggregator = IChainlinkAggregator(assetUsdAggregatorAddress);

        uint8 assetUsdAggregatorDecimals = assetUsdAggregator.decimals();
        uint8 ethUsdAggregatorDecimals = ethUsdAggregator.decimals();

        decimalsMultiplier = 
          _calcDecimalsMultiplier(
            assetUsdAggregatorDecimals,
            ethUsdAggregatorDecimals
          );
    }

    function latestAnswer() override external view returns (int256) {
        int256 assetPrice = assetUsdAggregator.latestAnswer();
        int256 ethPrice = ethUsdAggregator.latestAnswer();
        
        return (assetPrice * decimalsMultiplier) / ethPrice;
    }

    function decimals() override external pure returns(uint8) {
        return resultDecimals;
    }

    function _calcDecimalsMultiplier(
        uint8 assetDecimals, 
        uint8 ethDecimals
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