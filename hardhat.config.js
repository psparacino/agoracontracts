require("@nomiclabs/hardhat-waffle");
require("dotenv").config();


module.exports = {
  networks: {
    hardhat: {
      accounts: [{privateKey: process.env.PRIVATE_KEY, balance: "100000000000000000000000"}],
      chainId: 43114,
      forking: {
        url: "https://api.avax.network/ext/bc/C/rpc"
      },
    },
    kovan: {
      url: "https://kovan.infura.io/v3/61b2fd20d10849dd93a482c6952500d9",
      accounts: [process.env.PRIVATE_KEY]
    },
    fuji: {
      url: "https://api.avax-test.network/ext/bc/C/rpc",
      accounts: [process.env.PRIVATE_KEY]
    },
    mainnet: {
      url: "https://api.avax.network/ext/bc/C/rpc",
      accounts: [process.env.PRIVATE_KEY]
    },
  },
  solidity: {
    compilers: [
      {
        version: "0.8.3",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  mocha: {
    timeout: 120000
  }
};
