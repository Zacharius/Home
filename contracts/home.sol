pragma solidity ^0.5.0;

import  "./home-lib.sol";

contract Home is Home_base {

  

  mapping(uint => Proposal) public proposal;
  uint public propID = 0;

  mapping(address => Member) public member;
  address[] public mem_addr;
  
  bool approved = false;

  string public name;
  uint public total_val;

  //assets owned by Home, in shares of itself and Ether
  uint public home_shares;
  uint public home_account;

  
    
  //create contract
  constructor(string memory _name,
	      uint val,
	      Member_Type founder_type,
	      uint8 founder_usage,
	      uint founder_shares) public {
    name = _name;		
    total_val = val;
    home_shares = TOTAL_SHARES;//all shares are initially owned by Home
    
    addFoundingMember(msg.sender,
		      founder_type,
		      founder_usage,
		      founder_shares);
  }

  
  function addFoundingMember(address founder_addr,
			     Member_Type founder_type,
			     uint8 founder_usage,
			     uint founder_shares) public {
    require(founder_shares <= home_shares,
	    'Not enough shares available');
    require(founder_usage <= 100,
	    '% usage must be less than 100');
    require(approved == false,
	    'It is too late to add a founding member');
    
    mem_addr.push(founder_addr);
    member[founder_addr].mem_type = founder_type;
    member[founder_addr].shares = founder_shares;
    member[founder_addr].usage_percent = founder_usage;
    member[founder_addr].account = 0;
    emit newMember(founder_addr, founder_type);

    home_shares -= founder_shares;


  }

  //will check that all conditions are met before changing finalize state
  function initFinalizeProp() public {

    require(propTypeExists(Proposal_Type.Finalize) == true,
	    'A finalize vote has already been issued');

    require(msg.sender == mem_addr[0],
	    'Only the contract creator can call a finalize vote');

    
    
  }

  function castVote(uint voteID, Vote_Type typeOf) public {
  }

  function castFinalizeVote(uint voteID, Vote_Type typeOf) internal {
  }
  
  //goes through all proposals to see if a proposal of the given type exists
  function propTypeExists(Proposal_Type typeOf) internal view returns (bool){

    for(uint8 i = 0; i<propID; i++){
      
      if(proposal[i].typeOf == typeOf  )

	return true;
    }

    return false;
  }


}
