// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//池的数据信息
struct PoolDataInfo {
    //出借者的实际出资总额
    uint256 settleAmountLend;
    //借入者实际借入的总额
    uint256 settleAmountBorrow;
    //出借者在结束时应得的总额
    uint256 finishAmountLend;
    //借入者在结束时应付的总额
    uint256 finishAmountBorrow;
    //实际清算的金额
    uint256 liquidationAmounLend;
    //清算时的偿还总额
    uint256 liquidationAmounBorrow;
}