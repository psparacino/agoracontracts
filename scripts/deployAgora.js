const { ethers } = require("hardhat");
require("@nomiclabs/hardhat-waffle");
require('dotenv').config();


/* Deploy Agora */

const Agora = await ethers.getContractFactory("Agora");
AgoraContract = await Agora.deploy();

console.log(`deployed ${AgoraContract} at : ${AgoraContract.address}`);




/* Deploy AgoraMarket */


const AgoraMarket = await ethers.getContractFactory("AgoraMarket");
AgoraMarketContract = await AgoraMarket.deploy();

console.log(`deployed ${AgoraMarketContract} at : ${AgoraMarketContract.address}`);





/* Deploy AgoraShare */

const AgoraShare = await ethers.getContractFactory("AgoraShare");
AgoraShareContract = await AgoraShare.deploy(AgoraContract.address);

console.log(`deployed ${AgoraShareContract} at : ${AgoraShareContract.address}`);






/* Deploy Payspliiter to release buyout */


// checkout line 140 to 143  and 145 agoraSharetests.js to implement buyout on the frontEnd
    
// const doubleArr = AgoraShareContract.getInvestorNShares(sharedIdNext);

// const ShareSplitter = await ethers.getContractFactory("PaymentSplitter");
// PaymentSplitterContract4SharedIdNext = await ShareSplitter.deploy(doubleArr["0"], doubleArr["1"]);




