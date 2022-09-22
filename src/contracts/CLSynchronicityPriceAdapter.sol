// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {IChainlinkAggregator} from '../interfaces/IChainlinkAggregator.sol';
import {ICLSynchronicityPriceAdapter} from '../interfaces/ICLSynchronicityPriceAdapter.sol';

error DecimalsMultiplierIsZero();

contract CLSynchronicityPriceAdapter is ICLSynchronicityPriceAdapter   {
    IChainlinkAggregator public immutable BASE_TO_PEG;
    IChainlinkAggregator public immutable ASSET_TO_PEG;

    uint8 public immutable DECIMALS;
    int256 public immutable DECIMALS_MULTIPLIER;
    
    constructor(
        address baseToPegAggregatorAddress,
        address asseToPegAggregatorAddress,
        uint8 decimals
    ) {
        BASE_TO_PEG = IChainlinkAggregator(baseToPegAggregatorAddress);
        ASSET_TO_PEG = IChainlinkAggregator(asseToPegAggregatorAddress);

        DECIMALS = decimals;

        DECIMALS_MULTIPLIER = 
          _calcDecimalsMultiplier(
            ASSET_TO_PEG.decimals(),
            BASE_TO_PEG.decimals(),
            DECIMALS
          );

        if (DECIMALS_MULTIPLIER == 0) revert DecimalsMultiplierIsZero();
    }

    function latestAnswer() override external view returns (int256) {
        int256 assetToPegPrice = ASSET_TO_PEG.latestAnswer();
        int256 baseToPegPrice = BASE_TO_PEG.latestAnswer();
        
        return (assetToPegPrice * DECIMALS_MULTIPLIER) / baseToPegPrice;
    }

    function _calcDecimalsMultiplier(
        uint8 assetToPegDecimals, 
        uint8 baseToPegDecimals,
        uint8 resultDecimals
    ) internal pure returns(int256) {
        int256 multiplier = int256(10 ** resultDecimals);
        if (assetToPegDecimals < baseToPegDecimals) {
            multiplier *= int256(10 ** (baseToPegDecimals - assetToPegDecimals));
        } else {
            multiplier /= int256(10 ** (assetToPegDecimals - baseToPegDecimals));
        }
        return multiplier;
    }
}