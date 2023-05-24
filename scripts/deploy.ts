import { ethers } from "hardhat";

async function main() {

  const Lotto = await ethers.getContractFactory("Lotto.sol");
  const lock = await Lotto.deploy();

  await lock.deployed();

  console.log(
    `Lock with deployed to ${lock.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
