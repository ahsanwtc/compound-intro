const DeFiProject = artifacts.require('DeFiProject');

module.exports = function(_deployer, _network) {
  console.log('network is', _network);
  let comtrollerAddress, priceOracleProxy;
  if (_network === 'rinkeby' || _network === 'rinkeby-fork') {
    comtrollerAddress = '0x2eaa9d77ae4d8f9cdd9faacd44016e746485bddb';
    priceOracleProxy = '0x5722A3F60fa4F0EC5120DCD6C386289A4758D1b2';
  }

  _deployer.deploy(DeFiProject, comtrollerAddress, priceOracleProxy);
  
};
