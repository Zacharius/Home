pragma solidity ^0.5.0;

import  "./home_base.sol";
import "./home.sol";

contract Confirmation_prop is Home_base {

  Proposal_Type public typeOf = Proposal_Type.Confirmation;
  bool public open = true;
  Vote[] public votes;
  Home public home;

  uint public pro = 0;
  uint public con = 0;

  constructor() public {
    home = Home(msg.sender);
  }

  function castVote(Vote_Type vote_type) public {
    require(isMember(msg.sender),
	    'Only members can vote');

    int vote_index = getPreviousVote(msg.sender);

    //if voter has already voted, just change their previous vote
    if(vote_index != -1){
      changeVote(uint(vote_index), vote_type);
      return;
     }

    Vote memory vote;
    vote.typeOf = vote_type;
    vote.member = msg.sender;
    votes.push(vote);

    if(vote_type == Vote_Type.For)
      pro++;
    if(vote_type == Vote_Type.Against)
      con++;

    emit voteCast(vote.typeOf, typeOf, msg.sender, address(this));

    tallyVote();
  }

  function tallyVote() internal {
    uint total_members = getTotalMembers();

    if( (pro/total_members) * 100 >= CONFIRMATION_PROP_THRESHOLD) {
      sendFinalResult();
    }

  }

  function sendFinalResult() internal {
    home.receivePropResults();
  }

  function isMember(address _member) internal returns(bool) {
    return home.isMember(_member); 
  }

  function getTotalMembers() internal returns (uint) {
    return home.getTotalMembers();
  }

  //returns index of vote for voter, -1 if voter hasn't voted yet
  function getPreviousVote(address voter) internal returns (int) {
    for(uint i = 0; i<votes.length; i++){
      Vote storage vote = votes[i];
      if(vote.member == voter){
	return int(i);
      }
    }
    return -1;
  }

  function changeVote(uint vote_index, Vote_Type vote_type) internal{
    bool change = false;

    if( (votes[vote_index]).typeOf != vote_type){
      change = true;
    }

    if(change){
      votes[vote_index].typeOf = vote_type;

      if(vote_type == Vote_Type.For){
	con--;
	pro++;
      }

      if(vote_type == Vote_Type.Against){
	con++;
	pro--;
      }
    }
  }
}
  
  
