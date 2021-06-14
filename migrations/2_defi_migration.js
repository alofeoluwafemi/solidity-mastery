const DeFi = artifacts.require("DeFi");

module.exports = function (deployer) {
  deployer.deploy(DeFi);
};
