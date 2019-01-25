pragma solidity ^0.5.0;

import  "./home_base.sol";
import "./home.sol";

contract Proposal is Home_base {
  Proposal_Type public typeOf;
  Result public result = Result.Undecided;

  Home public home;

  uint public con = 0;
  uint public pro = 0;
  Vote[] public votes;

  function castVote(Vote_Type _typeOf) public;
  function tallyVote() internal view;
  function finalizeResults() internal;
}
