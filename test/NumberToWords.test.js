const { ethers } = require("hardhat")
const { expect } = require("chai")
const { BigNumber } = require("ethers")

describe("NumberToWords", function () {
    before(async function () {
        this.NumberToWords = await ethers.getContractFactory("NumberToWords")
        this.NumberToWords = await this.NumberToWords.deploy()
    })

    describe("1 Digit", function () {
        const singleDigit = [
            "zero",
            "one",
            "two",
            "three",
            "four",
            "five",
            "six",
            "seven",
            "eight",
            "nine",
        ]

        for (let index = 0; index < singleDigit.length; index++) {
            it(index.toString(), async function () {
                let t = await this.NumberToWords.toWords(index)
                expect(t).to.equal(singleDigit[index])
            })
        }
    })

    describe("Teen Digits", function () {
        const teenDigits = {
            11: "eleven",
            12: "twelve",
            13: "thirteen",
            14: "fourteen",
            15: "fifteen",
            16: "sixteen",
            17: "seventeen",
            18: "eighteen",
            19: "nineteen",
        }

        for (let index in teenDigits) {
            it(index.toString(), async function () {
                let t = await this.NumberToWords.toWords(index)
                expect(t).to.equal(teenDigits[index])
            })
        }
    })

    describe("Ty Digits", function () {
        const tenDigits = {
            10: "ten",
            20: "twenty",
            30: "thirty",
            40: "forty",
            50: "fifty",
            60: "sixty",
            70: "seventy",
            80: "eighty",
            90: "ninety",
        }

        for (let index in tenDigits) {
            it(index.toString(), async function () {
                let t = await this.NumberToWords.toWords(index)
                expect(t).to.equal(tenDigits[index])
            })
        }
    })

    describe("2 Digits", function () {
        const twoDigits = {
            29: "twenty-nine",
            38: "thirty-eight",
            47: "forty-seven",
            56: "fifty-six",
            65: "sixty-five",
            74: "seventy-four",
            83: "eighty-three",
            92: "ninety-two",
        }

        for (let index in twoDigits) {
            it(index.toString(), async function () {
                let t = await this.NumberToWords.toWords(index)
                expect(t).to.equal(twoDigits[index])
            })
        }
    })

    describe("General Test", function () {
        const generalDigits = {
            134: "one hundred thirty-four",
            4572: "four thousand five hundred seventy-two",
            54572: "fifty-four thousand five hundred seventy-two",
            79837498237:
                "seventy-nine billion eight hundred thirty-seven million four hundred ninety-eight thousand two hundred thirty-seven",
            5498723456412315:
                "five quadrillion four hundred ninety-eight trillion seven hundred twenty-three billion four hundred fifty-six million four hundred twelve thousand three hundred fifteen",
            7329423423476758:
                "seven quadrillion three hundred twenty-nine trillion four hundred twenty-three billion four hundred twenty-three million four hundred seventy-six thousand seven hundred fifty-eight",
        }

        for (let index in generalDigits) {
            it(index.toString(), async function () {
                let t = await this.NumberToWords.toWords(index)
                expect(t).to.equal(generalDigits[index])
            })
        }
    })

    describe("Revert Test", function () {
        it("Number must not be higher than max", async function () {
            let bigNum = BigInt(10000000000000000)
            await expect(this.NumberToWords.toWords(bigNum)).to.be.revertedWith(
                "Number cannot be higher than 9007199254740992"
            )
        })
    })
})
