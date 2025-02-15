// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

/**
 * 质押信息
 */
struct BorrowInfo {
    uint256 stakeAmount;//质押金额
    uint256 refundAmount;//退款金额
    bool hasNoRefund;//是否已退款
    bool hasNoClaim;//是否已索赔
}