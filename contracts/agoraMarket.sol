pragma solidity ^0.8.1;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../agora.sol";
import "hardhat/console.sol";



contract AgoraMarket is Agora {


struct Trade {
  address poster;
  uint256 tokenId;
  uint256 price;
  enum status; // Open, Executed, Cancelled
}



mapping(uint256 => Trade) public trades;


constructor (
) public {
 
  tradeCounter = 0;
}


function openTrade(uint256 _tokenId, uint256 _price)
  public
{
    _create
  tokenIdToken.transferFrom(msg.sender, address(this), _tokenId);
  trades[tradeCounter] = Trade({
    poster: msg.sender,
    tokenId: _tokenId,
    price: _price,
    status: "Open"
  });
  tradeCounter += 1;
  emit TradeStatusChange(tradeCounter - 1, "Open");
}



function executeTrade(uint256 _trade)
  public
{
  Trade memory trade = trades[_trade];
  require(trade.status == "Open", "Trade is not Open.");
  currencyToken.transferFrom(msg.sender, trade.poster, trade.price);
  tokenIdToken.transferFrom(address(this), msg.sender, trade.tokenId);
  trades[_trade].status = "Executed";
  emit TradeStatusChange(_trade, "Executed");
}


function cancelTrade(uint256 _trade)
  public
{
  Trade memory trade = trades[_trade];
  require(
    msg.sender == trade.poster,
    "Trade can be cancelled only by poster."
  );
  require(trade.status == "Open", "Trade is not Open.");
  tokenIdToken.transferFrom(address(this), trade.poster, trade.tokenId);
  trades[_trade].status = "Cancelled";
  emit TradeStatusChange(_trade, "Cancelled");
}


}