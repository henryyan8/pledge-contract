// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "./IMultiSignature.sol";
contract multiSignatureClient {
    uint256 private constant MULTI_SIGN_POSITION =uint256(keccak256("org.multiSignature.store"));
    uint256 private constant DEFAULT_INDEX = 0;
    constructor(address multiSignature){
        require(multiSignature !=address(0),"multiSignatureClient : Multiple signature contract address is zero!");
        saveValue(MULTI_SIGN_POSITION,uint256(uint160(multiSignature)));
    }

    modifier validCall() {
        checkMultiSignature();
        _;
    }

    function checkMultiSignature() internal view{
        bytes32 msgHash=keccak256(abi.encodePacked(msg.sender,address(this)));
        // 获得多签合约地址
        address multiSign=getAddress();
        // 证该交易是否已被批准
        uint256 newIndex=IMultiSignature(multiSign).getValidSignature(msgHash,DEFAULT_INDEX);
        // 如果返回的 newIndex 大于 defaultIndex，则表示交易已被批准
        require(newIndex>DEFAULT_INDEX,"multiSignatureClient : This tx is not aprroved");
    }
    
    // 从存储槽中获取多签名合约的地址
    function getAddress() internal view returns (address) {
        return address(uint160(getAddress(MULTI_SIGN_POSITION)));
    }

    function getAddress(
        uint256 position
    ) internal view returns (uint256 value) {
        assembly {
            value := sload(position)
        }
    }
    
    function saveValue(uint256 position,uint256 value) internal
    {
        assembly {
            sstore(position, value)
        }
    }
}