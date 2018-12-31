pragma solidity ^0.5.0;

import  "./home-lib.sol";

contract Home is Home_base {

  

  mapping(address => Vote) public votes;
  address[] public votes;
  uint voteid = 0;

  mapping(address => Member) public member;
  address[] public mem_addr;
  
  bool finalized = false;

  string public name;
  uint public total_val;
  uint public total_shares;

  //assets owned by Home, in shares of itself and Ether
  uint public home_shares;
  uint public home_account;

  
    
  //create contract
  constructor(string memory _name,
	      uint val,
	      uint shares,
	      address founder_addr,
	      Member_Type founder_type,
	      uint8 founder_usage,
	      uint founder_shares) public {
    name = _name;		
    total_val = val;
    total_shares = shares;
    addFoundingMember(founder_addr,
		      founder_type,
		      founder_usage,
		      founder_shares);
  }

  
  function addFoundingMember(address founder_addr,
			     Member_Type founder_type,
			     uint8 founder_usage,
			     uint founder_shares) public {
    require(founder_shares <= total_shares,
	    'Not enough shares available');
    require(founder_usage <= 100,
	    '% usage must be less than 100');
    require(finalized == false,
	    'It is too late to add a founding member');
    
    mem_addr.push(founder_addr);
    member[founder_addr].mem_type = founder_type;
    member[founder_addr].shares = founder_shares;
    member[founder_addr].usage_percent = founder_usage;
    member[founder_addr].account = 0;

    emit newMember(founder_addr, founder_type);

  }

  //will check that all conditions are met before changing finalize state
  function initFinalizeProp() public {

    require(voteTypeExists(Vote_Type.Finalize) == true),
	    'A finalize vote has already been issued');

    require(msg.sender == mem_addr[0],
	    'Only the contract creator can call a finalize vote');

    
    
  }

  function castVote(uint voteID, Vote_Type typeOf) public {
  }

  function castFinalizeVote(uint voteID, Vote_Type typeOf) internal {
  }
  
  //goes through all proposals to see if a proposal of the given type exists
  function propTypeExists(Vote_Type typeOf) internal view returns (bool){

    for(uint8 i = 0; i<vote_addr.length; i++){
      
      if(votes[vote_addr[i]].typeOf == typeOf && )

	return true;
    }

    return false;
  }


}
