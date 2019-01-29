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

	    
});
