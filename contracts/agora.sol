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
      string metadataURL;
    }

    function create(string memory metadataURL) public returns(uint, string memory) {
        _safeMint(msg.sender, tokenCounter);

        console.log("msg.sender", msg.sender);

        console.log("tokenId", tokenCounter);

        console.log("imageURI", imageURI);

        //imageURI = baseTokenURI(metadataURL);     

        //_setTokenURI(tokenCounter, formatTokenURI(imageURI));
        

        //for retrieval

        filmRepo[tokenCounter] = Film(tokenCounter, metadataURL);

        filmArray.push(Film(tokenCounter, metadataURL));
        
        tokenCounter = tokenCounter + 1;

        emit CreatedAgora(tokenCounter, metadataURL);
        
        return(tokenCounter, metadataURL);
    }
    
    function approveTokenTransfer(address NFTAddress, uint tokenID) public onlyOwner {
        approve(NFTAddress, tokenID);
    }

    function getOneMovie(uint tokenID) public view returns(string memory) {
      return filmRepo[tokenID].metadataURL;
    }

    function getAllMovies() public view returns(Film[] memory) {
        return filmArray;
    }


}