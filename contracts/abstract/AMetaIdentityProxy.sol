pragma solidity ^0.4.24;

import "../interface/IReg.sol";
import "../identity/ClaimManager.sol";
import "../identity/MultiSig.sol";
import "../identity/KeyStore.sol";


contract AMetaIdentityProxy {
    mapping(bytes4 => bool) internal supportedInterfaces;

    bool public paused;
    uint256 public nonce;

    uint256 public managementThreshold = 1;
    uint256 public actionThreshold = 1;

    using KeyStore for KeyStore.Keys;
    KeyStore.Keys internal allKeys;

    mapping (uint256 => MultiSig.Execution) public execution;
    mapping (uint256 => address[]) public approved;

    mapping(bytes32 => ClaimManager.Claim) internal claims;
    mapping(uint256 => bytes32[]) internal claimsByTopic;
    uint256 public numClaims;

    IReg REG;
}