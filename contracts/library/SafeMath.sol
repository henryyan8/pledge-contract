// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

library SafeMath {
    /**
     * @dev 返回两个无符号整数的加法，若发生溢出则抛出异常。
     * @param a 加数1
     * @param b 加数2
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        unchecked {
            c = a + b;
            require(c >= a, "SafeMath: addition overflow");
        }
    }

    /**
     * @dev 返回两个无符号整数的减法，若发生下溢则抛出异常。
     * @param a 被减数
     * @param b 减数
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
        require(b <= a, "SafeMath: subtraction underflow");
        unchecked {
            c = a - b;
        }
    }

    /**
     * @dev 返回两个无符号整数的乘法，若发生溢出则抛出异常。
     * @param a 乘数1
     * @param b 乘数2
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            c = 0;
        } else {
            unchecked {
                c = a * b;
                require(c / a == b, "SafeMath: multiplication overflow");
            }
        }
    }

    /**
     * @dev 返回两个无符号整数的除法。除数为零则抛出异常。
     * @param a 被除数
     * @param b 除数
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
        require(b > 0, "SafeMath: division by zero");
        unchecked {
            c = a / b;
        }
    }

    /**
     * @dev 返回两个无符号整数的取余数。除数为零则抛出异常。
     * @param a 被除数
     * @param b 除数
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256 c) {
        require(b > 0, "SafeMath: modulo by zero");
        unchecked {
            c = a % b;
        }
    }
}
