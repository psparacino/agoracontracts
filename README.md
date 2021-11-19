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
- This splitter is re-deployed everytime by a method from the frontend, and burns 100% sharedDrops of an 
 Agora NFT



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

