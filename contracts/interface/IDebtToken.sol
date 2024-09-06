// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title 债务代币核心接口
 * @author yht
 * @notice 
 */
interface IDebtToken {
     /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    // 查询特定账户的债务代币余额
    function balanceOf(address account) external view returns (uint256);

     /**
     * @dev Returns the amount of tokens in existence.
     */
    // 查询已发行的所有债务代币的总量
    function totalSupply() external view returns (uint256);

    /**
     * @dev Minting tokens for specific accounts.
     */
    // 为指定账户铸造新的债务代币
    function mint(address account, uint256 amount) external;

     /**
     * @dev Burning tokens for specific accounts.
     */
    // 销毁指定账户的债务代币
    function burn(address account, uint256 amount) external;
}