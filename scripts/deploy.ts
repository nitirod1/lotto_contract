import { ethers } from "hardhat";

async function main() {

  const LottoFactory = await ethers.getContractFactory("LottoFactory");
  const LottoFactoryDeployed = await LottoFactory.deploy();
  await LottoFactoryDeployed.deployed();
  const LottoToken = await ethers.getContractFactory("LottoToken");
  const LottoTokenDeployed = await LottoToken.deploy(LottoFactoryDeployed.address);
  await LottoTokenDeployed.deployed();

  console.log(`
  LottoFactory with deployed to ${LottoFactoryDeployed.address}
  LottoTokenDeployed with deployed to ${LottoTokenDeployed.address}
  `
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
