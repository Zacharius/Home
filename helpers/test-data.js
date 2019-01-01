const Home = artifacts.require('Home');
const Helper = require('./test-helper');
const Constants = require('../helpers/constants');


async function initializeHome(){
    var init_val = web3.utils.toWei('1', 'ether');
    var init_shares = web3.utils.toWei('1', 'ether');
    var home_name = 'test home';

    var founder_type = Constants.Member_Type.Custodian;
    var founder_usage = 10;
    var founder_shares = web3.utils.toWei('.5', 'ether');

    return await Home.new(home_name,
				init_val,
				init_shares,
				founder_type,
				founder_usage,
				founder_shares);
}

async function addFoundingMember(home, address) {
    let founding_member = address;
    let founder_type = Constants.Member_Type.Inhabitant;
    let founder_usage = 10;
    let founder_shares = web3.utils.toWei('1', 'finney');

    await home.addFoundingMember(founding_member,
				founder_type,
				founder_usage,
				founder_shares);
}


module.exports = {
    initializeHome,
    addFoundingMember
};

