pragma solidity ^0.5.0;

import  "./home_base.sol";
import "./proposal.sol";
import "./confirmation_prop.sol";
import "./erc20.sol";
import "./offer.sol";


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

  uint8 public unused;//represent % of home unused, 0-100

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
    unused = 100;
    
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
    require(founder_usage <= unused,
	    'Not enough space');
    require(!confirmed,
	    'Cannot add founding member once contract has been confirmed');
    require(!isMember(founder_addr),
	    'Is alraedy a member');
    
    mem_addr.push(founder_addr);
    member[founder_addr].mem_type = founder_type;
    member[founder_addr].shares = founder_shares;
    member[founder_addr].usage_percent = founder_usage;
    emit newMember(founder_addr, founder_type);

    unused -= founder_usage;
    home_shares -= founder_shares;
  }

  function addMember(address addr,
		     Member_Type typeOf,
		     uint8 usage) isConfirmed internal {
    require(usage <= unused,
	    'Not enough space!');
    require(!isMember(addr),
	    'Is alraedy a member');

    mem_addr.push(addr);
    member[addr].mem_type = typeOf;
    member[addr].usage_percent = usage;
    emit newMember(addr, typeOf);

    unused -= usage;


  }

  function addMember(address addr,
		     Member_Type typeOf) isConfirmed internal {
    addMember(addr,
	      typeOf,
	      0);
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

  /*
  1. create offer contract
  2. make contract member of same type as issuer
  3. allow contract to spend issuers funds
  4. emit sharesOffered event
  */
  function offerShares(uint _amount)  isConfirmed public returns (address) {
    require(member[msg.sender].shares >= _amount,
	    'You do not own enough shares');
    
    Offer offer = new Offer(msg.sender, _amount);

    Member_Type mem_type = member[msg.sender].mem_type;
    addMember(address(offer), mem_type);

    bool success = approve(address(offer), _amount);
    assert(success);

    emit sharesOffered(_amount, msg.sender, address(offer));

    return address(offer);
    
  }

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
