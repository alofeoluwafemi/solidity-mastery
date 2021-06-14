### Overview Compound Protocol

- Problem we are solving (Currency Inflation)
- Website
    - Home
    - Market
    - CTokens
        - Collateral
        - Exchange Rate
        - Example
- Step by step process (Pseudo code)

Let’s install and initialize Ganache CLI.

```
npm i -g ganache-cli
```

Run this command in a second command line window
```
ganache-cli \
  -f https://mainnet.infura.io/v3/05c12b07721045d2824c506f3aef90c2 \
    -m "cliff ring lab easy fresh vicious cattle then weather dash derive lamp" \
  -i 1 \
  -u 0x9759A6Ac90977b93B58547b4A71c78317f391A28
```

`-f`

Forks the Main Ethereum network to your local machine for development and testing.

`-m`

Runs Ganache with an Ethereum key set based on the mnemonic passed.
The first 10 addresses have 100 test ETH in their balance on the local test net every time you boot Ganache.
Do not use this mnemonic anywhere other than your localhost test net.

`-i`

Sets an explicit network ID to avoid confusion and errors.

`-u`

Unlocks an address so you can write to your localhost test blockchain without knowing that address’s private key.
We are unlocking the above address so we can mint our own test DAI on our localhost test net (more on this later).

```
Available Accounts
==================
(0) 0xe84b6Dc1B28dce622D704B0479878896b6943267 (100 ETH)
(1) 0x8f40D3Ecd076a66Ce826353736FE32DDbAdEAe50 (100 ETH)
(2) 0xC74Fdb066D3363dD99bC4f7dE1DeFc04c4cADCDf (100 ETH)
(3) 0x4226a18dFFB081516b74CEb6fE1a7f2904E773EC (100 ETH)
(4) 0xaeaf5b6D52643a8Eebb71439c6872e7b1fDB5983 (100 ETH)
(5) 0xc1Cd134d5e093631598832506DB7d5C27e21cb5A (100 ETH)
(6) 0x45e86eF69622f72B43Efcfd682A915A397c8311d (100 ETH)
(7) 0x835d791C343EaBc3eE900E291209ad1AE35e6938 (100 ETH)
(8) 0x4501f2bdD5f3FC1D59181A159a2b39fd1ad09449 (100 ETH)
(9) 0x7f036d6107cfaC1c2F75121ca0f8D319384d4Ab6 (100 ETH)

Private Keys
==================
(0) 0xc8c49b67b4878582a6ff17f6f86d83f1c8c3f0778ad51041c2d3b9360bec4772
(1) 0xf40ae87d6c0f03a4b791ea7397ff76d76e3a1ed89892bb711d59b26654048df2
(2) 0xb4b14ca1e78f3014f58a1accb9c1d79e7c5f6337dfd0a0beffdbf5ac71c3f327
(3) 0xeecd8f2168b0e606945d1d9322402665f191baff99f00ead79941f8fa4a1f7a0
(4) 0xd8e2c7240cdd97a22df93444ccfc2fd8a6f873ef2af1ba65ccbb8e6177cd7f37
(5) 0x732d54f4a662edb0420941f7c6f03f1a79df8aae61f5d67d7795b915607eaf9d
(6) 0x43e38fe4e2884fd4c7fe365bdeb85dddec2b43923dfd01e5467b3147125fd12a
(7) 0x613cbfa27c0cda6ed392c0c798bad4918a3c9df8fbaf114055b68bc8bca695f5
(8) 0x241b3ae50594991e6f9302e4cf977c4aa1ac2f3b983e337a38e2b0738ab72bc2
(9) 0x9029cdadbe6a67f81fd33262572464822a56de573d1226476ef54fd1ee899a12
```

### Seed DAI Token

- Run `scripts/dai.js` script
