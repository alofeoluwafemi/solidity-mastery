const express = require('express');
const bodyParser = require('body-parser');
const Web3 = require('web3');

require('dotenv').config();

const HDWalletProvider = require("truffle-hdwallet-provider");
const mnemonic = process.env.WALLET_MNEMONIC;
const walletPrivateKey = process.env.WALLET_PRIVATE_KEY;
const web3 = new Web3('https://mainnet.infura.io/v3/05c12b07721045d2824c506f3aef90c2');

web3.eth.accounts.wallet.add(walletPrivateKey);

const vendor = web3.eth.accounts.wallet[0].address;

const DefiJson = require('./build/contracts/DeFi.json');
const DefiAddrress = "0xe0ef0b52fbc51a706c293b4d4ccba318bfa639de";
const DefiContract = new web3.eth.Contract(DefiJson.abi, DefiAddrress);
const daiMcdJoin = '0x9759A6Ac90977b93B58547b4A71c78317f391A28';

const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.route('/ping').get((req, res) => {
  return res.send("pong");
});

app.route('/protocol-balance/eth/').get((req, res) => {
  cEthContract.methods.balanceOfUnderlying(myWalletAddress).call()
    .then((result) => {
      const balanceOfUnderlying = web3.utils.fromWei(result);
      return res.send(balanceOfUnderlying);
    }).catch((error) => {
      console.error('[protocol-balance] error:', error);
      return res.sendStatus(400);
    });
});

 
app.listen(port, () => console.log(`API server running on port ${port}`));
