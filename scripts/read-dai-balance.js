const DeFiProject = artifacts.require('DeFiProject.sol');

const daiAddress = '0x5592ec0cfb4dbc12d3ab100b257153436a1f0fea';
const ERC20ABI = [  
  {
    "constant": true,
    "inputs": [
      {
        "name": "_owner",
        "type": "address"
      }
    ],
    "name": "balanceOf",
    "outputs": [
      {
        "name": "balance",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },  
];

module.exports = async done => {
  const Dai = new web3.eth.Contract(ERC20ABI, daiAddress);
  const myDeFiProject = await DeFiProject.deployed();
  const balance = await Dai.methods.balanceOf(myDeFiProject.address).call();
  console.log(`Dai Balance: ${web3.utils.fromWei(balance)}`);
  done();
}