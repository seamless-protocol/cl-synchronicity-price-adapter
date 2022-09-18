// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MockAggregator {
  int256 private _latestAnswer;
  uint8 private _decimals;

  constructor(
      int256 _initialAnswer,
      uint8 _initialDecimals
  ) {
    _latestAnswer = _initialAnswer;
    _decimals = _initialDecimals;
  }

  function latestAnswer() external view returns (int256) {
    return _latestAnswer;
  }

  function decimals() external view returns (uint8) {
    return _decimals;
  }

}
