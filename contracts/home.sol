pragma solidity ^0.5.0;

import  "./home_base.sol";

contract Home is Home_base {

  

  mapping(uint => Proposal) public proposals;
  uint public propID = 0;

  mapping(address => Member) public member;
  address[] public mem_addr;
  
  bool public confirmed = false;

  string public name;
  uint public total_val;

  //assets owned by Home, in shares of itself and Ether
  uint public home_shares;
  uint public home_account;

  modifier isMember {
    bool _isMember = false;
    
    for(uint i=0; i<mem_addr.length; i++){
      if(mem_addr[i] == msg.sender){
	_isMember = true;
	break;
      }
    }

    require(_isMember,
	    'only members can call this function');
    _;
  }

  modifier isConfirmed {
    require(confirmed,
	    'contract must be confirmed before action can be taken');
    _;
  }

    
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
    require(confirmed == false,
	    'It is too late to add a founding member');
    
    mem_addr.push(founder_addr);
    member[founder_addr].mem_type = founder_type;
    member[founder_addr].shares = founder_shares;
    member[founder_addr].usage_percent = founder_usage;
    member[founder_addr].account = 0;
    emit newMember(founder_addr, founder_type);

    home_shares -= founder_shares;


  }

  //creates new share offer contract
  function offerShares(uint amount) isMember public {
  }

  //will check that all conditions are met before changing finalize state
  function initConfirmationProp() public {

    require(propTypeExists(Proposal_Type.Confirmation) == false,
	    'A finalize vote has already been issued');
    require(msg.sender == mem_addr[0],
	    'Only the contract creator can call a finalize vote');

    uint id = addProposal(Proposal_Type.Confirmation);

    //it is assumed that the original founder is in favor of approval
    castVote(id, Vote_Type.For);
  }

  function castVote(uint id, Vote_Type typeOf) isMember public {
 
    require(proposals[id].result == Result.Undecided,
	    'this vote has already been decided');

    Proposal_Type propType = proposals[id].typeOf;

    if(propType == Proposal_Type.Confirmation){
      castConfirmationVote(msg.sender, id, typeOf);
    }

  }
  
  function castConfirmationVote(address addr, uint id, Vote_Type typeOf) internal {
    
    Vote memory vote;
    vote.member = addr;
    vote.typeOf = typeOf;
    proposals[id].votes.push(vote);

    emit voteCast(typeOf, id);

    checkConfirmationProp(id);
  }

  function checkConfirmationProp(uint id) internal {
    Proposal memory prop = proposals[id];

    Vote[] memory votes = prop.votes;

    uint total_members = mem_addr.length;
    uint pro = 0;
    
    for(uint i=0; i<votes.length; i++){
      if(votes[i].typeOf == Vote_Type.For) {
	pro++;
      }
    } 
    

    if((pro/total_members) * 100 >= APPROVAL_PROP_THRESHOLD) {
      prop.result = Result.Affirmed;
      confirmed = true;
      emit propFinished(propID, prop.typeOf, prop.result);
      emit homeFinalized();

      } 
  }
  
  //goes through all proposals to see if a proposal of the given type exists
  function propTypeExists(Proposal_Type typeOf) internal view returns (bool){

    for(uint8 i = 0; i<propID; i++){
      if(proposals[i].typeOf == typeOf  &&
	 proposals[i].result== Result.Undecided )
	return true;
    }

    return false;
  }

  function addProposal(Proposal_Type typeOf) internal returns(uint) {
    proposals[propID].typeOf = typeOf;
    emit newProp(typeOf, propID);
    return propID++;
  }


  //return current share price, with discount added if applicable too member
  function calcSharePrice(address member) isConfirmed public returns(uint) {}

  //create offer contract, subtract amount from creator's shares
  function offerShares(uint amount) isMember, isConfirmed public {}


  
}
