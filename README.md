# Number To Word Solidity Library

This library was made by refractoring the following number-to-words repository:
https://github.com/marlun78/number-to-words

Contains some util methods for converting numbers into words, ordinal words and ordinal numbers.

## Install
`npm install numbertowords-solidity`

## Usage

### API
#### `toWords(number)`
Converts an integer into words.
```solidity
import "./NumberToWords.sol";

NumberToWords.toWords(13); // => “thirteen”

NumberToWords.toWords(56); // => “fifty-six”

// Large numbers:
NumberToWords.toWords(9007199254740992); // => “nine quadrillion, seven trillion, one hundred ninety-nine billion, two hundred fifty-four million, seven hundred forty thousand, nine hundred ninety-two”
```

## Acknowledgments
* [marlun78/number-to-words](https://github.com/marlun78/number-to-words)

## Thank You
Feel free to contact me at

[![LinkedIn][linkedin-shield]][linkedin-url]

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/muhammad-yassin-abd-rahim-057683109/