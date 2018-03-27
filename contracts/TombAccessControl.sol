pragma solidity ^0.4.21;

contract TombAccessControl {
    address public ownerAddress;

    modifier onlyOwner() {
        require(msg.sender == ownerAddress);
        _;
    }

    function withdrawBalance() external onlyOwner {
        address contractAddress = this;
        ownerAddress.transfer(contractAddress.balance);
    }
}
