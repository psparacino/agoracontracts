// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "hardhat/console.sol";

contract Agora is ERC721URIStorage, Ownable {
    uint256 public tokenCounter;
    string public imageURI;
    event CreatedAgora(uint256 indexed tokenId, string hash);

    mapping (uint => Film) filmRepo;

    Film[] filmArray;


    constructor() ERC721("Agora NFT", "ag")
    {
        tokenCounter = 0;
    }

    struct Film {
      uint tokenID;
      string hash;
      string metadata;
    }

    function create(string memory hash, string memory metadataURL) public {
        _safeMint(msg.sender, tokenCounter);

        console.log("msg.sender", msg.sender);

        console.log("tokenId", tokenCounter);

        console.log("imageURI", imageURI);

        imageURI = baseTokenURI(hash);     

        _setTokenURI(tokenCounter, formatTokenURI(imageURI));
        tokenCounter = tokenCounter + 1;

        //for retrieval

        filmRepo[tokenCounter] = Film(tokenCounter, hash, metadataURL);

        filmArray.push(Film(tokenCounter, hash, metadataURL));

        emit CreatedAgora(tokenCounter, hash);
    }

    function getOneMovie(uint tokenID) public view returns(string memory) {
      return filmRepo[tokenID].hash;
    }

    function getAllMovies() public view returns(Film[] memory) {
        return filmArray;
    }



  function baseTokenURI( string memory hash) public pure returns (string memory) {
    return string(abi.encodePacked("https://opensea-creatures-api.herokuapp.com/api/creature/", hash ));
  }




    function formatTokenURI(string memory URI) public pure returns (string memory) {
        return string(
                abi.encodePacked(
                                '{"name":"',
                                "Agora NFT",
                                '", "description":"A video fesival Nft!", "attributes":"", "image":"',URI,'"}'
                            )
                        );
    }

}