var Migrations = artifacts.require("./Migrations.sol");
var Home = artifacts.require('Home');

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
