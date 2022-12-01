// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {IChainlinkAggregator} from '../interfaces/IChainlinkAggregator.sol';
import {ICLSynchronicityPriceAdapter} from '../interfaces/ICLSynchronicityPriceAdapter.sol';

/**
 * @title CLSynchronicityPriceAdapter
 * @author BGD Labs
 * @notice Price adapter to calculate price of (Asset / Base) pair by using
 * @notice Chainlink Data Feeds for (Asset / Peg) and (Base / Peg) pairs.
 */
contract CLSynchronicityPriceAdapter is ICLSynchronicityPriceAdapter {
  /**
   * @notice Price feed for (Base / Peg) pair
   */
  IChainlinkAggregator public immutable BASE_TO_PEG;

  /**
   * @notice Price feed for (Asset / Peg) pair
   */
  IChainlinkAggregator public immutable ASSET_TO_PEG;

  /**
   * @notice Number of decimals in the output of this price adapter
   */
  uint8 public immutable DECIMALS;

  /**
   * @notice First multiplier used in formula for calculating price to
   * @notice achive desired number of resulting decimals.
   */
  int256 public immutable DECIMALS_MULTIPLIER_1;

  /**
   * @notice Second multiplier used in formula for calculating price to
   * @notice achive desired number of resulting decimals.
   */
  int256 public immutable DECIMALS_MULTIPLIER_2;

  /**
   * @notice Maximum number of resulting and feed decimals
   */
  uint8 public constant MAX_DECIMALS = 18;

  constructor(
    address baseToPegAggregatorAddress,
    address assetToPegAggregatorAddress,
    uint8 decimals
  ) {
    BASE_TO_PEG = IChainlinkAggregator(baseToPegAggregatorAddress);
    ASSET_TO_PEG = IChainlinkAggregator(assetToPegAggregatorAddress);

    if (decimals > MAX_DECIMALS) revert DecimalsAboveLimit();
    if (BASE_TO_PEG.decimals() > MAX_DECIMALS) revert DecimalsAboveLimit();
    if (ASSET_TO_PEG.decimals() > MAX_DECIMALS) revert DecimalsAboveLimit();

    DECIMALS = decimals;

    DECIMALS_MULTIPLIER_1 = int256(10 ** (decimals + BASE_TO_PEG.decimals()));
    DECIMALS_MULTIPLIER_2 = int256(10 ** ASSET_TO_PEG.decimals());
  }

  function latestAnswer() external view override returns (int256) {
    int256 assetToPegPrice = ASSET_TO_PEG.latestAnswer();
    int256 baseToPegPrice = BASE_TO_PEG.latestAnswer();

    return
      (assetToPegPrice * DECIMALS_MULTIPLIER_1) /
      (baseToPegPrice * DECIMALS_MULTIPLIER_2);
  }
}
