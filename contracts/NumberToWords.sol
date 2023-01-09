// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Strings.sol";

// This library converts numbers to words in English

library NumberToWords {
    using SafeMath for uint;
    using Strings for string;

    // Constants for the names of the digits
    string private constant DIGIT_NAMES = "zero,one,two,three,four,five,six,seven,eight,nine";
    // Constants for the names of the tens
    string private constant TENS_NAMES =
        "ten,twenty,thirty,forty,fifty,sixty,seventy,eighty,ninety";
    // Constants for the names of the teens
    string private constant TEEN_NAMES =
        "eleven,twelve,thirteen,fourteen,fifteen,sixteen,seventeen,eighteen,nineteen";
    // Constant for the max number of digits that the library can convert
    uint private constant MAX_DIGITS = 15;

    // Converts a number to its word representation
    function toWords(uint _number) public view returns (string memory) {
        if (_number > 10 ** MAX_DIGITS) {
            // Return an empty string if the number is too large
            return "";
        }
        if (_number == 0) {
            // Return "zero" for 0
            return "zero";
        }
        string memory result = "";
        uint num = _number;
        uint[] memory digits = new uint[](MAX_DIGITS);
        uint numDigits = 0;
        // Split the number into its digits
        while (num > 0) {
            digits[numDigits] = num % 10;
            num = num / 10;
            numDigits++;
        }

        // Convert the digits to words, starting with the highest place value
        for (uint i = numDigits - 1; i < MAX_DIGITS; i--) {
            uint digit = digits[i];
            if (i == 9) {
                // Billion
                if (digit > 0) {
                    result = string(abi.encodePacked(result, convertDigit(digit), " billion"));
                }
            } else if (i == 6) {
                // Million
                if (digit > 0) {
                    result = string(abi.encodePacked(result, convertDigit(digit), " million"));
                }
            } else if (i == 3) {
                // Thousand
                if (digit > 0) {
                    result = string(abi.encodePacked(result, convertDigit(digit), " thousand"));
                }
            } else if (i == 2) {
                // Hundred
                if (digit > 0) {
                    result = string(abi.encodePacked(result, convertDigit(digit), " hundred"));
                }
            } else if (i == 1) {
                // Ten
                if (digit > 1) {
                    result = string(abi.encodePacked(result, convertTens(digit)));
                } else if (digit == 1) {
                    result = string(abi.encodePacked(result, convertTeens(digits[0])));
                    break;
                }
            } else if (i == 0) {
                // One
                if (digit > 0) {
                    result = string(abi.encodePacked(result, convertDigit(digit)));
                }
            }
        }
        return result;
    }

    // Converts a single digit to its word representation
    function convertDigit(uint _digit) private view returns (string memory) {
        string[] memory digitNames = DIGIT_NAMES.split(",");
        return digitNames[_digit];
    }

    // Converts a number in the tens place to its word representation
    function convertTens(uint _tens) private view returns (string memory) {
        string[] memory tensNames = TENS_NAMES.split(",");
        return tensNames[_tens - 1];
    }

    // Converts a number in the teens to its word representation
    function convertTeens(uint _teen) private view returns (string memory) {
        string[] memory teenNames = TEEN_NAMES.split(",");
        return teenNames[_teen - 1];
    }
}
