pragma solidity ^0.4.21;

import "./TombBase.sol";
import "./ERC721Draft.sol";

contract TombOwnership is ERC721, TombBase {
    /// @notice Name and symbol of the non fungible token, as defined in ERC721.
    string public name = "EtherFen";
    string public symbol = "ETF";

    function implementsERC721() public pure returns (bool) {
        return true;
    }

    function totalSupply() public view returns (uint) {
        return tombs.length;
    }

    function balanceOf(address _owner) public view returns (uint256 _balance) {
        return ownerTombCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address _owner) {
        return tombToOwner[_tokenId];
    }

    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        _transfer(msg.sender, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        tombApprovals[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public
    {
        require(_to != address(0));
        require(_to != address(this));
        require(tombApprovals[_tokenId] == msg.sender);
        require(tombToOwner[_tokenId] == _from);
        _transfer(_from, _to, _tokenId);
    }

    modifier onlyOwnerOf(uint256 _tokenId) {
        require(tombToOwner[_tokenId] == msg.sender);
        _;
    }
}
