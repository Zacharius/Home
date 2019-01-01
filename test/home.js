const Constants = require('../helpers/constants');
const Helper = require('../helpers/test-data');

contract('home',async function(accounts)  {


    let home;

    describe('home creation', () => {

	it('should allow contract creation', async function() {
	    home = await Helper.initializeHome();
	    
	    assert.exists(home);
	});

	it('should allow the addition of founding members', async function() {
	    await Helper.addFoundingMember(home, accounts[1]);
	    member = await home.member.call(accounts[1]);  
	    
	    assert.exists(member);
	});

    });
    
	    
});
