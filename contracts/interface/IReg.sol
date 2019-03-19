pragma solidity ^0.4.24;


contract IReg {
    function getContractAddress(bytes32 _name) public view returns(address addr);
}