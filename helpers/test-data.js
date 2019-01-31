const Home = artifacts.require('Home');
const Confirmation_prop = artifacts.require('Confirmation_prop');
const Helper = require('./test-helper');
const Constants = require('../helpers/constants');


async function initializeHome(){
    var init_val = web3.utils.toWei('1', 'ether');
    var home_name = 'test home';

    var founder_usage = 10;
    var founder_shares = web3.utils.toWei('.5', 'ether');

    return await Home.new(home_name,
			  init_val,
			  founder_usage,
			  founder_shares);
}

async function initHomeWithMembers(addresses, confirmed) {
    let home = await initializeHome();
    members = addresses.slice(1);
    members.forEach(async function(addr) {
	await addFoundingMember(home, addr);
    });

    if(confirmed){
	await confirmHome(home, addresses);
    }

    return home;
}

async function confirmHome(home, members){
    await home.issueProposal(Constants.Proposal_Type.Confirmation,
		       {from: members[0]});
    let propAddr = await home.props.call(0);
    let prop = await Confirmation_prop.at(propAddr);
    members.forEach(async function(member) {
	await prop.castVote(Constants.Vote_Type.For,
		      {from: member});
    });
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
    addFoundingMember,
    initHomeWithMembers,
    confirmHome
};

