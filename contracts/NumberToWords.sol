// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Strings.sol";
import "hardhat/console.sol";

// This library converts numbers to words in English

library NumberToWords {
    using SafeMath for uint;
    using Strings for string;

    // // Constants for the names of the digits
    // string private constant DIGIT_NAMES = "zero,one,two,three,four,five,six,seven,eight,nine";
    // // Constants for the names of the tens
    // string private constant TENS_NAMES =
    //     "ten,twenty,thirty,forty,fifty,sixty,seventy,eighty,ninety";
    // // Constants for the names of the teens
    // string private constant TEEN_NAMES =
    //     "eleven,twelve,thirteen,fourteen,fifteen,sixteen,seventeen,eighteen,nineteen";
    // // Constant for the max number of digits that the library can convert
    // uint private constant MAX_DIGITS = 15;

    // // Converts a number to its word representation
    // function toWords(uint256 _number) public view returns (string memory) {
    //     if (_number > 10 ** MAX_DIGITS) {
    //         // Return an empty string if the number is too large
    //         return "";
    //     }
    //     if (_number == 0) {
    //         // Return "zero" for 0
    //         return "zero";
    //     }
    //     string memory result = "";
    //     uint num = _number;
    //     uint[] memory digits = new uint[](MAX_DIGITS);
    //     uint numDigits = 0;
    //     // Split the number into its digits
    //     while (num > 0) {
    //         digits[numDigits] = num % 10;
    //         num = num / 10;
    //         numDigits++;
    //     }

    //     // Convert the digits to words, starting with the highest place value
    //     for (uint j = numDigits; j > 0; j--) {
    //         uint i = j - 1;
    //         uint digit = digits[i];

    //         if (i == 9) {
    //             // Billion
    //             if (digit > 0) {
    //                 result = result.concat(convertDigit(digit)).concat(" billion ");
    //             }
    //         } else if (i == 6) {
    //             // Million
    //             if (digit > 0) {
    //                 result = result.concat(convertDigit(digit)).concat(" million ");
    //             }
    //         } else if (i == 3) {
    //             // Thousand
    //             if (digit > 0) {
    //                 result = result.concat(convertDigit(digit)).concat(" thousand ");
    //             }
    //         } else if (i == 2) {
    //             // Hundred
    //             if (digit > 0) {
    //                 result = result.concat(convertDigit(digit)).concat(" hundred ");
    //             }
    //         } else if (i == 1) {
    //             // Ten
    //             if (digit > 1) {
    //                 result = result.concat(convertTens(digit));
    //             } else if (digit == 1) {
    //                 uint firstDigit = digits[0];
    //                 if (firstDigit == 0) {
    //                     result = result.concat(convertTens(digit));
    //                 } else {
    //                     result = result.concat(convertTeens(digits[0]));
    //                 }
    //                 break;
    //             }
    //         } else if (i == 0) {
    //             // One
    //             if (digit > 0) {
    //                 if (result.length() != 0) {
    //                     result = result.concat(" ");
    //                 }
    //                 result = result.concat(convertDigit(digit));
    //             }
    //         }
    //     }

    //     return result;
    // }

    // // Converts a single digit to its word representation
    // function convertDigit(uint _digit) private pure returns (string memory) {
    //     string[] memory digitNames = DIGIT_NAMES.split(",");
    //     return digitNames[_digit];
    // }

    // // Converts a number in the tens place to its word representation
    // function convertTens(uint _tens) private pure returns (string memory) {
    //     string[] memory tensNames = TENS_NAMES.split(",");
    //     return tensNames[_tens - 1];
    // }

    // // Converts a number in the teens to its word representation
    // function convertTeens(uint _teen) private pure returns (string memory) {
    //     string[] memory teenNames = TEEN_NAMES.split(",");
    //     return teenNames[_teen - 1];
    // }

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

    function toWords(uint number) public view returns (string memory) {
        require(number < MAX, "Number cannot be higher than 9007199254740992");
        string memory words = "";
        uint num = number;

        words = generateWords(num, words);
        return words;
    }

    function generateWords(uint number, string memory words) private view returns (string memory) {
        uint remainder;
        string memory word;

        // We’re done
        if (number == 0) {
            if (words.length() == uint(0)) {
                return "zero";
            } else {
                // string memory returnVal = "";
                // for (uint i = 0; i < words.length; i++) {
                //     string memory tempWord = words[i];
                //     tempWord = tempWord.concat(" ");
                //     returnVal = returnVal.concat(tempWord);
                // }

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
