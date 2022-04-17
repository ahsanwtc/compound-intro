const DeFiProject = artifacts.require('DeFiProject.sol');

const cBatAddress = '0xebf1a11532b93a529b5bc942b4baa98647913002';

module.exports = async done => {
  const myDeFiProject = await DeFiProject.deployed();
  await myDeFiProject.borrow(cBatAddress, web3.utils.toWei('10'));
  done();
}