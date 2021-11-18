pragma solidity ^0.8.3;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";
import '../agora.sol';

contract AgoraShare is ERC20Burnable {

  
struct sharedDrop  {
  address owner;
  address splitterContract;
  address[] investors;
  uint16 tokensleft;
  uint16 sold;
  uint256 tokenId;
  uint256 unitprice;
  share [] shares;

}

  mapping(uint => sharedDrop) public sharedDrops;

  mapping (address => uint) share;

  constructor() ERC20('shared Agora Nft', 'agx') {
  }



// function
  function share(uint tokenId, uint prize, address owner) public returns (uint) {
    transferFrom(msg.sender, address(this), _tokenId);
    sharedDrops[tokenId] = sharedDrop({
        unitprice: div(prize, 100),
        owner: msg.sender,
        tokenId: tokenId,
        tokensleft: 100
    });
    Erc20._mint(address(this), 100 * 10 ** 18);
   return sharedDrops[tokenid];
  }

  function buy(uint amount, tokenId){
    //   require buyer has enough money to purchase the amount of tokens
    // subtract the amount sold from the 
     uint tobuy = mul(sharedDrops[tokenId].unitprice , amount);
     require( balanceof(msg.sender) > tobuy, "you don't have enough money");
      sharedDrops[tokenId].tokensleft -= amount;
      sharedDrops[tokenId].sold += amount;
      sharedDrops[tokenId].investors.push(msg.sender);
     sharedDrops[tokenId][shares][tokenId][msg.sender] = amount;
     Erc20._transfer(msg.sender, amount);
  }

  function redeem (){
    //   check if the sender is the owner
    // transfer sold token value to owner
    // send value to owner
      require(msg.sender == sharedDrops[tokenId].owner, "not owner bros");
      uint amountsold = mul(sharedDrops[tokenId].sold, sharedDrops[tokenId].price);
      msg.sender.transfer(amountsold);

  }

  // function buyOut(){
    // This function calls the getInvestor and getShares function
    // creates a newPaymentSplitter ---- redeploys at every instance with getInvestor and getShares
    // ----------------------------if there's enough time, we can consider gelato for automation  for redeployment of payment spiltter
    // then splits amongst investors
    // then burn sharedDrops
    // then transfer ERC721.transfer to buyer
  //    new PaymentSplitter()
  // this is to be done preferably in NodeJS
  // }

 function setSplitContract( address _splitter) internal{
   sharedDrop[splitterContract] = _splitter;
 }



// --------------------------------------getters-----------------------------------
  function getInvestor(uint16 tokenId) external view returns ( address [] memory) {
   return  sharedDrops[tokenId].investors;
  }

  function getShares(uint16 tokenId) external view returns (uint [] memory) {
    unit [] memory knownShares;
  address [] investors = getInvestor(tokenId);
   for(uint i = 0; i++; i < investors.length){
      knownShares.push(sharedDrops[tokenId].shares[tokenId].investors[i]]);
   }
  return knownShares
  }
}