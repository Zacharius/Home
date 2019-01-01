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
    Finalize
  }
  
  struct Proposal {
    Proposal_Type typeOf;
    Result result;
    uint pro;
    uint con;
  }

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

  //events
  event newVote(Vote_Type typeOf, uint id);
  event newMember(address member, Member_Type member_type);
  event homeFinalized(address homeAddress);

}
