pragma solidity ^0.4.24;

import "../abstract/AMetaIdentityProxy.sol";


/**
 * @title MetaIdentityProxy
 * @dev Interface for MetaIdentityProxy
 */
contract MetaIdentityProxy is AMetaIdentityProxy {
    // Line All the MetaIdentity variables up.
    // For delegate call, contract storage layout must be same.
    // Line up order is following the solidity inheritance logic(python like)

    function implementation() public view returns (address) {
        return REG.getContractAddress("MetaIdLibraryV1");
    }

    function setRegistry(address _addr) public returns (bool) {
        require(allKeys.find(bytes32(msg.sender), 1), "not a management key");
        REG = IReg(_addr);
        return true;
    }

    constructor(address _registry, address _managementKey) public {
        bytes4 sig = bytes4(keccak256("init(address)"));
        REG = IReg(_registry);

        // two 32bytes for call data
        address target = implementation();
        uint256 argsize = 32;
        bool suc;

        assembly {
            // Add the signature first to memory
            mstore(0x0, sig)
            // Add the call data, which is at the end of the
            // code
            codecopy(0x4, sub(codesize, argsize), argsize)
            // Delegate call to the library
            suc := delegatecall(sub(gas, 10000), target, 0x0, add(argsize, 0x4), 0x0, 0x0)
        }
    }
    
    /**
    * @dev Tells the type of proxy (EIP 897)
    * @return Type of proxy, 2 for upgradeable proxy
    */
    function proxyType() public pure returns (uint256 proxyTypeId) {
        return 2;
    }

    /**
     * @dev Fallback function for delegate call. This function will return whatever the implementaion call returns
     */
    function () payable public {
        address _impl = implementation();
        require(_impl != address(0));

        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize)

            let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
            let size := returndatasize
            returndatacopy(ptr, 0, size)

            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }
}
