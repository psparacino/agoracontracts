const { ethers } = require("hardhat");
require("@nomiclabs/hardhat-waffle");
require('dotenv').config();


/* Deploy Agora */

async function main() {
    // We get the contract to deploy
    const Agora = await ethers.getContractFactory("Agora");
    AgoraContract = await Agora.deploy();
    
    console.log(`deployed ${AgoraContract} at : ${AgoraContract.address}`);
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





