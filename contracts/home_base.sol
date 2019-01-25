pragma solidity ^0.5.0;

contract Home_base {

  //constants
  uint constant public TOTAL_SHARES = 1000000000000000000;// 10^18

  uint8 constant CONFIRMATION_PROP_THRESHOLD = 100;
  //enums and structs
  enum Vote_Type {
    For,
    Against
  }
  
  enum Result {
    Undecided,
    Affirmed,
    Denied
  }

  enum Proposal_Type {
   Confirmation 
  }
  
  enum Member_Type { 
    Custodian,
    Inhabitant,
    Member,
    Shareholder
  }

  struct Vote {
    Vote_Type typeOf;
    address member;
  }


  struct Member {
    uint shares;
    Member_Type mem_type;
    uint8 usage_percent;//percent of Home Member is using
    uint account;//Ether Home is holding for Member
  }

  //events
  event propFinished(Proposal_Type typeOf, Result result, address location);
  event newProp(Proposal_Type typeOf, address location);
  event voteCast(Vote_Type vote_type, Proposal_Type prop_type, address voter, address location);
  event newMember(address member, Member_Type member_type);
  event homeConfirmed();
  event sharesOffered(uint amount, address offerer, address offer_contract); 

}
