const express = require('express');
const bodyParser = require('body-parser');
const Web3 = require('web3');


var provider = new Web3.providers.HttpProvider("http://127.0.0.1:8545");
const contractJson = require("./build/contracts/DeFi.json");
const contract = require("@truffle/contract");
const DeFiContract = contract(contractJson);
const primaryAccount = "0xe84b6Dc1B28dce622D704B0479878896b6943267"
DeFiContract.setProvider(provider);
let contractAddress;

const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.route('/ping').get((req, res) => {
  return res.send("pong...");
});

app.route('/defi/add/:username').get(async (req, res) => {

  if(!req.params.username) {
    return res.sendStatus(400);
  }

   const defi = await DeFiContract.new({from: primaryAccount});

   contractAddress = defi.address;

   let data = [req.params.username,0,0,(new Date()).getTime(),true];

   defi.newUser(data,{from: primaryAccount})
    .then((userBal) => {
      return defi.users.call(req.params.username);
    })
    .then((profile) => {
      return res.send(profile);
    })
    .catch((error) => {
      console.error('error:', error);
      return res.sendStatus(400);
    });
});

app.route('/defi/balance/:username').get(async (req, res) => {

  if(!req.params.username) {
    return res.sendStatus(400);
  }

   const defi = await DeFiContract.at(contractAddress);

   defi.diaBalances.call(req.params.username)
    .then((userBal) => {
      return res.send(userBal.toString());
    })
    .catch((error) => {
      console.error('error:', error);
      return res.sendStatus(400);
    });
});

//Add more routes here to perform further actions here

app.listen(port, () => console.log(`API server running on port ${port}`));
