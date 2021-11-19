const chai = require('chai')
const { expect } = require("chai");
const { ethers } = require("hardhat");





let NftIdNext;
let sharedIdNext;
const txnAmt = "250000000000000000000000";
const walletAddr = process.env.WALLET_ADDR;

  describe('AgoraShare Unit Tests', async function () {
    beforeEach(async () => {
      const Agora = await ethers.getContractFactory("Agora");
      AgoraContract = await Agora.deploy();

      const AgoraShare = await ethers.getContractFactory("AgoraShare");
      AgoraShareContract = await AgoraShare.deploy(AgoraContract.address);
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
   sharedIdNext = await AgoraContract.sharedId();
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


//   ---------------------------------------------------------------------------------- buyShares
 
  it('The token balance of token sharer should reduce after buying', async () => {
    // let zerobalance = 0;
    let amountToBuy = 1;
     
    let balance = await   AgoraShareContract.balanceOf(walletAddr);
    console.log("sharedId", balance)

    let boughtShares = await AgoraShareContract.buyShares(sharedIdNext, amountToBuy).connect(account[2]);

    boughtShares.wait(1);

    let newBalance =  AgoraShareContract.balanceOf(walletAddr);
    
    console.log("newBalance:", newBalance)
    expect(newBalance).to.be.lt(balance);

 })


 it('The token balance of token buyer should increase after buying', async () => {
    // let zerobalance = 0;
    let amountToBuy = 1;
     
    let balance = await   AgoraShareContract.balanceOf(accounts[2]);
    console.log("balance", balance)
  
    let boughtShares = await AgoraShareContract.buyShares(sharedIdNext, amountToBuy).connect(account[2]);

    boughtShares.wait(1);

    let newBalance =  AgoraShareContract.balanceOf(accounts[2]);
    
    console.log("newBalance:", newBalance)
    expect(newBalance).to.be.gt(balance);

 })


 it('The investors list at index 0 should be equal to msg.sender or token buyer should increase after buying', async () => {
    let investorlist =   AgoraShareContract.investors[sharedIdNext];

    let i = 0;

    while (investorlist.length > 0){
    console.log(`investor${i}`, investorlist[i])
    }
    expect((investorlist[0] == accounts[2]));
 })


//  -------------------------------------------------------------------------------------------------- redeem

it('The ether balance of sharer should increase after redemption', async () => {
    let zerobalance = await getBalance(walletAddr);

   let balance = ethers.utils.formatEther(zerobalance)

    console.log("Etherbalance", balance)
  
    let redeemShares = await AgoraShareContract.redeem(sharedIdNext);

     redeemShares.wait(1);

    let newBalance =  await getBalance(walletAddr);

    let afterredeembalance = ethers.utils.formatEther(newBalance);
 
    console.log("Ether balance after redeeming", afterredeembalance);

    expect(afterredeembalance).to.be.gt(balance);

 })


it('an Investor should be able to buyout a shared token', async () => {
      
    const doubleArr = AgoraShareContract.getInvestorNShares(sharedIdNext);

    const ShareSplitter = await ethers.getContractFactory("PaymentSplitter");
    PaymentSplitter4SharedIdNext = await ShareSplitter.deploy(doubleArr["0"], doubleArr["1"]);

    let zerobalance ,balance ,newBalance , afterbalance;
 
     console.log("Etherbalance", balance)
    
    doubleArr["0"].map(async(result) => {
      
     zerobalance = await getBalance(result);
     balance = ethers.utils.formatEther(zerobalance);
     console.log("Etherbalance", balance)

     let released = await PaymentSplitter4SharedIdNext.release(payable(result)) ;
     released.wait(1)

     newBalance =  await getBalance(result);
     afterredeembalance = ethers.utils.formatEther(newBalance);
     console.log("Ether balance after redeeming", afterredeembalance);

     expect(afterbalance).to.be.gt(balance);

    })
    // for(let i = 0; i++; i < doubleArr["0"].length){
    //     PaymentSplitterContract4SharedIdNext
    // }
 })



})