// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IChainlinkAggregator} from '../interfaces/IChainlinkAggregator.sol';
import './dependencies/openzeppelin/Ownable.sol';


contract StablecoinPriceAdapter is Ownable  {
    IChainlinkAggregator public ethUsdAggregator;
    IChainlinkAggregator public assetUsdAggregator;

    uint8 constant public DECIMALS = 18;
    int256 constant public DECIMALS_POW10 = int256(10**DECIMALS);
    
    constructor(
        address ethUsdAggregatorAddress,
        address assetUsdAggregatorAddress
    ) Ownable() {
        ethUsdAggregator = IChainlinkAggregator(ethUsdAggregatorAddress);
        assetUsdAggregator = IChainlinkAggregator(assetUsdAggregatorAddress);
    }

    function setEthAggregator(address ethUsdAggregatorAddress) external onlyOwner {
        ethUsdAggregator = IChainlinkAggregator(ethUsdAggregatorAddress);
    }

    function setAssetAggregator(address assetUsdAggregatorAddress) external onlyOwner {
        assetUsdAggregator = IChainlinkAggregator(assetUsdAggregatorAddress);
    }

    function latestAnswer() external view returns (int256) {
        int256 assetPrice = assetUsdAggregator.latestAnswer();
        int256 assetScaledPrice = scalePrice(assetPrice, assetUsdAggregator.decimals(), DECIMALS);

        int256 ethPrice = ethUsdAggregator.latestAnswer();
        int256 ethScaledPrice = scalePrice(ethPrice, ethUsdAggregator.decimals(), DECIMALS);
        
        return (assetScaledPrice * DECIMALS_POW10) / ethScaledPrice;
    }

    function scalePrice(int256 _price, uint8 _priceDecimals, uint8 _decimals)
        internal
        pure
        returns (int256)
    {
        if (_priceDecimals < _decimals) {
            return _price * int256(10 ** uint256(_decimals - _priceDecimals));
        } else if (_priceDecimals > _decimals) {
            return _price / int256(10 ** uint256(_priceDecimals - _decimals));
        }
        return _price;
    }
}