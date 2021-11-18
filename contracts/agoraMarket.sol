pragma solidity ^0.8.1;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./agora.sol";
import "hardhat/console.sol";

contract AgoraMarket is Agora {

uint orderId;

struct Order {
  address payable owner;
  uint256 tokenId;
  uint256 priceInWei;
  Status state ;// { Open, Executed, Cancelled } 
}

enum Status { Open, Executed, Cancelled }
Status state;
// mapping(uint256 => Order) public orders;

 Order [] ordering;


 event OrderCreated(
    uint orderId,
    address indexed owner,
    uint256 indexed tokenId,
    uint256 priceInWei,
    Status state
  );
  event OrderSuccessful(
    uint orderId,
    uint256 indexed tokenId,
    address indexed owner,
    uint256 totalPrice,
    address indexed buyer,
    Status state
  );
  event OrderCancelled(
    uint orderId,
    uint256 indexed tokenId,
    address indexed owner,
    Status state
  );



constructor (){
  orderId = 0;
}


function openOrder(uint256 _tokenId, uint256 _price)
  public
{
   transferFrom(msg.sender, address(this), _tokenId);
  Order memory order  =  Order({
    owner: payable(msg.sender),
    tokenId: _tokenId,
    priceInWei: _price,
    state: Status.Open
  });
  ordering.push(order);
  orderId += 1;
  

  emit OrderCreated(orderId-1,      
                    order.owner,
                    order.tokenId,   
                    order.priceInWei,
                    order.state);

}



function executeOrder(uint256 _orderId)
  public payable
{
  Order memory order = ordering[_orderId];
  require(order.state == Status.Open, "Order is not Open.");
  require(msg.value >= order.priceInWei);
  ordering[_orderId].state = Status.Executed; 
  transferFrom(address(this), msg.sender, order.tokenId);
  payable(order.owner).transfer(msg.value);

  emit OrderSuccessful(_orderId, 
                        order.tokenId,
                        order.owner,
                        order.priceInWei,
                        msg.sender,
                        order.state);
}


function cancelOrder(uint256 _orderId)
  public
{
  Order memory order = ordering[_orderId];
  require(
    msg.sender == order.owner,
    "Order can be cancelled only by owner."
  );
  require(order.state == Status.Open, "Order is not Open.");
  transferFrom(address(this), order.owner, order.tokenId);
  ordering[_orderId].state = Status.Cancelled;   

  emit OrderCancelled(
     _orderId,
     order.tokenId,
     order.owner,
     order.state
  );
}
