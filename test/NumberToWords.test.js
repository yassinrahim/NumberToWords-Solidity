const { ethers } = require("hardhat")
const { expect } = require("chai")

describe("NumberToWords", function () {
    before(async function () {
        this.NumberToWords = await ethers.getContractFactory("NumberToWords")
        this.NumberToWords = await this.NumberToWords.deploy()
    })

    describe("First Test", function () {
        describe("No 1", function () {
            it("convert 1 digit", async function () {
                const value = 1
                let t = await this.NumberToWords.toWords(value)
                expect(t).to.equal("one")
            })
        })
    })
})
