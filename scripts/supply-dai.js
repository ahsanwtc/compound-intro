const DeFiProject = artifacts.require('DeFiProject.sol');

const cDaiAddress = '0x6d7f0754ffeb405d23c51ce938289d4835be3b14';

module.exports = async done => {
  const defiProject = await DeFiProject.deployed();
  await defiProject.supply(cDaiAddress, web3.utils.toWei('10'));
  done();
};