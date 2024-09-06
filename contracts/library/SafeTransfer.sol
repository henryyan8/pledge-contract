// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./SafeErc20.sol";

contract SafeTransfer {
    using SafeErc20 for IERC20;
    event Redeem(address indexed recieptor,address indexed token,uint256 amount);
    
    /**
     * @notice  transfers money to the pool
     * @dev function to transfer
     * @param token of address
     * @param amount of amount
     * @return return amount
     */
    /**
     *  功能: 该函数负责将指定数量的代币或以太币转移到合约中，并返回实际转移的金额。
        参数:
        token: 代币的合约地址。如果传入 address(0)，则表示使用原生以太币。
        amount: 转移的金额。
        逻辑:
        如果 token 是 address(0)，则使用以太币，转移的金额为 msg.value。
        如果 amount 大于 0，且 token 不是 address(0)，则使用 SafeERC20 库中的 safeTransferFrom 函数，将指定的 amount 代币从调用者的账户转移到当前合约。
        返回值: 实际转移的金额。
     */
    function getPayableAmount(address token,uint256 amount) internal returns (uint256) {
        if (token == address(0)){
            amount = msg.value;
        }else if (amount > 0){
            IERC20 oToken = IERC20(token);
            oToken.safeTransferFrom(msg.sender, address(this), amount);
        }
        return amount;
    }

    /**
     * @dev An auxiliary foundation which transter amount stake coins to recieptor.
     * @param recieptor account.
     * @param token address
     * @param amount redeem amount.
     */
    /**
     *  功能: 该内部函数负责将指定的代币或以太币转移给接收人 (recieptor)。
        参数:
        recieptor: 接收代币或以太币的账户地址。
        token: 代币的合约地址。如果传入 address(0)，则表示使用原生以太币。
        amount: 要转移的金额。
        逻辑:
        如果 token 是 address(0)，则使用 transfer 函数将以太币转移给接收人。
        否则，使用 SafeERC20 库中的 safeTransfer 函数，将代币转移给接收人。
        事件触发: 转移完成后，触发 Redeem 事件，记录转移信息。
     */
    function _redeem(address payable recieptor,address token,uint256 amount) internal{
        if (token == address(0)){
            recieptor.transfer(amount);
        }else{
            IERC20 oToken = IERC20(token);
            oToken.safeTransfer(recieptor,amount);
        }
        emit Redeem(recieptor,token,amount);
    }
}