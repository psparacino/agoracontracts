pragma solidity ^0.8.0;


/**
 * @dev Interface for the fungible NFT token Agora.
 *
 * 
 */
interface IAgoraShare {
    /**
     * @dev Returns an array of address of the investors in a particular shared NFT.
     */

    function getInvestor(uint16 tokenId) external view returns ( address [] memory); 
      /**
     * @dev Returns an array of shares from mappings  to investors in a particular shared NFT.
     */

    function getShares(uint16 tokenId) external view returns ( uint [] memory); 
}
}
