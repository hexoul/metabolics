pragma solidity ^0.4.24;

import "../RegistryUser.sol";

/// @title AttestationAgencyRegistry
/// @author genie
/// @notice Attestation Agency Registry.
/// @dev  Attestation Agency can be registered when create achievement or the permissioned user can create.
contract AttestationAgencyRegistry is RegistryUser {
    
    struct AttestationAgency {
        address addr;
        bytes32 title;
        bytes32 description;
        // code for 
        // bool type isEnterprise;
         
    }

    mapping(uint256=>AttestationAgency) public attestationAgencies;
    mapping(address=>uint256) public isAAregistered;

    uint256 attestationAgencyNum;
    
    event RegisterAttestationAgency(address indexed aa, bytes32 indexed title, bytes32 description);
    event UpdateAttestationAgency(address indexed aa, bytes32 indexed title, bytes32 description);

    function AttestationAgencyRegistry() public {
        THIS_NAME = "AttestationAgencyRegistry";
        attestationAgencyNum = 1;

        attestationAgencies[0].addr = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
        attestationAgencies[0].title = 'MetadiumDefault';
        attestationAgencies[0].description = 'MetadiumDefault';
    }

    function registerAttestationAgency(address _addr, bytes32 _title, bytes32 _description) permissioned public returns (bool) {
        require(isAAregistered[_addr] == 0);
        
        attestationAgencies[attestationAgencyNum].addr = _addr;
        attestationAgencies[attestationAgencyNum].title = _title;
        attestationAgencies[attestationAgencyNum].description = _description;

        isAAregistered[_addr] = attestationAgencyNum;

        attestationAgencyNum++;

        emit RegisterAttestationAgency(_addr, _title, _description);

        return true;
    }   

    function updateAttestationAgency(uint256 _num, address _addr, bytes32 _title, bytes32 _description) permissioned public returns (bool) {
        
        require(isAAregistered[_addr] == _num);

        attestationAgencies[attestationAgencyNum].addr = _addr;
        attestationAgencies[attestationAgencyNum].title = _title;
        attestationAgencies[attestationAgencyNum].description = _description;

        emit UpdateAttestationAgency(_addr, _title, _description);

        return true;

    }
    function isRegistered(address _addr) view public returns(uint256){
        return isAAregistered[_addr];
    }

    function getAttestationAgencySingle(uint256 _num) view public returns(address, bytes32, bytes32) {
        return (
            attestationAgencies[_num].addr,
            attestationAgencies[_num].title,
            attestationAgencies[_num].description
        );
    }

    function getAttestationAgenciesFromTo(uint256 _from, uint256 _to) view public returns(address[], bytes32[], bytes32[]){
        
        require(_to<attestationAgencyNum);
        
        address[] storage saddrs;
        bytes32[] storage sdescs;
        bytes32[] storage stitles;

        for(uint256 i=_from;i<_to;i++){
            saddrs.push(attestationAgencies[attestationAgencyNum].addr);
            sdescs.push(attestationAgencies[attestationAgencyNum].description);
            stitles.push(attestationAgencies[attestationAgencyNum].title);
        }

        return (saddrs, stitles, sdescs);
    } 
    

}
