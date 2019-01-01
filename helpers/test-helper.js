function web3GetAccounts() {
    return new Promise((resolve, reject) => {
	web3.eth.getAccounts((err, res) => {
	    if(err !== null) return reject(err);
	    return resolve(res);
	});
    });
}

module.exports = {
    web3GetAccounts
};
