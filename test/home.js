const Constants = require('../helpers/constants');
const Helper = require('../helpers/test-data');

contract('home',async function(accounts)  {


    let Home;

    describe('home creation', () => {

	it('should allow contract creation', async function() {
	    Home = await Helper.initializeHome();
	    
	    assert.exists(Home);
	});

	it('should allow the addition of founding members', async function() {
	    await Helper.addFoundingMember(Home, accounts[1]);
	    member = await Home.member.call(accounts[1]);  
	    
	    assert.exists(member);
	});

    });

    describe('home approval phase', () => {

	before( async function () {
	    Home = await Helper.initializeHome();
	    await Helper.addFoundingMember(Home, accounts[1]);
	    await Helper.addFoundingMember(Home, accounts[2]);
	    await Helper.addFoundingMember(Home, accounts[3]);
	    await Helper.addFoundingMember(Home, accounts[4]);
	});

	it('shouldnt allow non-original founder to issue approval proposal',
	   async function() {
	       try{
		   await Home.initConfirmationProp({from: accounts[1]});
	       }catch(e){
		   assert.ok(1);
	       }
	       assert.ok(-1);
	   });


	it('should allow original owner to issue approval proposal',
	   async function() {
	       await Home.initConfirmationProp({from: accounts[0]});

	       let prop = await Home.proposals.call(0);
	       assert.exists(prop);
	   });

	it('should allow founding members to vote', async function() {
	    await Home.castVote(0, Constants.Vote_Type.For, {from: accounts[1]});
	    await Home.castVote(0, Constants.Vote_Type.For, {from: accounts[2]});
	    await Home.castVote(0, Constants.Vote_Type.For, {from: accounts[3]});
	    await Home.castVote(0, Constants.Vote_Type.Against, {from: accounts[4]});
	});

	it('should be approved once vote reaches threshold(100%)',
	   async function() {
	       await Home.castVote(0, Constants.Vote_Type.For, {from: accounts[4]});

	       let confirmed = await Home.confirmed.call();
	       assert.ok(confirmed);

	     
	   });
    });

    
	    
});
