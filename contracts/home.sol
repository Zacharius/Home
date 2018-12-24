pragma solidity ^0.5.0;


contract Home {
  enum Member_Type { 
    Custodian,
    Inhabitant,
    Member,
    Shareholder }

  struct Member {
    uint shares;
    Member_Type mem_type;
    uint8 usage_percent;//percent of Home Member is using
    uint account;//Ether Home is holding for Member
  }

  mapping(address => Member) public member;
  address[] public mem_addr;
  
  bool finalized = false;

  string public name;
  uint public total_val;
  uint public total_shares;

  //assets owned by Home, in shares of itself and Ether
  uint public home_shares;
  uint public home_account;

  
  event newMember(address member, uint8 Member_Type);
  event homeFinalized(address homeAddress);
  
  //create contract
  constructor(string memory _name,
	      uint val,
	      uint shares,
	      address founder_addr,
	      uint8 founder_type,
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
			     uint8 founder_type,
			     uint8 founder_usage,
			     uint founder_shares) public {
    require(founder_shares <= total_shares,
	    'Not enough shares available');
    require(founder_usage <= 100,
	    '% usage must be less than 100');
    require(finalized == false,
	    'It is too late to add a founding member');
    
    mem_addr.push(founder_addr);
    member[founder_addr].mem_type = Member_Type(founder_type);
    member[founder_addr].shares = founder_shares;
    member[founder_addr].usage_percent = founder_usage;
    member[founder_addr].account = 0;

    emit newMember(founder_addr, founder_type);

  }

  //will check that all conditions are met before changing finalize state
  function finalizeContract() public {
  }

}
