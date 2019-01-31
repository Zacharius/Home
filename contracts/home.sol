pragma solidity ^0.5.0;

import  "./home_base.sol";
import "./proposal.sol";
import "./confirmation_prop.sol";
import "./erc20.sol";


contract Home is Home_base, ERC20Interface {

  mapping(address => Member) public member;
  address[] public mem_addr;

  //funds approved to be transfered from one party to another
  mapping(address => mapping(address => uint)) public allowed;
  
  bool public confirmed = false;

  string public name;
  uint public total_val;

  Proposal[] public props;

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
	      uint8 founder_usage,
	      uint founder_shares) public {
    name = _name;		
    total_val = val;
    home_shares = TOTAL_SHARES;//all shares are initially owned by Home
    
    addFoundingMember(msg.sender,
		      Member_Type.Custodian, //creator will be custodian by default
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
    require(!isMember(founder_addr),
	    'Is alraedy a member');
    
    mem_addr.push(founder_addr);
    member[founder_addr].mem_type = founder_type;
    member[founder_addr].shares = founder_shares;
    member[founder_addr].usage_percent = founder_usage;
    member[founder_addr].account = 0;
    emit newMember(founder_addr, founder_type);

    home_shares -= founder_shares;
  }

  
  function issueProposal(Proposal_Type typeOf) public {
    Proposal prop;
    bool issued = false;
    
    if(typeOf == Proposal_Type.Confirmation){
      require(msg.sender == mem_addr[0],
	      'only contract creator can call finalize vote');
      issued = true;
      prop = new Confirmation_prop();

    }

    if(issued){
      props.push(prop);
      emit newProp(typeOf, address(prop));
    }
  }

  function implementPropResults() public {
    Proposal prop = Proposal(msg.sender);
    require(isProp(prop),
	    'Not a valid proposal');
    require(prop.result() != Result.Undecided,
	    'Prop is still being decided on');

    emit propFinished(prop.typeOf(), prop.result(), address(prop));

    if(prop.typeOf() == Proposal_Type.Confirmation){
      if(prop.result() == Result.Denied){
	return;
      }
      else if(prop.result() == Result.Affirmed){
	confirmed = true;
	emit homeConfirmed();
      }
    }
  }

   

  //return current share price, with discount added if applicable too member
  function calcSharePrice(address _member) isConfirmed public returns(uint) {}

  //create offer contract, subtract amount from creator's shares
  function offerShares(uint _amount)  isConfirmed public {}

  function isMember(address _member) public view returns (bool){
    bool _isMember = false;
    
    for(uint i=0; i<mem_addr.length; i++){
      if(mem_addr[i] == _member){
	_isMember = true;
	break;
      }
    }   

    return _isMember;
  }

  function isProp(Proposal prop) public view returns (bool){
    bool _isProp = false;

    for(uint i=0; i<props.length; i++){
      if(props[i] == prop){
	_isProp = true;
	break;
      }
	
    }

    return _isProp;
  }

  function getTotalMembers() public view returns (uint){
    return mem_addr.length;
  }

  function totalSupply() isConfirmed public view returns (uint){
    return TOTAL_SHARES;
  }

  function balanceOf(address tokenOwner)
    isConfirmed public view returns (uint balance){

    if(isMember(tokenOwner)){
       return member[tokenOwner].shares;
    }else{
	return 0;
    }

	 
  }

  function allowance(address tokenOwner, address spender)
    isConfirmed public view returns (uint remaining){
    return allowed[tokenOwner][spender];
  }

  function transfer(address to, uint tokens)
    isConfirmed public returns (bool success){

    if(!isMember(msg.sender)){
      return false;
    }

    if(!isMember(to)){
      return false;
    }

    if(member[msg.sender].shares < tokens){
      revert('Not enough shares to complete transaction');
    }

    member[msg.sender].shares -= tokens;
    member[to].shares += tokens;
    emit Transfer(msg.sender, to, tokens);
    return true;

  }

  function approve(address spender, uint tokens)
    isConfirmed public returns (bool success){
    if(!isMember(msg.sender)){
      return false;
    }

    if(!isMember(spender)){
      return false;
    }

    if(tokens > member[msg.sender].shares){
      tokens = member[msg.sender].shares;
    }

    allowed[msg.sender][spender] = tokens;
    emit Approval(msg.sender, spender, tokens);
    return true;
  }
  

  function transferFrom(address from, address to, uint tokens)
    isConfirmed public returns (bool success){

    //amount requested must have been preapproved
    require(allowance(from, to) >= tokens,
	    'requested funds have not been allowed');

    allowed[from][to] -= tokens;
    member[msg.sender].shares -= tokens;

    
  }


  

}
