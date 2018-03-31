pragma solidity ^0.4.21;

import "./TombAction.sol";

contract TombCore is TombAction {
    function TombCore() public {
        ownerAddress = msg.sender;
        currentPrice = 0.01 ether;
    }
}
