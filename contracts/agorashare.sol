// SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";
import './agora.sol';

contract AgoraShare is ERC20Burnable {

uint sharedId;

struct SharedDrop  {
  address sharer;
  // address splitterContract;
  // address[] investors;
  // share [] shares;
  uint16 tokensleft;
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

  uint[] knownShares;

 event AgoraShared(
    uint Id,
    address indexed sharer,
    uint256 indexed tokenId,
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


  constructor( address _agoraNft) ERC20('shared Agora Nft', 'agx') {
   sharedId = 0;
   AgoraNFTaddress = _agoraNft;
  }


  function shareAgoraNft(uint _tokenId, uint priceinWei) external 
   {
    ERC721(AgoraNFTaddress).transferFrom(msg.sender, address(this), _tokenId);
    SharedDrop memory sharedDrop = 
    // sharedDrops[_tokenId];
    SharedDrop({
        sharer: msg.sender,
        // splitterContract : "",
        // investors: [""],
        tokenId: _tokenId,
        tokensleft: 100,
        sold: 0,
       unitprice: priceinWei / 100 ,
       state: Status.Shared
    });
     sharedId += 1;
     _mint(address(this), 100 * 10 ** 18);


  emit AgoraShared(sharedId - 1, 
                   sharedDrop.sharer,
                   sharedDrop.tokenId,
                   sharedDrop.unitprice,
                   sharedDrop.state
                   );
  }



  function buyShares(uint16 _sharedId, uint16 amount) external payable {
    //   require buyer has enough money to purchase the amount of tokens
    // subtract the amount sold from the 
     uint tobuy =  sharedDrops[_sharedId].unitprice * amount;

     require(sharedDrops[_sharedId].state == Status.Shared, "Shares not yet available for that Id" );

     require( msg.value >= tobuy, "you don't have enough money");
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

  function redeem ( uint _sharedId ) external {
    //   check if the sender is the owner
    // transfer sold token value to owner
    // send value to owner
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