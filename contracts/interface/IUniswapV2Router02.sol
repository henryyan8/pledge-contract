// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

interface IUniswapV2Router02 {
    // 返回 Uniswap V2 工厂合约的地址。工厂合约用于部署新的流动性池（pair 合约）。
    function factory() external pure returns (address);
    // 返回 WETH（包裹的以太坊）合约的地址。Uniswap 使用 WETH 代替直接使用 ETH。
    function WETH() external pure returns (address);

    // 为两个代币 `tokenA` 和 `tokenB` 添加流动性。
    // `amountADesired` 和 `amountBDesired` 是用户希望提供的代币数量。
    // `amountAMin` 和 `amountBMin` 是添加流动性的最小代币数量，用于保护用户免受滑点的影响。
    // `to` 是接收流动性代币 (LP 代币) 的地址。
    // `deadline` 是交易的最后期限，超过这个时间交易将失败。
    // 返回实际添加的 `amountA` 和 `amountB` 数量，以及新增的流动性 `liquidity`。
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

    // 为代币 `token` 和 ETH 添加流动性。
    // `amountTokenDesired` 是用户希望提供的代币数量。
    // `amountTokenMin` 是添加流动性的最小代币数量，用于保护用户免受滑点的影响。
    // `amountETHMin` 是添加流动性的最小 ETH 数量，同样用于防止滑点。
    // `to` 是接收流动性代币 (LP 代币) 的地址。
    // `deadline` 是交易的最后期限，超过这个时间交易将失败。
    // 返回实际添加的 `amountToken` 和 `amountETH` 数量，以及新增的流动性 `liquidity`。
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    // 移除代币 `tokenA` 和 `tokenB` 的流动性。
    // `liquidity` 是要移除的流动性代币 (LP 代币) 的数量。
    // `amountAMin` 和 `amountBMin` 是从流动池中获得的最小代币数量，用于保护用户免受滑点影响。
    // `to` 是接收移除后的代币的地址。
    // `deadline` 是交易的最后期限。
    // 返回实际移除的 `amountA` 和 `amountB` 数量。
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);

    // 移除代币 `token` 和 ETH 的流动性。
    // `liquidity` 是要移除的流动性代币 (LP 代币) 的数量。
    // `amountTokenMin` 是从流动池中获得的最小代币数量。
    // `amountETHMin` 是从流动池中获得的最小 ETH 数量。
    // 其他参数与 `removeLiquidity` 类似。
    // 返回实际移除的 `amountToken` 和 `amountETH` 数量。
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);

    // 与 `removeLiquidity` 类似，但支持使用许可（Permit）来进行签名认证，从而允许不使用 `approve` 函数预先授权。
    // `approveMax` 表示是否授权最大可能的流动性。
    // `v`, `r`, `s` 是签名的组成部分，用于验证 `permit` 的合法性。
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);

    // 与 `removeLiquidityETH` 类似，但支持使用许可（Permit）来进行签名认证。
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);

    // 交换精确数量的 `amountIn` 代币到另一种代币。
    // `amountOutMin` 是期望最小输出的代币数量，用于防止滑点。
    // `path` 是交易路径，通常是从一种代币到另一种代币的路线。
    // `to` 是接收交换结果代币的地址。
    // `deadline` 是交易的最后期限。
    // 返回交换过程中的每一步中的代币数量。
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    // 交换精确数量的输出代币 `amountOut`，并指定最大可接受的输入代币数量 `amountInMax`。
    // 其他参数与 `swapExactTokensForTokens` 类似。
    // 返回交易过程中的每一步中的代币数量。
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    // 用精确的 ETH 数量交换代币。
    // `amountOutMin` 是期望最小输出的代币数量，用于防止滑点。
    // `path` 是交易路径，ETH 通常会作为路径的一部分。
    // `to` 是接收代币的地址。
    // `deadline` 是交易的最后期限。
    // 返回交易过程中的每一步中的代币数量。
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    // 交换精确数量的 ETH `amountOut`，并指定最大可接受的输入代币数量 `amountInMax`。
    // 其他参数与 `swapExactTokensForTokens` 类似。
    // 返回交易过程中的每一步中的代币数量。
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);

    // 用精确数量的代币交换 ETH。
    // `amountOutMin` 是期望最小输出的 ETH 数量，用于防止滑点。
    // 其他参数与 `swapExactTokensForTokens` 类似。
    // 返回交易过程中的每一步中的代币数量。
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);

    // 交换精确数量的代币 `amountOut`，并指定最大可接受的 ETH 数量。
    // 其他参数与 `swapExactTokensForTokens` 类似。
    // 返回交易过程中的每一步中的代币数量。
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    // 返回 `amountA` 对应的 `amountB`，计算基于两个代币的储备 `reserveA` 和 `reserveB`。
    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    // 根据输入 `amountIn` 和两个代币的储备 `reserveIn` 和 `reserveOut`，返回输出的代币数量 `amountOut`。
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    // 根据期望输出 `amountOut` 和两个代币的储备 `reserveIn` 和 `reserveOut`，返回需要的输入代币数量 `amountIn`。
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    // 返回按照指定路径 `path` 和输入代币数量 `amountIn`，能获得的输出代币数量。
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    // 返回按照指定路径 `path` 和期望输出代币数量 `amountOut`，需要的输入代币数量。
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);

    // 移除支持手续费的代币和 ETH 的流动性，并支持在代币转移时收取手续费。
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);

    // 与 `removeLiquidityETHSupportingFeeOnTransferTokens` 类似，但支持使用 `Permit` 进行签名认证。
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    // 交换支持手续费的代币。
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    // 用 ETH 交换支持手续费的代币。
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;

    // 用支持手续费的代币交换 ETH。
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}
