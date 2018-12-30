pragma solidity ^0.5.0;

library Home_lib {

  enum Result {
    Undecided,
    Affirmed,
    Denied
  }

  enum Vote_Type {
    Finalize
  }
  
  struct Vote {
    Vote_Type typeOf;
    Result result;
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

}
