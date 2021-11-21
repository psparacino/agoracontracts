const { ethers } = require("hardhat");
require("@nomiclabs/hardhat-waffle");
require('dotenv').config();


/* Deploy Agora */

async function main() {
    // We get the contract to deploy


    const AgoraShare = await ethers.getContractFactory("AgoraShareLedgerContract");
    AgoraSharedContract = await AgoraShare.deploy("0x1a9927bD97505023a5a0670Be8f9f8872a998bB9");
    
    console.log(`deployed AgoraSharedContract at : ${AgoraSharedContract.address}`);


  }
  
  main()
    .then(() => process.exit(0))  
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });





/* Deploy Payspliiter to release buyout */


// checkout line 140 to 143  and 145 agoraSharetests.js to implement buyout on the frontEnd
    
// const doubleArr = AgoraShareContract.getInvestorNShares(sharedIdNext);

// const ShareSplitter = await ethers.getContractFactory("PaymentSplitter");
// PaymentSplitterContract4SharedIdNext = await ShareSplitter.deploy(doubleArr["0"], doubleArr["1"]);





