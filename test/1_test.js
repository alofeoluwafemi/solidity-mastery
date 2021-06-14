const DeFi = artifacts.require("DeFi");

const DaiAbi = require('../scripts/abis/dai-abi.json');
const DaiAddress = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
const DaiContract = new web3.eth.Contract(DaiAbi, DaiAddress);

contract("DeFi", (accounts) => {
    let defi, contractAddress;

    before(async () => {
      defi = await DeFi.new();
      contractAddress = defi.address;
    });

    const [vendor] = accounts;

    describe("Customer process on defi", async () => {

      it('Add new user successfully', async () => {
        await defi.newUser([
          'DreWhyte',
          0,
          0,
          (new Date()).getTime(),
          true
        ]);

        let user = await defi.users("DreWhyte");

        assert.equal(user.username, 'DreWhyte', "Cannot add new user");
      });

      it('vendor successfully supply Dai liquidity', async () => {
        const amount = web3.utils.toWei("100");
        await DaiContract.methods.approve(contractAddress,amount).send({from: vendor});

        await DaiContract.methods.allowance(vendor,contractAddress).call();
        let success = await defi.addDiaLiquidity("DreWhyte",amount);


        let liquidity = await defi.diaBalances.call("DreWhyte")

        assert.isAtLeast(Number(liquidity), Number(amount) , "Cannot add liquidity");
      });

      it('successfully list sell Dai ads', async () => {
        let b = await defi.sellDiaAds([
          "DreWhyte",
          web3.utils.toWei("50"),
          web3.utils.toWei("500.50"),
          0,
          web3.utils.toWei("1"),
          web3.utils.toWei("50"),
          []
        ],'DreWhyte');

        let userBal = await defi.diaBalances("DreWhyte");

        assert.isAtLeast(Number(userBal), Number(web3.utils.toWei("50")), "Cannot add list ads");
      });

      it('customer successfully reserve buy', async () => {

        await defi.newUser([
          "Ghost",
          0,
          0,
          (new Date()).getTime(),
          true
        ]);

        let successful = await defi.reserveBuy(vendor,'Ghost',web3.utils.toWei("10"));
        let order = await defi.orders.call(0);

        assert.equal(Number(web3.utils.toWei("10")), Number(order.value), "Cannot reserve dai on ads");
      });

      it('vendor successfully approve buy', async () => {

        await defi.approveBuy(0,web3.utils.toWei("5"));

        let newBal = await defi.diaBalances.call("Ghost");
        let order = await defi.orders.call(0);

        assert.equal(0, order.value, "Cannot approve order");
        assert.equal(Number(web3.utils.toWei("5")), Number(newBal), "Cannot approve order");
      });

      it('customer successfully save', async () => {

        await defi.save(web3.utils.toWei("5"),'Ghost');

        let user = await defi.users.call("Ghost");

        assert.equal(web3.utils.toWei("5"), Number(user.underlyingBal), "Cannot stake Dai into compound");
      });


      // it('customer successfully unsave', async () => {
      //
      //   await defi.unsave('Ghost');
      //
      //   let user = await defi.users.call("Ghost");
      //
      //   assert.equal(0, Number(user.underlyingBal), "Cannot stake Dai into compound");
      // });

    });
});
