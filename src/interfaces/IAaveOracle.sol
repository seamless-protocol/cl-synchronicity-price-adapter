// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IAaveOracle {
  
  /// @notice External function called by the Aave governance to set or replace sources of assets
  /// @param assets The addresses of the assets
  /// @param sources The address of the source of each asset
  function setAssetSources(address[] calldata assets, address[] calldata sources) external;

  function getAssetPrice(address asset) external view returns (uint256);

  function getSourceOfAsset(address asset) external view returns (address);
}
