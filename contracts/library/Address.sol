// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     *  功能: 检查某个地址是否为合约地址。
        原理: 它通过调用extcodesize来获取地址的代码大小，如果代码大小大于0，则该地址是一个合约。
        注意: 这个方法并不能100%判断地址是外部拥有的账户（EOA），因为它会对正在构造的合约、将要创建合约的地址等情况返回false。
     */
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     *  功能: 发送指定数量的wei到目标地址，并转发所有可用的gas，如果失败则回滚交易。
        原理: 使用低级调用call来发送wei，而不是transfer，因为transfer在某些情况下会由于gas限制而失败。
        注意: 使用此函数时要小心重入攻击，因此建议结合ReentrancyGuard或其他模式。
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value:amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     *  功能: 低级别调用合约函数，functionCall仅执行调用，而functionCallWithValue还会发送wei。
        原理: 它们都使用低级call来调用合约函数。如果调用失败，错误信息会被传递给调用者。
        注意: 这两个函数都需要目标地址为合约地址。
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     *  功能: 低级别调用合约函数，functionCall仅执行调用，而functionCallWithValue还会发送wei。
        原理: 它们都使用低级call来调用合约函数。如果调用失败，错误信息会被传递给调用者。
        注意: 这两个函数都需要目标地址为合约地址。
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     *  功能: 低级别调用合约函数，functionCall仅执行调用，而functionCallWithValue还会发送wei。
        原理: 它们都使用低级call来调用合约函数。如果调用失败，错误信息会被传递给调用者。
        注意: 这两个函数都需要目标地址为合约地址。
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     *  功能: 低级别调用合约函数，functionCall仅执行调用，而functionCallWithValue还会发送wei。
        原理: 它们都使用低级call来调用合约函数。如果调用失败，错误信息会被传递给调用者。
        注意: 这两个函数都需要目标地址为合约地址。
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value:value}(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     *  功能: 执行静态调用，允许调用合约函数但不改变状态。
        原理: 使用staticcall进行调用，目标地址必须为合约。
        注意: 静态调用无法发送ether或改变区块链状态。
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     *  功能: 执行静态调用，允许调用合约函数但不改变状态。
        原理: 使用staticcall进行调用，目标地址必须为合约。
        注意: 静态调用无法发送ether或改变区块链状态。
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     *  功能: 执行委托调用，允许在目标合约的上下文中执行代码，但保留当前合约的storage、msg.sender和msg.value。
        原理: 使用delegatecall进行调用，目标地址必须为合约。
        注意: 委托调用可以访问并修改调用合约的存储，因此要特别小心安全性问题。
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     *  功能: 执行委托调用，允许在目标合约的上下文中执行代码，但保留当前合约的storage、msg.sender和msg.value。
        原理: 使用delegatecall进行调用，目标地址必须为合约。
        注意: 委托调用可以访问并修改调用合约的存储，因此要特别小心安全性问题。
     */
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     *  功能: 检查调用结果，如果调用成功返回结果数据，否则会将错误信息泡上来并回滚交易。
        原理: 如果returndata长度大于0，则使用内联汇编将错误信息重新抛出。
        注意: 这个函数主要用于统一处理函数调用的返回结果和错误信息。
     */
    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly
                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}