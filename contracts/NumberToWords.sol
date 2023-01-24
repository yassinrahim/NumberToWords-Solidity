// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./String2.sol";

// This library converts numbers to words in English

library NumberToWords {
    using SafeMath for uint;
    using String2 for string;

    uint private constant TEN = 10;
    uint private constant ONE_HUNDRED = 100;
    uint private constant ONE_THOUSAND = 1000;
    uint private constant ONE_MILLION = 1000000;
    uint private constant ONE_BILLION = 1000000000; //         1.000.000.000 (9)
    uint private constant ONE_TRILLION = 1000000000000; //     1.000.000.000.000 (12)
    uint private constant ONE_QUADRILLION = 1000000000000000; // 1.000.000.000.000.000 (15)
    uint private constant MAX = 9007199254740992; // 9.007.199.254.740.992 (15)

    // // Constants for the names of the digits
    string private constant LESS_THAN_TWENTY =
        "zero,one,two,three,four,five,six,seven,eight,nine,ten,eleven,twelve,thirteen,fourteen,fifteen,sixteen,seventeen,eighteen,nineteen";
    // // Constants for the names of the tens
    string private constant TENTHS_LESS_THAN_HUNDRED =
        "zero,ten,twenty,thirty,forty,fifty,sixty,seventy,eighty,ninety";

    function toWords(uint number) public pure returns (string memory) {
        require(number < MAX, "Number cannot be higher than 9007199254740992");
        string memory words = "";
        uint num = number;

        words = generateWords(num, words);
        return words;
    }

    function generateWords(uint number, string memory words) private pure returns (string memory) {
        uint remainder;
        string memory word;

        // We’re done
        if (number == 0) {
            if (words.length() == uint(0)) {
                return "zero";
            } else {
                return words;
            }
        }

        if (number < 20) {
            remainder = 0;
            word = convertLessThanTwenty(number);
        } else if (number < ONE_HUNDRED) {
            remainder = number.mod(TEN);
            word = convertLessThanHundred(number.div(TEN));

            // In case of remainder, we need to handle it here to be able to add the “-”
            if (remainder != 0) {
                word = word.concat("-").concat(convertLessThanTwenty(remainder));
                remainder = 0;
            }
        } else if (number < ONE_THOUSAND) {
            remainder = number.mod(ONE_HUNDRED);
            word = generateWords(number.div(ONE_HUNDRED), "").concat(" hundred");
        } else if (number < ONE_MILLION) {
            remainder = number.mod(ONE_THOUSAND);
            word = generateWords(number.div(ONE_THOUSAND), "").concat(" thousand");
        } else if (number < ONE_BILLION) {
            remainder = number.mod(ONE_MILLION);
            word = generateWords(number.div(ONE_MILLION), "").concat(" million");
        } else if (number < ONE_TRILLION) {
            remainder = number.mod(ONE_BILLION);
            word = generateWords(number.div(ONE_BILLION), "").concat(" billion");
        } else if (number < ONE_QUADRILLION) {
            remainder = number.mod(ONE_TRILLION);
            word = generateWords(number.div(ONE_TRILLION), "").concat(" trillion");
        } else if (number <= MAX) {
            remainder = number.mod(ONE_QUADRILLION);
            word = generateWords(number.div(ONE_QUADRILLION), "").concat(" quadrillion");
        }

        if (words.length() != 0) {
            words = words.concat(" ");
        }

        words = words.concat(word);

        return generateWords(remainder, words);
    }

    // Converts a single digit to its word representation
    function convertLessThanTwenty(uint _digit) private pure returns (string memory) {
        string[] memory digitNames = LESS_THAN_TWENTY.split(",");
        return digitNames[_digit];
    }

    // Converts a number in the tens place to its word representation
    function convertLessThanHundred(uint _tens) private pure returns (string memory) {
        string[] memory tensNames = TENTHS_LESS_THAN_HUNDRED.split(",");
        return tensNames[_tens];
    }
}
