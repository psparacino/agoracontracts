# agora-smart-contracts

## Agora.sol 
 The video/music nft minting contract

## agoraMarket.sol
This is the decentralized marketplace for selling nft tokens 

## agoraShare.sol
 This contract allows you to split an agora Nft into shareable and purchasable bits(token)

## paymentsplitting.sol.
- This contract is
- This contract splits payment amongs investors/ token owners of an Agora Nft after a huge buyout
- This splitter is re-deployed everytime by a method from the frontend, and burns 100% sharedDrops of an Agora NFT



<!-- Todo, not exactly profitable for this hackathon -->
## stream payment.sol
This streams payment to the content creator to ensure they don't runaway with investor's funding



# create a token
 share the token or auction at marketplace

# share token
- Investor Buyout 
- checkout line 140 to 143  and 145 agoraSharetests.js to implement buyout on the frontEnd

# Agora Market
- Investor Executes Order



### SET-UP
- install `node.js` on your local system [here](https://nodejs.org/en/)
- run `npm i` to install dependencies



# check that hardhat works as expected

```
 npx hardhat
```

- Don't override config files

## RUN a node

<!-- Open terminal, use env.example as example for .env variables for asserting correctness of configuration -->
```
npx hardhat node --fork https://api.avax.network/ext/bc/C/rpc

```

## Compile and test solidity file  

<!-- Open another terminal -->

```
 npx hardhat compile
```
```
 npx hardhat test
```

## Deploy
```
 npx hardhat run scripts/deployAgora.js
```




#### FUNCTION MOCKUPS


## agora.sol setters



 * **Create New Film NFT**
 
 create(string memory hash)

 emit CreatedAgora(tokenCounter, hash)

 * **Allow film NFT to transfer ERC721 to buyShares on call**

  function approveTokenTransfer(address NFTAddress, uint tokenID) public onlyOwner {
      takes in address of film NFT and its token ID to approve transfer.
      ERC721 function.  Currently not working as expected.
  }

## agora.sol getters

<!-- baseTokenURI(string memory hash) public pure returns (string memory) {
    return string(abi.encodePacked("https://ipfs.io", hash ));
  } -->


 * **Return Film MetadataURL after passing in tokenID**
 * 
  function getOneMovie(uint tokenID) public view returns(string memory) {
    returns film's metadataURL
  }

  function getAllMovies() public view returns(Film[] memory) {
      returns array of all films' structs
    }


baseTokenURI(hash) {
  returns the external Url which could the ipfs.io link
}


formatTokenURI(tokenURL) {
  returns film/token metadata
  }


## agoraMarket.sol setters


* **The creator of the video NFT opens an order to sell the created**

openOrder(uint256 _tokenId, uint256 _price){
  emits event
}


* **The function is called by the investor willing to pay the entire sum after the creator list the created NFT from agora**

executeOrder(uint256 _orderId){
  emits event
}


* **This function allows the user to cancel an NFT order incase, and maybe fractionalize**

cancelOrder(uint256 _orderId){
  emits event
}


## agorashare.sol setters


* **set amount to raise, minimum token, and mint the correct # of tokens to be sold**

function shareAgoraNft(uint _tokenId, uint32 numberOfTokens, uint32 raiseAmount) {
  calculates the value of tokens token quantity and raise amount
   mints tokens and stores in SharedDrop struct
   *currently an authorization issue when film's NFT transfers 721 to this contract on creation
  emits event
}


* **Invest in the NFT**

 function buyShares(uint16 _sharedId, uint16 amount) external payable {
   allows user to purchase tokens/shares in NFT
   
   emits event
 }

* **Release Tokens**

function releaseTokens() public onlyOwner {
  allows the tokens to be purchased
}

* **Authorize Viewing**

  function authorizeViewing(uint16 sharedID) public view returns(bool) {
    allows users who have bought a token in a film to watch the film
  }

  
* **Redeem allows the video NFT owner to redeem the amount invested**

function redeem ( uint _sharedId ) external {}


## AgoraNFT getters

* **returns two seperate arrays fo deploying the payment splitter**

address [] is the array of investors in the particular VIDEO nfT token 

UINT [] is the precentage share of the investor index to index

This is useful in the payment splitter constructor-->


function getInvestorNShares(uint16 _sharedId) external  returns (address [] memory, uint [] memory) {}