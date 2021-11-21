// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;
import './agora.sol';




contract AgoraShareLedgerContract {
    


        struct SharedDrop  {
          address sharer;
          uint tokensleft;
          uint sold;
          uint tokenId;
          uint unitprice;
          uint totalTokenSupply;
          uint equityForSale;
          uint totalBalanceRaised;
          Status state ;//{ Shared, Whole}
        
        }
        


        enum Status { Shared, Whole }
        Status state;

      SharedDrop [] sharedDrops;
    
      mapping (uint => mapping (address => uint)) investors ;
      
      mapping (uint => address[]) investorList;
      
      mapping (uint => SharedDrop) sharedDropsMapping;
      
      uint[] sharesInvested;
      
      
      //releases tokens for sale
      bool tokensAvailableForSale;

    
      event AgoraShared(
        address indexed sharer,
        uint indexed tokenId,
        uint tokenQuanity,
        uint priceInWei,
        Status state
      );
    
    
      event buyAgoraShared(
        uint Id,
        uint indexed tokenId,
        uint totalPrice,
        uint amount,
        address indexed owner,
        address indexed buyer
      );

   
      event redeemAgoraShared(
        uint _sharedId,
        address indexed owner,
        uint amountgained
        );
    
       address AgoraNFTaddress;
       Agora agora;
       
      constructor(address _agoraNft) {
       AgoraNFTaddress = _agoraNft;
       agora = Agora(_agoraNft);
       //_mint(msg.sender, numberOfTokens * (10 ** 18));
      }

// GETTERS

    function getNFTAddress() public view returns(address) {
        return AgoraNFTaddress;
    }
    
    function getTokenOwner(uint _tokenId) public view returns(address) {
    
        return agora.ownerOf(_tokenId);
    }

    
    function getInvestmentStatus(uint _tokenId) public view returns(uint) {
        return investors[_tokenId][msg.sender];
    }
    
    function getSharedDropStruct(uint _tokenId) public view returns(address, uint, uint, uint, uint, uint, uint) {
        return (sharedDropsMapping[_tokenId].sharer, 
                sharedDropsMapping[_tokenId].tokenId,
                sharedDropsMapping[_tokenId].tokensleft,
                sharedDropsMapping[_tokenId].sold,
                sharedDropsMapping[_tokenId].equityForSale,
                sharedDropsMapping[_tokenId].totalTokenSupply,
                sharedDropsMapping[_tokenId].unitprice);
    }
    
    function getAuthorizeViewing(uint16 _tokenId) public view returns(bool) {
        uint investedAmount = investors[_tokenId][msg.sender];
        require(investedAmount > 0, "no tokens have been purchased yet");
        require(sharedDropsMapping[_tokenId].sold > 0, "no one has invested in the film yet");
        if (investedAmount > 0) {
                return true;
            }
  }
  /*
     function getFilmInvestorArray(uint _tokenId) internal view returns(address[] memory) {
         return investorList[_tokenId];
     }

    
    
    function getFilmInvestors(uint _tokenId) public returns(address[] memory, uint[] memory) {
        address[] memory filmInvestors = getFilmInvestorArray(_tokenId);
       
        for (uint i; i < investorList[_tokenId].length; i++) {
          address investorAddress = investorList[_tokenId][i];
          uint investorTokens = investors[_tokenId][investorAddress];
          sharesInvested.push(investorTokens);
      }
        return(filmInvestors, sharesInvested);
  }
  */

    /*
     function getFilmInvestorArray(uint _tokenId) internal view returns(address[] memory) {
         return investorList[_tokenId];
     }
     */

    
    
    function getFilmInvestors(uint _tokenId) public view returns(address[] memory, uint[] memory) {
        //address[] memory filmInvestors = getFilmInvestorArray(_tokenId);

       /*
        for (uint i; i < investorList[_tokenId].length; i++) {
          address investorAddress = investorList[_tokenId][i];
          uint investorTokens = investors[_tokenId][investorAddress];
          
      }
      */
        return(investorList[_tokenId], sharesInvested);
  }
    
    
    
// THE REST OF IT
    
    
    // create # of tokens to be offered and allocate equityOffered for sale, the rest to msg.sender(owner)
    
  function shareAgoraNft(uint _tokenId, uint numberOfTokens, uint equityOffered, uint raiseAmount) public {
    require(equityOffered < 100, "can't offer more than 100%");
    require(equityOffered > 1, "need to buy more than 1%");
    require(msg.sender == agora.ownerOf(_tokenId),"not owner");
    
    SharedDrop memory sharedDrop = 
    // sharedDrops[_tokenId];
    SharedDrop({
        sharer: msg.sender,
        tokenId: _tokenId,
        tokensleft: (numberOfTokens * equityOffered) / 100,
        sold: 0,
        totalBalanceRaised : 0,
        totalTokenSupply : numberOfTokens,
        equityForSale: equityOffered,
        unitprice: raiseAmount / ((numberOfTokens * equityOffered) / 100),
        state: Status.Shared
    });

    sharedDropsMapping[_tokenId] = sharedDrop;
    
    //owner allocation of unoffered equity
    investors[_tokenId][msg.sender] = numberOfTokens - ((numberOfTokens * equityOffered) / 100);
    



  emit AgoraShared(
                   sharedDrop.sharer,
                   sharedDrop.tokenId,
                   sharedDrop.tokensleft,
                   sharedDrop.unitprice,
                   sharedDrop.state
                   );
                   
  }
  
  //(bool sent, ) = owner.call{value: uint(adjustedPrice)}("");
                //require(sent, "Failed to send Ether");
                
    function getToBuy(uint _tokenId, uint amount) public view returns(uint){
        uint tobuy =  sharedDropsMapping[_tokenId].unitprice * amount;
        return tobuy;
    }
                
    function buyShareinFilm(uint _tokenId, uint amount) public payable {
      
    // require buyer has enough money to purchase the amount of tokens
    // subtract the amount sold from the tokensleft
    // add investors purchase to ledger in investors
    
     uint tobuy =  sharedDropsMapping[_tokenId].unitprice * amount;
     require(sharedDropsMapping[_tokenId].state == Status.Shared, "revert 1");
     require( msg.value >= tobuy, "you don't have enough money");
     require( sharedDropsMapping[_tokenId].tokensleft > amount, "You are trying to buy more tokens than exist");
     require( sharedDropsMapping[_tokenId].tokensleft > 0, "there might be no more tokens left :-(");
     
     //(bool sent, ) = address(this).call{value: tobuy}("");
     //require(sent, "Failed to send Ether");
     
     sharedDropsMapping[_tokenId].tokensleft -= amount;
     sharedDropsMapping[_tokenId].sold += amount;
     sharedDropsMapping[_tokenId].totalBalanceRaised += tobuy;
     
     investors[_tokenId][msg.sender] = amount;
     investorList[_tokenId].push(msg.sender);
                         
  }
  
     function buyShareinFilmWithCall(uint _tokenId, uint amount) public payable {
      
    // require buyer has enough money to purchase the amount of tokens
    // subtract the amount sold from the tokensleft
    // add investors purchase to ledger in investors
    
     uint tobuy =  sharedDropsMapping[_tokenId].unitprice * amount;
     require(sharedDropsMapping[_tokenId].state == Status.Shared, "revert 1");
     require( msg.value >= tobuy, "you don't have enough money");
     require( sharedDropsMapping[_tokenId].tokensleft > amount, "You are trying to buy more tokens than exist");
     require( sharedDropsMapping[_tokenId].tokensleft > 0, "there might be no more tokens left :-(");
     
     (bool sent, ) = address(this).call{value: tobuy}("");
     require(sent, "Failed to send Ether");
     
     sharedDropsMapping[_tokenId].tokensleft -= amount;
     sharedDropsMapping[_tokenId].sold += amount;
     sharedDropsMapping[_tokenId].totalBalanceRaised += tobuy;
     
     investors[_tokenId][msg.sender] = amount;
     investorList[_tokenId].push(msg.sender);                    
  }
  
  
   function releaseSale(uint _tokenId) public {
      require(msg.sender == sharedDropsMapping[_tokenId].sharer, "not owner");
      tokensAvailableForSale = true;
  }
  
  
    //    mapping (uint => mapping (address => uint)) investors ;
      
     // mapping (uint => address[]) investorList;
  

  function distribution( uint _tokenId, uint buyOutAmount ) external {
    //  check if the sender is the owner
    // transfer sold token value to owner
    // send value to owner
      require(tokensAvailableForSale == true, "tokens not available for sale");
      require(investors[_tokenId][msg.sender] > 0, "not an investor");
      
      uint buyOutTokenWorth = buyOutAmount / sharedDropsMapping[_tokenId].totalTokenSupply;
     
      
      for (uint i; i < investorList[_tokenId].length; i++) {
          address investorAddress = investorList[_tokenId][i];
          uint investorTokens = investors[_tokenId][investorAddress];
          investors[_tokenId][investorAddress] = 0;
          payable(investorAddress).transfer(buyOutTokenWorth * investorTokens);
      }
          
          
      
      
      emit redeemAgoraShared( _tokenId,
                              msg.sender,
                              buyOutAmount
      );
  }
}

