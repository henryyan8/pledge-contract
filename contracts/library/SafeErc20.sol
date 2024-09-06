// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SafeMath.sol";
import "./Address.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * 用于安全地处理ERC20代币的转账、批准、和配额管理等操作。它通过封装ERC20标准中的一些常用函数，确保这些操作在执行时不会因为错误而导致交易失败
 */
library SafeErc20 {
    using SafeMath for uint256;
    using Address for address;

    /**
     *  功能: 安全地将代币从当前合约地址转移到目标地址。
        实现: 通过_callOptionalReturn函数，确保token.transfer调用成功，如果失败则会回滚交易。
     */
    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    /**
     *  功能: 安全地将代币从一个地址转移到另一个地址，通常用于合约代理转账的情况。
        实现: 使用_callOptionalReturn调用token.transferFrom，确保操作成功。
     */
    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    /**
     *  功能: 安全地批准某个地址可以花费一定数量的代币。
        注意: 这个函数已被标记为不推荐使用，因为它与ERC20-approve函数存在类似问题。建议使用safeIncreaseAllowance和safeDecreaseAllowance来增加或减少代币花费额度。
        实现: 只有在现有配额为0或设置为0的情况下，才会调用token.approve，以避免安全漏洞。
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    /**
     *  功能: 安全地增加某个地址可以花费的代币额度。
        实现: 通过SafeMath安全地增加代币额度，并调用token.approve。
     */
    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(
            value
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    /**
     *  功能: 安全地减少某个地址可以花费的代币额度。
        实现: 通过SafeMath安全地减少代币额度，并调用token.approve。
     */
    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(
            value
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    /**
     *  功能: 低级调用ERC20合约的函数，并验证其是否成功。此函数是一个通用的低级调用封装，适用于所有ERC20操作。
        实现:
        使用Address.functionCall进行低级调用，确保目标地址是合约并且调用成功。
        如果返回数据不为空，则解码返回的数据并确保其为true，否则回滚交易。
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        bytes memory returndata = address(token).functionCall(
            data,
            "SafeERC20: low-level call failed"
        );
        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }
}
