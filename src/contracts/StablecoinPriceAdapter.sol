// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {IChainlinkAggregator} from '../interfaces/IChainlinkAggregator.sol';

error DifferentAggregatorsDecimals();

contract StablecoinPriceAdapter  {
    IChainlinkAggregator public immutable ethUsdAggregator;
    IChainlinkAggregator public immutable assetUsdAggregator;

    uint8 constant public resultDecimals = 18;
    int256 constant public resultDecimals_pow10 = int256(10**resultDecimals);
    
    constructor(
        address ethUsdAggregatorAddress,
        address assetUsdAggregatorAddress
    ) {
        ethUsdAggregator = IChainlinkAggregator(ethUsdAggregatorAddress);
        assetUsdAggregator = IChainlinkAggregator(assetUsdAggregatorAddress);

        if (ethUsdAggregator.decimals() != assetUsdAggregator.decimals()) {
            revert DifferentAggregatorsDecimals(); 
        }
    }

    function latestAnswer() external view returns (int256) {
        int256 assetPrice = assetUsdAggregator.latestAnswer();
        int256 ethPrice = ethUsdAggregator.latestAnswer();
        
        return (assetPrice * resultDecimals_pow10) / ethPrice;
    }
}