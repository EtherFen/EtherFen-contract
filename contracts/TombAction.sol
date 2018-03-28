pragma solidity ^0.4.21;

import "./TombOwnership.sol";

contract TombAction is TombOwnership {
    uint256 currentPrice;
    uint256 factor;

    function breed() payable external {
        if (msg.value < currentPrice) revert();
        currentPrice = currentPrice.add(factor);
        _createTomb(msg.sender);
    }

    function crave(uint _coinId, string data) external onlyOwnerOf(_coinId){
        Tomb storage tomb = tombs[_coinId];
        // Can't double craved a tomb
        if (tomb.craveman != address(0)) revert();
        craved += 1;
        currentPrice = currentPrice.sub(factor);
        tomb.data = data;
        tomb.craveman = msg.sender;
        _transfer(msg.sender, address(0), _coinId);
    }

    function changeFactor(uint256 f) external onlyOwner {
        factor = f;
    }

    function getPrice() external view returns(uint256) {
        return currentPrice;
    }
}
