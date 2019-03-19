pragma solidity ^0.4.24;

import "../abstract/AMetaIdentityProxy.sol";
import "./Slice.sol";
import "./Destructible.sol";
import "./KeyManager.sol";
import "./KeyGetters.sol";
import "./MultiSig.sol";
import "./ClaimManager.sol";


/// @title MetaIdentity
/// @author Metadium, genie
/// @notice Identity contract implementing ERC 725, ERC 735 and Metadium features.
contract MetaIdentityLib is AMetaIdentityProxy, MultiSig, ClaimManager, Destructible, KeyManager, KeyGetters {
    using Slice for bytes;
    using Slice for string;

    function init(address _managementKey) public {
        bytes32 senderKey = addrToKey(_managementKey);
        
        require(getKeysByPurpose(MANAGEMENT_KEY).length == 0, "Already initiated");

        // Add key that deployed the contract for MANAGEMENT, ACTION, CLAIM
        _addKey(senderKey, MANAGEMENT_KEY, ECDSA_TYPE);
        _addKey(senderKey, ACTION_KEY, ECDSA_TYPE);
        _addKey(senderKey, CLAIM_SIGNER_KEY, ECDSA_TYPE);
        
        managementThreshold = 1;
        actionThreshold = 1;

        // Supports both ERC 725 & 735
        supportedInterfaces[ERC725ID() ^ ERC735ID()] = true;
    }
}