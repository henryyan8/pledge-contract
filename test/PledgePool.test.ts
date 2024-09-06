import { ethers } from "hardhat";
import { expect,use } from "chai";
import { solidity } from "ethereum-waffle";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

// 使用 ethereum-waffle 插件
use(solidity);


// 创建一个 fixture 用于每次测试前的部署
async function deployPledgePool() {
  const PledgePool = await ethers.getContractFactory("PledgePool");
  const [owner, addr1, addr2, _] = await ethers.getSigners();

  const feeAddress = addr1.address;
  const multiSignature = addr2.address;

  const pledgePool = await PledgePool.deploy(
    owner.address,
    addr1.address,
    feeAddress,
    multiSignature
  );

  await pledgePool.deployed();

  const currentTime = (await ethers.provider.getBlock('latest')).timestamp;

  return { pledgePool, owner, addr1, addr2, currentTime };
}

const fixture = loadFixture(deployPledgePool);

describe("PledgePool Contract", function () {
  beforeEach(async function () {
    console.log("Deploying contract...");
    const { pledgePool, owner, addr1, addr2, currentTime } = await fixture();
    this.pledgePool = pledgePool;
    this.owner = owner;
    this.addr1 = addr1;
    this.addr2 = addr2;
    this.currentTime = currentTime;
  });

  it("Should set the lending and borrowing fees with valid multi-signature", async function () {
    console.log("Running test for setting fees...");
    const lendFee = 100;
    const borrowFee = 200;

    const signature1 = await this.owner.signMessage("SomeMessage");
    const signature2 = await this.addr2.signMessage("SomeMessage");

    await expect(this.pledgePool.setFee(lendFee, borrowFee, [signature1, signature2]))
      .to.emit(this.pledgePool, "SetFee")
      .withArgs(lendFee, borrowFee);
  });

  it("Should revert if invalid multi-signature is provided", async function () {
    console.log("Running test for invalid multi-signature...");
    const lendFee = 100;
    const borrowFee = 200;

    const invalidSignature = await this.addr1.signMessage("InvalidMessage");

    await expect(this.pledgePool.setFee(lendFee, borrowFee, [invalidSignature]))
      .to.be.revertedWith("Multi-signature check failed");
  });

  describe("createPoolInfo", function () {
    it("Should create pool info with valid parameters", async function () {
      console.log("Running create pool info test...");
      const settleTime = this.currentTime + 3600; // 1小时后
      const endTime = this.currentTime + 7200; // 2小时后
      const interestRate = 5000; // 5%
      const maxSupply = ethers.utils.parseEther("1000");
      const martgageRate = 1000; // 10%
      const lendToken = this.addr1.address;
      const borrowToken = this.addr2.address;
      const spToken = this.addr1.address;
      const jpToken = this.addr2.address;
      const autoLiquidateThreshold = ethers.utils.parseEther("10");

      await this.pledgePool.createPoolInfo(
        settleTime,
        endTime,
        interestRate,
        maxSupply,
        martgageRate,
        lendToken,
        borrowToken,
        spToken,
        jpToken,
        autoLiquidateThreshold
      );

      // 检查创建的资金池信息
      const poolBaseInfo = await this.pledgePool.poolBaseInfo(0);
      const poolDataInfo = await this.pledgePool.poolDataInfo(0);

      expect(poolBaseInfo.settleTime).to.equal(settleTime);
      expect(poolBaseInfo.endTime).to.equal(endTime);
      expect(poolBaseInfo.interestRate).to.equal(interestRate);
      expect(poolBaseInfo.maxSupply).to.equal(maxSupply);
      expect(poolBaseInfo.martgageRate).to.equal(martgageRate);
      expect(poolBaseInfo.lendToken).to.equal(lendToken);
      expect(poolBaseInfo.borrowToken).to.equal(borrowToken);
      expect(poolBaseInfo.spCoin).to.equal(spToken);
      expect(poolBaseInfo.jpCoin).to.equal(jpToken);
      expect(poolBaseInfo.autoLiquidateThreshold).to.equal(autoLiquidateThreshold);

      expect(poolDataInfo.settleAmountLend).to.equal(0);
      expect(poolDataInfo.settleAmountBorrow).to.equal(0);
      expect(poolDataInfo.finishAmountLend).to.equal(0);
      expect(poolDataInfo.finishAmountBorrow).to.equal(0);
      expect(poolDataInfo.liquidationAmounLend).to.equal(0);
      expect(poolDataInfo.liquidationAmounBorrow).to.equal(0);
    });

    it("Should revert if end time is not greater than settle time", async function () {
      const settleTime = this.currentTime + 3600; // 1小时后
      const endTime = this.currentTime + 1800; // 30分钟后 (不合法)

      await expect(
        this.pledgePool.createPoolInfo(
          settleTime,
          endTime,
          5000,
          ethers.utils.parseEther("1000"),
          1000,
          this.addr1.address,
          this.addr2.address,
          this.addr1.address,
          this.addr2.address,
          ethers.utils.parseEther("10")
        )
      ).to.be.revertedWith("createPool:end time grate than settle time");
    });

    it("Should revert if token addresses are zero", async function () {
      const settleTime = this.currentTime + 3600;
      const endTime = this.currentTime + 7200;

      await expect(
        this.pledgePool.createPoolInfo(
          settleTime,
          endTime,
          5000,
          ethers.utils.parseEther("1000"),
          1000,
          this.addr1.address,
          this.addr2.address,
          ethers.constants.AddressZero,
          this.addr2.address,
          ethers.utils.parseEther("10")
        )
      ).to.be.revertedWith("createPool:is zero address");

      await expect(
        this.pledgePool.createPoolInfo(
          settleTime,
          endTime,
          5000,
          ethers.utils.parseEther("1000"),
          1000,
          this.addr1.address,
          this.addr2.address,
          this.addr1.address,
          ethers.constants.AddressZero,
          ethers.utils.parseEther("10")
        )
      ).to.be.revertedWith("createPool:is zero address");
    });
  });
});