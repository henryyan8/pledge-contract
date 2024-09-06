// We require the Hardhat Runtime Environment explicitly here. This is optional 
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile 
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // 合约地址
  let contractAddress = "0xbdEd0D2bf404bdcBa897a74E6657f1f12e5C6fb6";

  // 调用Hardhat的verify插件来验证合约
  await hre.run("verify:verify", {
    address: contractAddress,
    constructorArguments: [
        [
        "0x272aCa56637FDaBb2064f19d64BC3dE64A85A1b2",
        "0xbe9c40a0eab26a4223309ea650dea0dd4612767e",
        "0x0ff66Eb23C511ABd86fC676CE025Ca12caB2d5d4",
        "0xcdC5A05A0A68401d5FCF7d136960CBa5aEa990Dd"
        ],
        2
    ]
  })
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });