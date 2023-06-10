// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {IChainlinkAggregator} from '../interfaces/IChainlinkAggregator.sol';
import {ICLSynchronicityPriceAdapter} from '../interfaces/ICLSynchronicityPriceAdapter.sol';
import {IStETH} from '../interfaces/IStETH.sol';

/**
 * @title wstETHtoETHSynchronicityPriceAdapter
 * @author BGD Labs
 * @notice Price adapter to calculate price of (wstETH / ETH) pair by using (wstETH / stETH) ratio.
 */
contract wstETHtoETHSynchronicityPriceAdapter is ICLSynchronicityPriceAdapter {
  /**
   * @notice stETH token contract to get ratio
   */
  IStETH public immutable STETH;

  /**
   * @notice Number of decimals for wstETH / stETH ratio
   */
  uint8 public constant RATIO_DECIMALS = 18;

  /**
   * @notice Number of decimals in the output of this price adapter
   */
  uint8 public constant DECIMALS = 18;

  string private _description;

  /**
   * @param stEthAddress the address of the stETH contract
   * @param pairName name identifier
   */
  constructor(address stEthAddress, string memory pairName) {
    STETH = IStETH(stEthAddress);

    _description = pairName;
  }

  /// @inheritdoc ICLSynchronicityPriceAdapter
  function description() external view returns (string memory) {
    return _description;
  }

  /// @inheritdoc ICLSynchronicityPriceAdapter
  function decimals() external pure returns (uint8) {
    return DECIMALS;
  }

  /// @inheritdoc ICLSynchronicityPriceAdapter
  function latestAnswer() public view virtual override returns (int256) {
    int256 ratio = int256(STETH.getPooledEthByShares(10 ** RATIO_DECIMALS));

    if (ratio <= 0) {
      return 0;
    }

    return (1 ether * ratio) / int256(10 ** RATIO_DECIMALS);
  }
}
