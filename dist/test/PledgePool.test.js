"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const hardhat_1 = require("hardhat");
const chai_1 = require("chai");
const time_1 = require("./helper/time");
describe("PledgePool", function () {
    let busdAddress;
    let btcAddress, spAddress, jpAddress;
    let weth, factory, router;
    let minter, alice, bob, carol;
    let bscPledgeOracle;
    let pledgeAddress;
    beforeEach(async () => {
        await (0, time_1.stopAutoMine)();
        [minter, alice, bob, carol] = await hardhat_1.ethers.getSigners();
        // 初始化合约实例
        const bscPledgeOracleToken = await hardhat_1.ethers.getContractFactory("MockOracle");
        bscPledgeOracle = await bscPledgeOracleToken.deploy();
        const spToken = await hardhat_1.ethers.getContractFactory("DebtToken");
        spAddress = (await spToken.deploy("spBUSD_1", "spBUSD_1"));
        const jpToken = await hardhat_1.ethers.getContractFactory("DebtToken");
        jpAddress = (await jpToken.deploy("jpBTC_1", "jpBTC_1"));
        [weth, factory, router, busdAddress, btcAddress] = await initAll(minter);
        const pledgeToken = await hardhat_1.ethers.getContractFactory("MockPledgePool");
        pledgeAddress = await pledgeToken.deploy(bscPledgeOracle.address, router.address, minter.address);
    });
    async function initCreatePoolInfo(pledgeAddress, minter, time0, time1) {
        let startTime = await (0, time_1.latest)();
        let settleTime = (parseInt(startTime) + parseInt(time0.toString()));
        show({ settleTime });
        let endTime = (parseInt(settleTime) + parseInt(time1.toString()));
        show({ endTime });
        let interestRate = 1000000;
        let maxSupply = BigInt(100000000000000000000000);
        let martgageRate = 200000000;
        let autoLiquidateThreshold = 20000000;
        await pledgeAddress.connect(minter).createPoolInfo(settleTime, endTime, interestRate, maxSupply, martgageRate, busdAddress, btcAddress, spAddress.address, jpAddress.address, autoLiquidateThreshold);
    }
    it("check if mint right", async function () {
        await spAddress.addMinter(minter.getAddress());
        await jpAddress.addMinter(minter.getAddress());
        await spAddress.connect(minter).mint(alice.getAddress(), BigInt(100000000));
        await jpAddress.connect(minter).mint(alice.getAddress(), BigInt(100000000));
        (0, chai_1.expect)(await spAddress.totalSupply()).to.equal(BigInt(100000000).toString());
        (0, chai_1.expect)(await spAddress.balanceOf(alice.getAddress())).to.equal(BigInt(100000000).toString());
        (0, chai_1.expect)(await jpAddress.totalSupply()).to.equal(BigInt(100000000).toString());
        (0, chai_1.expect)(await jpAddress.balanceOf(alice.getAddress())).to.equal(BigInt(100000000).toString());
    });
    it("Create Pool info", async function () {
        await initCreatePoolInfo(pledgeAddress, minter, 100, 200);
        (0, chai_1.expect)(await pledgeAddress.poolLength()).to.be.equal(1);
    });
    it("Non-administrator creates pool", async function () {
        await (0, chai_1.expect)(initCreatePoolInfo(pledgeAddress, alice, 100, 200)).to.be.revertedWith("Ownable: caller is not the owner");
    });
});
