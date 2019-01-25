pragma solidity ^0.5.0;

import "./proposal.sol";

contract Confirmation_prop is Proposal {

  Proposal_Type public typeOf = Proposal_Type.Confirmation;

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

  function tallyVote() internal view{
    uint total_members = getTotalMembers();

    if( (pro/total_members) * 100 >= CONFIRMATION_PROP_THRESHOLD) {
      finalizeResults();
    }

  }

  function finalizeResults() internal {
    home.finalizePropResults();
  }

  function isMember(address _member) internal view returns(bool) {
    return home.isMember(_member); 
  }

  function getTotalMembers() internal view returns (uint) {
    return home.getTotalMembers();
  }

  //returns index of vote for voter, -1 if voter hasn't voted yet
  function getPreviousVote(address voter) internal view returns (int) {
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
  
  
