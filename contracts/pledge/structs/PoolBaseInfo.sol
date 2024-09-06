// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "./PoolState.sol";
import "../../interface/IDebtToken.sol";

struct PoolBaseInfo {
    //结算时间
    uint256 settleTime;
    //结束时间
    uint256 endTime;
    //利率
    uint256 interestRate;
    //最大供应量
    uint256 maxSupply;
    //借贷（借出）供应量
    uint256 lendSupply;
    //质押（借入）供应量
    uint256 borrowSupply;
    //抵押率
    uint256 martgageRate;
    //借贷代币地址
    address lendToken;
    //质押代币地址
    address borrowToken;
    //池的状态
    PoolState state;
    //存款代币凭证
    IDebtToken spCoin;
    //债务代币凭证
    IDebtToken jpCoin;
    //自动清算阈值
    uint256 autoLiquidateThreshold;
}