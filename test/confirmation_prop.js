const Constants = require('../helpers/constants');
const Helper = require('../helpers/test-data');
const Prop_Contract = artifacts.require('Confirmation_prop');

contract('proposals', async function(accounts)  {

    let Home;
    let Prop;

/*    before(async function () {
	Home = await Helper.initializeHome();
	await Helper.addFoundingMember(Home, accounts[1]);
	await Helper.addFoundingMember(Home, accounts[2]);
	await Helper.addFoundingMember(Home, accounts[3]);
	await Helper.addFoundingMember(Home, accounts[4]);
    });*/

    describe('Home confirmation issuance', () => {
	
	before(async function () {
	    Home = await Helper.initializeHome();
	    await Helper.addFoundingMember(Home, accounts[1]);
	    await Helper.addFoundingMember(Home, accounts[2]);
	    await Helper.addFoundingMember(Home, accounts[3]);
	    await Helper.addFoundingMember(Home, accounts[4]);
	});

	it('shouldnt allow non-original founder to issue approval proposal',
	   async function() {
	       try{
		   await Home.issueProposal(Constants.Confirmation, {from: accounts[1]});
	       }catch(e){
		   assert.ok(1);
	       }
	       assert.ok(-1);
	   });

	it('should allow original owner issue approval proposal',
	   async function() {
	       await Home.issueProposal(Constants.Proposal_Type.Confirmation,
					{from: accounts[0]});  
	       let propAddr = await Home.props.call(0);
	       Prop = await Prop_Contract.at(propAddr);
	       assert.exists(Prop);
	   });

    });

    describe('Voting Phase', () => {

	it('shouldnt allow non members to vote',
	   async function() {
	       try{
		   await Prop.castVote(Constants.Vote_Type.For,
				       {from: accounts[6]});
	       }catch(e){
		   assert.ok(1);
	       }
	       assert.ok(-1);
	   });

	it('should allow members to vote',
	   async function() {
	       await Prop.castVote(Constants.Vote_Type.For,
				   {from: accounts[1]});
	       let vote = await Prop.getVote(accounts[1]);
	       
	       assert.equal(vote,
			    Constants.Vote_Type.For);
	});

	it('should allow members to change vote',
	   async function() {
	       await Prop.castVote(Constants.Vote_Type.Against,
				   {from: accounts[1]});
	       let vote = await Prop.getVote(accounts[1]);

	       assert.equal(vote,
			    Constants.Vote_Type.Against);
	   });

	it('should conclude in the positive once all members have affirmed',
	   async function() {

	       await Prop.castVote(Constants.Vote_Type.For,
				   {from: accounts[0]});
	       await Prop.castVote(Constants.Vote_Type.For,
				   {from: accounts[1]});
	       await Prop.castVote(Constants.Vote_Type.For,
				   {from: accounts[2]});
	       await Prop.castVote(Constants.Vote_Type.For,
				   {from: accounts[3]});
	       await Prop.castVote(Constants.Vote_Type.For,
				   {from: accounts[4]});

	       let result = await Prop.result.call();
	       assert.equal(result,
			    Constants.Result.Affirmed);
	   });


	describe('Mid confirmation changes', () => {
	    before(async function () {
		Home = await Helper.initHomeWithMembers(accounts);
		await Home.issueProposal(Constants.Proposal_Type.Confirmation,
					{from: accounts[0]});  
	       let propAddr = await Home.props.call(0);
	       Prop = await Prop_Contract.at(propAddr);

	    });


	    it('should conclude in the negative if Home contract is changed',
	    async function() {
		await Helper.addFoundingMember(Home, accounts[6]);
		result = await Prop.result.call();
		
		assert.equal(result,
			     Constants.Result.Denied);
	    });

	});

    });

});

	
