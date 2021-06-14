const Web3 = require('web3');
const web3 = new Web3('http://127.0.0.1:8545');

//const cTokenAbi = require('../scripts/abis/ctoken.json');
//const cTokenAddress = "0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643";

const DefiAbi = require('../build/contracts/DeFi.json');
const DefiAddrress = "0xe0ef0b52fbc51a706c293b4d4ccba318bfa639de";
const daiMcdJoin = '0x9759A6Ac90977b93B58547b4A71c78317f391A28';

web3.eth.getAccounts().then((metaMaskAccounts) => {
  accounts = metaMaskAccounts;
  //const cTokenContract = new web3.eth.Contract(cTokenAbi, cTokenAddress);
  const DefiContract = new web3.eth.Contract([
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "string",
          "name": "vendor",
          "type": "string"
        },
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "amount",
          "type": "uint256"
        }
      ],
      "name": "DaiAdded",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "vendor",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "amount",
          "type": "uint256"
        }
      ],
      "name": "LiquidityAdded",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "vendor",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "string",
          "name": "currency",
          "type": "string"
        },
        {
          "indexed": true,
          "internalType": "string",
          "name": "order",
          "type": "string"
        },
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "_amount",
          "type": "uint256"
        }
      ],
      "name": "NewDaiListing",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "string",
          "name": "username",
          "type": "string"
        },
        {
          "indexed": true,
          "internalType": "uint256",
          "name": "registered",
          "type": "uint256"
        }
      ],
      "name": "NewRegistration",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "string",
          "name": "vendor",
          "type": "string"
        },
        {
          "indexed": true,
          "internalType": "string",
          "name": "username",
          "type": "string"
        },
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "amount",
          "type": "uint256"
        }
      ],
      "name": "OrderApproved",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "vendor",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "string",
          "name": "username",
          "type": "string"
        },
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "amount",
          "type": "uint256"
        }
      ],
      "name": "ReserveBuy",
      "type": "event"
    },
    {
      "inputs": [],
      "name": "cTokenAddress",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        }
      ],
      "name": "diaBalances",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "exRateMantissa",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "minimumDaiDeposit",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "name": "orders",
      "outputs": [
        {
          "internalType": "string",
          "name": "username",
          "type": "string"
        },
        {
          "internalType": "uint256",
          "name": "value",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "opened",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "name": "sellDaiListings",
      "outputs": [
        {
          "internalType": "string",
          "name": "username",
          "type": "string"
        },
        {
          "internalType": "uint256",
          "name": "value",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "buyRateMantissa",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "sellRateMantissa",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "minimumLimitMantissa",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "maximumLimitMantissa",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "name": "sellDaiVendors",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "totalDaiSupplied",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "totalDiaLiquidity",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "underlyingAddress",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        }
      ],
      "name": "users",
      "outputs": [
        {
          "internalType": "string",
          "name": "username",
          "type": "string"
        },
        {
          "internalType": "uint256",
          "name": "underlyingBal",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "cTokenBal",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "registered",
          "type": "uint256"
        },
        {
          "internalType": "bool",
          "name": "isUser",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "components": [
            {
              "internalType": "string",
              "name": "username",
              "type": "string"
            },
            {
              "internalType": "uint256",
              "name": "underlyingBal",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "cTokenBal",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "registered",
              "type": "uint256"
            },
            {
              "internalType": "bool",
              "name": "isUser",
              "type": "bool"
            }
          ],
          "internalType": "struct DeFi.user",
          "name": "_user",
          "type": "tuple"
        }
      ],
      "name": "newUser",
      "outputs": [
        {
          "components": [
            {
              "internalType": "string",
              "name": "username",
              "type": "string"
            },
            {
              "internalType": "uint256",
              "name": "underlyingBal",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "cTokenBal",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "registered",
              "type": "uint256"
            },
            {
              "internalType": "bool",
              "name": "isUser",
              "type": "bool"
            }
          ],
          "internalType": "struct DeFi.user",
          "name": "_account",
          "type": "tuple"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "components": [
            {
              "internalType": "string",
              "name": "username",
              "type": "string"
            },
            {
              "internalType": "uint256",
              "name": "value",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "buyRateMantissa",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "sellRateMantissa",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "minimumLimitMantissa",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "maximumLimitMantissa",
              "type": "uint256"
            },
            {
              "internalType": "uint256[]",
              "name": "openOrders",
              "type": "uint256[]"
            }
          ],
          "internalType": "struct DeFi.listing",
          "name": "_listing",
          "type": "tuple"
        },
        {
          "internalType": "string",
          "name": "_username",
          "type": "string"
        }
      ],
      "name": "sellDiaAds",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "_username",
          "type": "string"
        },
        {
          "internalType": "uint256",
          "name": "_amount",
          "type": "uint256"
        }
      ],
      "name": "addDiaLiquidity",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_adOwner",
          "type": "address"
        },
        {
          "internalType": "string",
          "name": "_username",
          "type": "string"
        },
        {
          "internalType": "uint256",
          "name": "_amount",
          "type": "uint256"
        }
      ],
      "name": "reserveBuy",
      "outputs": [
        {
          "internalType": "bool",
          "name": "_status",
          "type": "bool"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_orderIndex",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "_amount",
          "type": "uint256"
        }
      ],
      "name": "approveBuy",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_amount",
          "type": "uint256"
        },
        {
          "internalType": "string",
          "name": "_username",
          "type": "string"
        }
      ],
      "name": "save",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "_exRate",
          "type": "uint256"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "_username",
          "type": "string"
        }
      ],
      "name": "unsave",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "_exRate",
          "type": "uint256"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "lookUpExRate",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "rate",
          "type": "uint256"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "_username",
          "type": "string"
        }
      ],
      "name": "savingsInfo",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "_redeemableBal",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "_rate",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "_ctokenBal",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ], DefiAddrress);


  // return DefiContract.methods.lookUpExRate()
  //     .send({
  //       from: daiMcdJoin,
  //       gasPrice: web3.utils.toHex(0)
  //     });
  // }).then((result) => {
  //   console.log('Calling rate...');
  //   return DefiContract.methods.exRateMantissa().call();
  // }).then((rate) => {
  //   console.log('success: ', rate);
  // }).catch((err) => {
  //   console.error(err);
  // });

  return DefiContract.methods.lookUpExRate().send({
    from: accounts[0],
    gasPrice: web3.utils.toHex(0)
    })
  .then((response) => {
    return DefiContract.methods.exRateMantissa().call()
  })
  .then((response) => {
    console.log('Rate Mantissa: ', response);
  })
  .catch((error) => {
    console.log('error: ', error);
  })

})
