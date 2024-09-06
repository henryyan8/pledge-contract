// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IMultiSignature{
    // 用于检查某个交易是否已通过多签名验证
    function getValidSignature(bytes32 msghash,uint256 lastIndex) external view returns(uint256);
}