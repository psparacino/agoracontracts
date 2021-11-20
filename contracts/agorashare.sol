// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";
import './agora.sol';

contract AgoraShare is ERC20, ERC20Burnable {

uint sharedId;

struct SharedDrop  {
  address sharer;
  // address splitterContract;

  // share [] shares;
  uint32 tokensleft;
  uint16 sold;
  uint256 tokenId;
  uint256 unitprice;
  Status state ;//{ Shared, Whole}

  // mapping(uint => sharedDrop) public sharedDrops;
}

    enum Status { Shared, Whole}
    Status state;

  SharedDrop [] sharedDrops;

  mapping (address => uint16) [] share;

  mapping (uint16 => address[]) investors ;


  address[] splitterContract;
  
  //allows owner to release tokens for sale
  
  bool tokensAvailableForSale;

  uint[] knownShares;

 event AgoraShared(
    uint Id,
    address indexed sharer,
    uint256 indexed tokenId,
    uint tokenQuanity,
    uint256 priceInWei,
    Status state
  );


  event buyAgoraShared(
    uint Id,
    uint256 indexed tokenId,
    uint256 totalPrice,
    uint16 amount,
    address indexed owner,
    address indexed buyer
  );

   
  event redeemAgoraShared(
    uint _sharedId,
    address indexed owner,
    uint amountgained
    );




   address AgoraNFTaddress;


  constructor(address _agoraNft) ERC20('AgoraShareToken', 'agx') {
   sharedId = 0;
   AgoraNFTaddress = _agoraNft;
  }


  function shareAgoraNft(uint _tokenId, uint32 numberOfTokens, uint32 raiseAmount) public
   {
    ERC721(AgoraNFTaddress).transferFrom(msg.sender, address(this), _tokenId);

    uint32 tokenPrice = raiseAmount / numberOfTokens;

    SharedDrop memory sharedDrop = 
    // sharedDrops[_tokenId];
    SharedDrop({
        sharer: msg.sender,
        // splitterContract : "",
        tokenId: _tokenId,
        tokensleft: numberOfTokens,
        sold: 0,
       unitprice: tokenPrice,
       state: Status.Shared
    });
     sharedId += 1;
     _mint(address(this), numberOfTokens * (10 ** 18));


  emit AgoraShared(sharedId - 1, 
                   sharedDrop.sharer,
                   sharedDrop.tokenId,
                   sharedDrop.tokensleft,
                   sharedDrop.unitprice,
                   sharedDrop.state
                   );
  }



  function buyShares(uint16 _sharedId, uint16 amount) external payable {
    //  require buyer has enough money to purchase the amount of tokens
    // subtract the amount sold from the tokensleft
     uint tobuy =  sharedDrops[_sharedId].unitprice * amount;

     require(sharedDrops[_sharedId].state == Status.Shared, "Shares not yet available for that Id" );
     require( msg.value >= tobuy, "you don't have enough money");
     require( sharedDrops[_sharedId].tokensleft > amount, "you're trying to purchase more tokens than exist");
     require( sharedDrops[_sharedId].tokensleft > 0, "all tokens sold");
     
      sharedDrops[_sharedId].tokensleft -= amount;
      sharedDrops[_sharedId].sold += amount;

        share[_sharedId][msg.sender] = amount;

    //  sharedDrops[_tokenId].share[_tokenId][msg.sender] = amount;

       investors[_sharedId].push(msg.sender);

     _transfer(sharedDrops[_sharedId].sharer, msg.sender, amount);


  emit buyAgoraShared( _sharedId, 
                        sharedDrops[_sharedId].tokenId,
                         tobuy,
                         amount,
                         address(this),
                         msg.sender );
  }
  
  function releaseTokens() public {
      tokensAvailableForSale = true;
  }
  
  function authorizeViewing(uint16 sharedID) public view returns(bool) {
    uint arrayLength = investors[sharedID].length;
    for (uint i; i < arrayLength - 1 ; i++) {
        if (investors[sharedID][i] == msg.sender) {
            return true;
        }
    }
  }

  function redeem ( uint _sharedId ) external {
    //  check if the sender is the owner
    // transfer sold token value to owner
    // send value to owner
      require(tokensAvailableForSale == true);
      require(msg.sender == sharedDrops[_sharedId].sharer, "not owner bros");
      uint amountsold = sharedDrops[_sharedId].sold * sharedDrops[_sharedId].unitprice ;
      payable(msg.sender).transfer(amountsold);
      
      emit redeemAgoraShared( _sharedId,
                              msg.sender,
                              amountsold

      );
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

 function setSplitContract( uint tokenId, address _splitter) internal{
   require(msg.sender == sharedDrops[tokenId].sharer);
   splitterContract[tokenId] = _splitter;
 }



// --------------------------------------getters-----------------------------------
  function getInvestor(uint16 _sharedId) internal view returns ( address [] memory) {
   return  investors[_sharedId];
  }

  function getInvestorNShares(uint16 _sharedId) external  returns (address [] memory, uint [] memory) {
    // uint[] storage knownShares;
    investors [_sharedId] = getInvestor(_sharedId);
    uint16 i = 0;
    while( investors[_sharedId].length > i )
    {
       knownShares.push(share[_sharedId][investors[_sharedId][i]]) ;

    }
  //  for (uint16 i = 0; i++; i <= investors[tokenId].length){
  //     knownShares.push(
  //        share[tokenId][investors[i]]
        
  //       // sharedDrops[tokenId].shares[tokenId].investors[i] 
  //       );
  //  }
  // return (investors, knownShares);
  return (investors[_sharedId], knownShares);
  }
}