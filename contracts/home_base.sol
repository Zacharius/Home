pragma solidity ^0.5.0;

contract Home_base {

  //constants
  uint constant public TOTAL_SHARES = 1000000000000000000;// 10^18

  uint8 constant APPROVAL_PROP_THRESHOLD = 100;
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

  struct Proposal {
    Proposal_Type typeOf;
    Result result;
    Vote[] votes;
  }


  struct Member {
    uint shares;
    Member_Type mem_type;
    uint8 usage_percent;//percent of Home Member is using
    uint account;//Ether Home is holding for Member
  }

  //events
  event propFinished(uint propID, Proposal_Type typeOf, Result result);
  event newProp(Proposal_Type typeOf, uint propID);
  event voteCast(Vote_Type typeOf, uint propID);
  event newMember(address member, Member_Type member_type);
  event homeFinalized();
  event sharesOffered(uint amount, address offerer, address offer_contract); 

}
