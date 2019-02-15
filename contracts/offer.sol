pragma solidity ^0.5.0;

import  "./home_base.sol";

//offer home shares to another
contract Offer is Home_base {

  //shares currently held by contract for sale
  uint public shares_offered;

  //time created, represented as seconds since uinx epoch
  uint public creation_time;

  constructor(address issuer,
	      uint amount) public {}

  //allow creator of contract to withdraw shares
  function withdraw() public  {}

  /*
  Allow members to buy shares if:
     A) Their member type is eligible
     B) enough time has passed for their member type
     
  Ether will be expected to be sent with method call,
  shares bought will be determined by : (ether_sent/current_share_price)

  If this amount is greater than shares_offered, shares_offered will be given
  and extra will be stored for eventual refund
  
  Amount bought will be subtracted from shares_offered and shares put into
  members accounts
   */
  function buy(uint amount) public payable {}

  //allow buyer to collect refund if he has overspent
  function refund() public returns (uint){}

  //get member type of potential buyer from Home
  function getMemberType(address buyer) public {}

  /*get current share price in Ether from Home,
    include member address in case their for discount for member*/
  function get_share_price(address buyer) public {}
  
	      
}
