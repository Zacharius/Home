const Constants = require('../helpers/constants');
const Helper = require('../helpers/test-data');
const Offer = artifacts.require('Offer');

contract('offer',async function(accounts)  {

    let Home;
    let offer;

    describe('offer contract creation', () => {

	before(async function () {
	    Home = await Helper.initHomeWithMembers(accounts, true);
	});

	let amount;
	let issuer = accounts[1];
	
	it('should allow members to create offers', async function() {
	    amount = web3.utils.toWei('.1', 'finney');

	    let result = await Home.offerShares(amount, {from: issuer});
	    let offerAddr = Helper.extractEventItem(result,
						    'sharesOffered',
						    'offer_contract');
	    offer = await Offer.at(offerAddr);
	});

	it('offers should be member of issuers type', async function() {
	    let issuer = await Home.member.call(accounts[1]);
	    let contract = await Home.member.call(offer.address);
	    assert.equal(contract.mem_type.toNumber(),
			 issuer.mem_type.toNumber());
	});

	it('offers should be allowed to transfer issuers money',
	   async function() {
	       let allowed = await Home.allowance(issuer, offer.address);   
	       assert.equal(allowed, amount);
	   });
    });

});

