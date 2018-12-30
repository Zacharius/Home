var Home = artifacts.require('Home');

contract('home',async function(accounts)  {

    const Member_Type = {
	Custodian: 0,
	Inhabitant: 1,
	Member: 2,
	Shareholder: 3
    };

    var inst;

    
    beforeEach( async function() {
	var init_val = web3.utils.toWei('1', 'ether');
	var init_shares = web3.utils.toWei('1', 'ether');
	var home_name = 'test home';

	var founder = accounts[0];
	var founder_type = Member_Type.Custodian;
	var founder_usage = 10;
	var founder_shares = web3.utils.toWei('.9', 'ether');

	inst = await Home.new(home_name,
				  init_val,
				  init_shares,
				  founder,
				  founder_type,
				  founder_usage,
				  founder_shares);
				  
    });

    it('contract is created', async function() {
	   
	if(inst == undefined){
	    assert.ok(-1);
	}else{
	    assert.ok(1);
	}
    });

    it('Add Founding Member', async function() {
	let founding_member = accounts[1];
	let founder_type = Member_Type.Inhabitant;
	let founder_usage = 50;
	let founder_shares = web3.utils.toWei('1', 'finney');

	await inst.addFoundingMember(founding_member,
				     founder_type,
				     founder_usage,
				     founder_shares);

	let mem = await inst.member.call(founding_member);
	
	assert.equal(mem.shares.toNumber(), founder_shares);
	assert.equal(mem.usage_percent.toNumber(), founder_usage);
	assert.equal(mem.mem_type.toNumber(), founder_type);
    });
});
