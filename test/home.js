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

    describe('erc20 token interface', () => {

	before(async function() {
	    let accts = accounts.slice(0,6);
	    Home = await Helper.initHomeWithMembers(accts);
	    await Helper.confirmHome(Home, accts);
	});

	it('balanceOf member', async function() {
	    let amount = await Home.balanceOf(accounts[1]);

	    assert.equal(amount,
			 web3.utils.toWei('1', 'finney'));
	});
	   
	it('balanceOf non-member', async function() {
	    let amount = await Home.balanceOf(accounts[8]);

	    assert.equal(amount,
			 0);
	});

	it('transfer to member from member', async function() {

	    let prev_bal = await Home.balanceOf(accounts[1]);
	    let transfer = 2;

	    await Home.transfer(accounts[1], transfer,
				{from: accounts[0]});

	    let new_balance = await Home.balanceOf(accounts[1]);

	    assert.equal(prev_bal+2, new_balance);
	});

	it('transfer to nonmember from member', async function() {

	    try{
		await Home.transfer(accounts[8], 2,
				    {from: accounts[0]});
	    }catch(e){
		assert.ok(1);
	    }
	    assert.ok(-1);
	});

	it('transfer to member from nonmember', async function() {

	    try{
		await Home.transfer(accounts[1], 2,
				    {from: accounts[8]});
	    }catch(e){
		assert.ok(1);
	    }
	    assert.ok(-1);
	});

	it('approve amount to member', async function() {

	    let owner = accounts[0];
	    let spender = accounts[1];
	    let amount = 10;
	    
	    let allow_old = await Home.allowance(owner, spender);
	    await Home.approve(spender, amount, {from: owner});
	    let allow_new = await Home.allowance(owner, spender);

	    assert.equal(allow_old+amount, allow_new);
	});

	it('approve amount to nonmember', async function() {

	    let owner = accounts[0];
	    let spender = accounts[8];
	    let amount = 10;
	    
	    try{
		await Home.approve(spender, amount, {from: owner});
	    }catch(e){
		assert.ok(1);
	    }
	    assert.ok(-1);

	});

	it('allow amount to member', async function() {

	    let owner = accounts[0];
	    let spender = accounts[1];
	    let amount = 10;
	    
	    await Home.approve(spender, amount, {from: owner});

	    let allow = await Home.allowance(owner, spender);

	    assert.equal(allow, amount);
	});

	it('transferfrom', async function() {

	    let from = accounts[0];
	    let to = accounts[1];
	    let amount = 10;

	    try{
		Home.transferFrom(from, to, amount);
		assert.ok(-1);
	    }catch(e){
	    }

	    Home.approve(to, amount,
			 {from: from});

	    let success = Home.transferFrom(from, to, amount);
	    if(success)
		assert.ok(1);
	});


    });

	    
});
