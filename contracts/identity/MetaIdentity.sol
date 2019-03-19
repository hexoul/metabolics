pragma solidity ^0.4.24;

import "./Destructible.sol";
import "./ERC735.sol";
import "./KeyGetters.sol";
import "./KeyManager.sol";
import "./MultiSig.sol";
import "./ClaimManager.sol";
import "./Slice.sol";


/// @title MetaIdentity
/// @author Metadium, genie
/// @notice Identity contract implementing ERC 725, ERC 735 and Metadium features.
contract MetaIdentity is KeyManager, MultiSig, ClaimManager, Destructible, KeyGetters {
    using Slice for bytes;
    using Slice for string;

    /// @dev Constructor for Identity contract. If no initial keys are passed then
    ///  `msg.sender` is used as an initial MANAGEMENT_KEY, ACTION_KEY and CLAIM_SIGNER_KEY
    constructor(address _managementKey)
    public {

        bytes32 senderKey = addrToKey(_managementKey);
        
        // Add key that deployed the contract for MANAGEMENT, ACTION, CLAIM
        _addKey(senderKey, MANAGEMENT_KEY, ECDSA_TYPE);
        _addKey(senderKey, ACTION_KEY, ECDSA_TYPE);
        _addKey(senderKey, CLAIM_SIGNER_KEY, ECDSA_TYPE);
        
        managementThreshold = 1;
        actionThreshold = 1;

        // Supports both ERC 725 & 735
        supportedInterfaces[ERC725ID() ^ ERC735ID()] = true;
    }

    // Fallback function accepts Ether transactions
    // solhint-disable-next-line no-empty-blocks
    function () external payable {
    }
}