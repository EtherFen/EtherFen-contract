pragma solidity ^0.4.21;

import "./TombAccessControl.sol";
import "./SafeMath.sol";

contract TombBase is TombAccessControl {
    using SafeMath for uint256;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    struct Tomb {
        // The timestamp from the block when this tomb came into existence.
        address burner;
        string data;
    }

    // An array containing all existing tomb
    Tomb[] tombs;
    uint256 burnt;
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

    function _createTomb(address _owner) internal returns (uint) {
        Tomb memory _tomb = Tomb({
            data: "",
            burner: address(0)
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

    function getTombBurnt() external view returns(uint[]) {
        uint[] memory result = new uint[](burnt);
        uint counter = 0;
        for (uint i = 0; i < tombs.length; i++) {
            if (tombs[i].burner != address(0)) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    function getTombDetail(uint index) external view returns(address, address, string) {
        // returns owner, burner, data
        return (tombToOwner[index], tombs[index].burner, tombs[index].data);
    }
}
