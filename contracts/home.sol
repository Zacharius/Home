pragma solidity ^0.5.0;

import  "./home_base.sol";
import "./confirmation_prop.sol";

contract Home is Home_base {

  


  mapping(address => Member) public member;
  address[] public mem_addr;
  
  bool public confirmed = false;

  string public name;
  uint public total_val;

  //assets owned by Home, in shares of itself and Ether
  uint public home_shares;
  uint public home_account;

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

  //will check that all conditions are met before changing finalize state
  function initConfirmationProp() public {

    //    require(propTypeExists(Proposal_Type.Confirmation) == false,
    //	    'A finalize vote has already been issued');
    require(msg.sender == mem_addr[0],
	    'Only the contract creator can call a finalize vote');

    //uint id = addProposal(Proposal_Type.Confirmation);

    //it is assumed that the original founder is in favor of approval
    //castVote(id, Vote_Type.For);
  }

  //return current share price, with discount added if applicable too member
  function calcSharePrice(address _member) isConfirmed public returns(uint) {}

  //create offer contract, subtract amount from creator's shares
  function offerShares(uint _amount)  isConfirmed public {}

  function isMember(address _member) public returns (bool){
    bool _isMember = false;
    
    for(uint i=0; i<mem_addr.length; i++){
      if(mem_addr[i] == _member){
	_isMember = true;
	break;
      }
    }   

    return _isMember;
  }

  function getTotalMembers() public returns (uint){
    return mem_addr.length;
  }
}
