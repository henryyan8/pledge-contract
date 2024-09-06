// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

interface IBscPledgeOracle {

    /**
     * @notice 获取资产的价格
     * @dev 用于获取特定资产价格的函数
     * @param asset 需要获取价格的资产地址
     * @return uint 返回资产价格的尾数（按 1e8 缩放）; 如果价格未设置或合约已暂停，则返回零
     */
    function getPrice(address asset) external view returns (uint256);

    /**
     * @notice 获取基础资产的价格
     * @param cToken 需要获取价格的 cToken 标识符
     * @return uint 返回基础资产价格的尾数
     */
    function getUnderlyingPrice(
        uint256 cToken
    ) external view returns (uint256);

    /**
     * @notice 批量获取多个资产的价格
     * @param assets 需要获取价格的资产数组
     * @return uint[] prices返回一个包含各资产价格的数组
     */
    function getPrices(
        uint256[] calldata assets
    ) external view returns (uint256[] memory);
}
