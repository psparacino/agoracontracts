const chai = require('chai')
const { expect } = require("chai");
const { ethers } = require("hardhat");



  describe('AgoraShare Unit Tests', async function () {
    beforeEach(async () => {

     
      let NftIdNext;
      const txnAmt = "250000000000000000000000";
      const walletAddr = process.env.WALLET_ADDR;

      const Agora = await ethers.getContractFactory("Agora");
      AgoraContract = await Agora.deploy();

      const AgoraShare = await ethers.getContractFactory("AgoraShare");
      AgoraShareContract = await AgoraShare.deploy()
    })


    it('The tokenId should increase', async () => {

  let NftId = await AgoraContract.tokenCounter();

  console.log("NftId", NftId)
  let result = await AgoraContract.create("tide")
   // wait until the transaction is mined
 await result.wait();
 
    NftIdNext = await AgoraContract.tokenCounter();

 expect(NftIdNext).to.be.gt(NftId);
//  expect(NftId == NftIdNext).to.be.false;

})

   it('The sharedId should increase', async () => {
    let sharedId = await  AgoraShareContract.sharedId();
    console.log("sharedId", sharedId)
    let result = await AgoraContract.shareAgoraNft(NftIdNext, txnAmt)
     // wait until the transaction is mined
   await result.wait();
   let sharedIdNext = await AgoraContract.sharedId();
   expect(sharedIdNext).to.be.gt(sharedId);
  //  expect(NftId == NftIdNext).to.be.false;
  })

  it('The balance of AGX for owner should be greater than zero', async () => {
     let zerobalance = 0;
     let balance = await   AgoraShareContract.balanceOf(walletAddr);
     console.log("sharedId", balance)
     expect(balance).to.be.gt(zerobalance);
 
  })
  xit("The new owner of nftId should be contract address")


  ------------------------------------------------------------------------------------------------------
 
  it('The amount of token should reduce after buying', async () => {
    // let zerobalance = 0;
    // let balance = await   AgoraShareContract.balanceOf(walletAddr);

  function buyShares(uint16 _sharedId, uint16 amount) 
    console.log("sharedId", balance)
    expect(balance).to.be.gt(zerobalance);

 })


  
})