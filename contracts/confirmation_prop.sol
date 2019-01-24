pragma solidity ^0.5.0;

import  "./home_base.sol";

contract Confirmation_prop is Home_base {

  public Proposal_Type type = Proposal_Type.Confirmation;
  public bool open = true;
  Vote[] public votes;
  public address home;

  public uint pro = 0;
  public uint con = 0;

  constructor() public {
    home = msg.sender;
  }

  function castVote(Vote_Type vote_type) public {
    require(isMember(),
	    'Only members can vote');

    vote_index = getPreviousVote(msg.sender);

    //if voter has already voted, just change their previous vote
    if(vote != -1){
      changeVote(vote_index, vote_type);
      return;
     }

    Vote vote;
    vote.typeOf = vote_type;
    vote.address = msg.sender;
    votes.push(vote);

    if(vote_type == Vote_Type.For)
      pro++;
    if(vote_type == Vote_Type.Against)
      con++;

    emit voteCast(vote, type, msg.sender, this);

    tallyVote();
  }

  function tallyVote() internal {
    total_members = getTotalMembers();

    if( (pro/total_members) * 100 >= CONFIRMATION_PROP_THRESHOLD) {
      sendFinalResult();
    }

  }

  function sendFinalResult() private {}

  function isMember() private returns(bool) {}

  function getTotalMembers() private return(uint) {}

  //returns index of vote for voter, -1 if voter hasn't voted yet
  function getPreviousVote(address voter) internal returns (uint) {
    for(uint i = 0; i<votes.length; i++){
      vote = votes[i];
      if(vote.member == voter){
	return i;
      }
    }
    return -1;
  }

  function changeVote(uint vote_index, Vote_Type typeOf){
    bool change = false;

    if( (votes[vote_index]).typeOf != typeOf){
      change = true;
    }

    if(change){
      votes[vote_index].typeOf = typeOf;

      if(typeOf == Vote_Type.For){
	con--;
	pro++;
      }

      if(typeOf == Vote_Type.Against){
	con++;
	pro--;
      }
    }
  }
  
  
