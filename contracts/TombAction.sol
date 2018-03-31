pragma solidity ^0.4.21;

import "./TombOwnership.sol";

contract TombAction is TombOwnership {
    uint256 currentPrice;

    function buyAndCrave(string data) payable external {
        if (msg.value < currentPrice) revert();
        _createTombWithData(msg.sender, data);
    }
 
    function changePrice(uint256 newPrice) external onlyOwner {
        //gwei to ether
        uint256 gweiUnit = 1000000000;
        currentPrice = newPrice.mul(gweiUnit);
    }

    function getPrice() external view returns(uint256) {
        return currentPrice;
    }
}