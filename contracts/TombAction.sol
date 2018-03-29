pragma solidity ^0.4.21;

import "./TombOwnership.sol";

contract TombAction is TombOwnership {
    uint256 currentPrice;

    function breed() payable external {
        if (msg.value < currentPrice) revert();
        _createTomb(msg.sender);
    }

    function crave(uint _coinId, string data) external onlyOwnerOf(_coinId){
        Tomb storage tomb = tombs[_coinId];
        // Can't double craved a tomb
        if (tomb.craveman != address(0)) revert();
        craved += 1;
        tomb.data = data;
        tomb.craveman = msg.sender;
        _transfer(msg.sender, address(0), _coinId);
    }

    function changePrice(uint256 newPrice) external onlyOwner {
        currentPrice = newPrice;
    }

    function getPrice() external view returns(uint256) {
        return currentPrice;
    }
}
