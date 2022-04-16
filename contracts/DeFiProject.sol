// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './CTokenInterface.sol';
import './ComptrollerInterface.sol';
import './PriceOracleInterface.sol';

contract DeFiProject {
  ComptrollerInterface public comptroller;
  PriceOracleInterface public priceOracle;

  constructor(address _comptroller, address _oracle) {
    comptroller = ComptrollerInterface(_comptroller);
    priceOracle = PriceOracleInterface(_oracle);
  }

  function supply(address cTokenAddress, uint underlyingAmount) external {
    CTokenInterface cToken = CTokenInterface(cTokenAddress);
    address underlyingTokenAddress = cToken.underlying();
    IERC20(underlyingTokenAddress).approve(cTokenAddress, underlyingAmount);
    uint result = cToken.mint(underlyingAmount);
    require(result == 0, 'cToken.mint() failed. See Compound ErrorReporter.sol for more details');
  }

  function redeem(address cTokenAddress, uint cTokenAmount) external {
    CTokenInterface cToken = CTokenInterface(cTokenAddress);
    uint result = cToken.redeem(cTokenAmount);
    require(result == 0, 'cToken.redeem() failed. See Compound ErrorReporter.sol for more details');
  }

  function enterMarket(address cTokenAddress) external {
    address[] memory markets = new address[](1);
    markets[0] = cTokenAddress;
    uint[] memory results = comptroller.enterMarkets(markets);
    require(results[0] == 0, 'comptroller.enterMarkets() failed. See Compound ErrorReporter.sol for more details');
  }

  function borrow(address cTokenAddress, uint borrowAmount) external {
    CTokenInterface cToken = CTokenInterface(cTokenAddress);
    uint result = cToken.borrow(borrowAmount);
    require(result == 0, 'cToken.borrow() failed. See Compound ErrorReporter.sol for more details');
  }

  function repayBorrow(address cTokenAddress, uint underlyingAmount) external {
    CTokenInterface cToken = CTokenInterface(cTokenAddress);
    address underlyingTokenAddress = cToken.underlying();
    IERC20(underlyingTokenAddress).approve(cTokenAddress, underlyingAmount);
    uint result = cToken.repayBorrow(underlyingAmount);
    require(result == 0, 'cToken.repayBorrow() failed. See Compound ErrorReporter.sol for more details');
  }

  function getMaxBorrow(address cTokenAddress) external view returns(uint) {
    (uint result, uint liquidity, uint shortfall) = comptroller.getAccountLiquidity(cTokenAddress);
    require(result == 0, 'comptroller.getAccountLiquidity() failed. See Compound ErrorReporter.sol for more details');
    require(liquidity > 0, 'account does not have collateral');
    require(shortfall == 0, 'account under water');
    uint underlyingPrice = priceOracle.getUnderlyingPrice(cTokenAddress);
    return liquidity / underlyingPrice;
  }
}
