// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

/**
 * 借贷池状态
 */
enum PoolState {
    MATCH, // 借贷池开始募捐
    EXECUTION, // 借贷协议结算已开始
    FINISH, // 借贷协议结算已结束
    LIQUIDATION, // 借贷协议已清算
    UNDONE // 借贷协议取消
}