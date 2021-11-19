const chai = require('chai')
const { expect } = require("chai");
const { ethers } = require("hardhat");



  describe('AgoraNFT Unit Tests', async function () {
    beforeEach(async () => {
      const Agora = await ethers.getContractFactory("Agora");
      AgoraContract = await Agora.deploy()
    })
    it('The tokenId should increase', async () => {

  let NftId = await AgoraContract.tokenCounter();

  console.log("NftId", NftId)
  let result = await AgoraContract.create("tide")
   // wait until the transaction is mined
  await result.wait();
 
  let NftIdNext = await AgoraContract.tokenCounter();

  expect(NftIdNext).to.be.gt(NftId);
//  expect(NftId == NftIdNext).to.be.false;

})


 it('The newly minted Nft should return the correct Uri', async () => {
  let NftUrl = "https://opensea-creatures-api.herokuapp.com/api/creature/"+"tide" ;
   console.log("tokenUrl", NftUrl)
  let result = await AgoraContract.create("tide")
   // wait until the transaction is mined
 await result.wait();
 let  newNftUrl = await AgoraContract.imageURI();
 console.log("tokenUrl", newNftUrl)  
 expect(NftUrl == newNftUrl).to.be.true
    })

    it('The newly minted Nft should possess a unique Uri', async () => {
      let NftUrl = await AgoraContract.imageURI();
     console.log("tokenUrl", NftUrl)
      let result = await AgoraContract.create("tide")
       // wait until the transaction is mined
     await result.wait();
     let  newNftUrl = await AgoraContract.imageURI();
     console.log("tokenUrl", newNftUrl)  
     expect(NftUrl == newNftUrl).to.be.false
        })

    it('Retreive film by tokenID', async () => {
      let result = await AgoraContract.create("tide")
        // wait until the transaction is mined
      await result.wait();
      let  title = await AgoraContract.getOneMovie(1);
      console.log("title", title)  
      expect(title == "tide")
        })


    it('Retreive array of films by tokenID', async () => {
      let result = await AgoraContract.create("tide")
        // wait until the transaction is mined
      await result.wait();
      let result2 = await AgoraContract.create("wave")
      await result2.wait();
      let  filmArray = await AgoraContract.getAllMovies();
      console.log("filmArray", filmArray[1])  
      expect(filmArray[1].hash == 'tide')
      expect(filmArray[1].hash == 'wave')
        })


})