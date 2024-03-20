// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

contract Proxy {
    address public owner;
    address public implementation;

    constructor(address _implementation) {
        owner = msg.sender;
        implementation = _implementation;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function upgradeImplementation(address _newImplementation) public onlyOwner {
        implementation = _newImplementation;
    }

    fallback() external {
        address _impl = implementation;
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)

            switch result
            case 0 {
                revert(ptr, size)
            }
            default {
                return(ptr, size)
            }
        }
    }
}