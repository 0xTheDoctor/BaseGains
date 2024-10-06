const { expect } = require("chai");
const hre = require("hardhat");

describe("Factory", function() {
  it("Created a coin", async function () {
    const newTokenContract = await hre.ethers.deployContract("Factory");
    const tx = await newTokenContract.createToken("Test","TST","This is a sample Token","image",{ value: hre.ethers.parseEther("0.01") });
  });

  it("User Purchse Token", async function () {
    const newTokenContract = await hre.ethers.deployContract("Factory");
    const tx = await newTokenContract.createToken("Test","TST","This is a sample Token","image",{ value: hre.ethers.parseEther("0.01") });
    const newTokenContractAdd = await newTokenContract.tokenAddresses(0);
    const tx2=  await newTokenContract.buyToken(newTokenContractAdd,100,{ value: hre.ethers.parseEther("25") });

  });


});



