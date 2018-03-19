pragma solidity ^0.4.18;

import "./interfaces/MingbiBase.sol";
import "./interfaces/ERC721Draft.sol";
import "./utils/SafeMath.sol";

contract MingbiOwnership is ERC721, MingbiBase {
    using SafeMath for uint256;

    /// @notice Name and symbol of the non fungible token, as defined in ERC721.
    string public name = "CryptoMingbi";
    string public symbol = "CM";

    mapping (uint => address) mingbiApprovals;

    function implementsERC721() public pure returns (bool) {
        return true;
    }

    function totalSupply() public view returns (uint) {
        return mingbies.length;
    }

    function balanceOf(address _owner) public view returns (uint256 _balance) {
        return ownerMingbiCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address _owner) {
        return mingbiToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        ownerMingbiCount[_to] = ownerMingbiCount[_to].add(1);
        ownerMingbiCount[msg.sender] = ownerMingbiCount[msg.sender].sub(1);
        mingbiToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        _transfer(msg.sender, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        mingbiApprovals[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public
    {
        require(_to != address(0));
        require(_to != address(this));
        require(mingbiApprovals[_tokenId] == msg.sender);
        require(mingbiToOwner[_tokenId] == _from);
        _transfer(_from, _to, _tokenId);
    }

    modifier onlyOwnerOf(uint _tokenId) {
        require(msg.sender == mingbiToOwner[_tokenId]);
        _;
    }
}
