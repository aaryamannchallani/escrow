const Escrow = artifacts.require("Escrow");

module.exports = function (deployer, network, accounts) {
  const agent = accounts[0];
  const buyer = accounts[1];
  const seller = accounts[2];
  deployer.deploy(Escrow, buyer, seller, {from: agent});
};
