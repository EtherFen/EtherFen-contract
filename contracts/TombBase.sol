pragma solidity ^0.4.21;

import "./TombAccessControl.sol";
import "./SafeMath.sol";

contract TombBase is TombAccessControl {
    using SafeMath for uint256;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    struct Tomb {
        // The timestamp from the block when this tomb came into existence.
        address sculptor;
        string data;
    }

    // An array containing all existing tomb
    Tomb[] tombs;
    mapping (uint => address) public tombToOwner;
    mapping (address => uint) ownerTombCount;
    mapping (uint => address) tombApprovals;

    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        tombToOwner[_tokenId] = _to;
        ownerTombCount[_to] = ownerTombCount[_to].add(1);
        if (_from != address(0)) {
            ownerTombCount[_from] = ownerTombCount[_from].sub(1);
            delete tombApprovals[_tokenId];
        }
        emit Transfer(_from, _to, _tokenId);
    }

    function _createTombWithData(address _owner, string givenData) internal returns (uint) {
        Tomb memory _tomb = Tomb({
            data: givenData,
            sculptor: _owner
        });
        uint256 newTombId = (tombs.push(_tomb)).sub(1);
        _transfer(0, _owner, newTombId);
        return newTombId;
    }

    function getTombByOwner(address _owner) external view returns(uint[]) {
        uint[] memory result = new uint[](ownerTombCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < tombs.length; i++) {
            if (tombToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    function getAllTombs() external view returns(uint[]) {
        uint[] memory result = new uint[](tombs.length);
        for (uint i = 0; i < tombs.length; i++) {
            result[i] = i;
        }
        return result;
    }

    function getTombDetail(uint index) external view returns(address, address, string) {
        // returns owner, sculptor, data
        return (tombToOwner[index], tombs[index].sculptor, tombs[index].data);
    }
}
