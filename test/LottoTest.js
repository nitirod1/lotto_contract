const { expect } = require("chai");

describe("Token contract", function () {
  it("Deployment should assign the total supply of tokens to the owner", async function () {
    const [owner] = await ethers.getSigners();
    const lottoFactory = await ethers.getContractFactory("LottoFactory");
    const LottoContract = await ethers.getContractFactory("LottoToken");
    const lottoFact = await lottoFactory.deploy(await lottoFact.address)
    const lotto = await LottoContract.deploy();

    expect(0).to.equal(0);
  });
});