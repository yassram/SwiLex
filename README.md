<p align="center">
    <img src="SwiLex.png" width="45%" alt=“SwiLex”/>
    <br>
    <img src="https://img.shields.io/badge/Swift-5.2-orange.svg"/>
    <img src="https://img.shields.io/badge/swiftpm-compatible-brightgreen.svg"/>
    <img src="https://img.shields.io/badge/platforms-iOS%20|%20macOS%20|%20Linux-brightgreen.svg"/>
    <a href="https://github.com/yassram/SwiLex/actions">
        <img src="https://github.com/yassram/SwiLex/workflows/TestSuite/badge.svg"/>
    </a>
    <a href="https://twitter.com/ramsserio">
        <img src="https://img.shields.io/badge/twitter-@ramsserio-blue.svg"/>
    </a>
    <br>
<strong>A universal lexer library in Swift.</strong>
</p>

- [Introduction](#introduction)
- [Installation](#installation)
- [Usage](#usage)
    - [Simple Lexer example](#simple-lexer-example)
    - [Conditianal tokens Lexer example](#conditianal-tokens-lexer-example)
- [Documentation](#documentation)
- [Features](#features)
- [Contributing](#contributing)
- [Author](#author)
- [License](#license)


## Introduction
In computer science a Lexer or a tokenizer is a program that converts a sequence of characters (raw string) into a sequence of tokens. 

SwiLex is a universal lexer which means that you can use it to build *any* lexer only by defining your tokens in a Swift enum (in few lines of code). 

*Combined with **SwiParse** it allows to build a full Parser. ([learn more](https://github.com/yassram/SwiParse/))*

## Installation
SwiLex is distributed as a Swift Package using [SPM](https://swift.org/package-manager/).

To install SwiLex, add the following line to the `dependencies` list in your `Package.swift`:

```swift
.package(url: "https://github.com/yassram/SwiLex.git", .upToNextMinor(from: "1.1.0")),
```

*SwiLex will support other dependency managers soon.*

## Usage

Import SwiLex to use it:

```swift
import SwiLex
```

### Simple Lexer example

Define a SwiLaxable enum to list your possible tokens with their corresponding regular expressions:

```swift 
enum WordNumberTokens: String, SwiLexable {
    static var separators: Set<Character> = [" "]
    
    case text = "[A-Za-z]*"
    case number = "[0-9]*"
    
    case eof
    case none
}
```

Then create an instance of SwiLex and call the lex function:

```swift
var lexer = SwiLex<WordNumberTokens>()
let tokenList = try lexer.lex(input: "  H3Ll0   W0r 1d  1234 aBcD ")

// returns [text[H], number[3], text[Ll], number[0], text[W], number[0], 
//          text[r], number[1], text[d], number[1234], text[aBcD]]
```

This will return a list of tokens with the type of the token and its value (the matched string).

### Conditianal tokens Lexer example

SwiLex provides a mechanism for conditionally activating tokens. This tokens are only available for specific `Mode`.

In the following example we want to make the `.quotedString` token available only when the `.quote` mode is active.

Start by defining the possible `Mode`s.

```swift 
enum Modes {
    case normal
    case quote
}
```

Then define a SwiLaxable enum to list the possible tokens with their corresponding regular expressions (like for a simple Lexer):

```swift 
enum QuotedStringTextNumberTokens: String, SwiLexable {
    static var separators: Set<Character> = [" "]
    
    case text = "[A-Za-z]*"
    case number = "[0-9]*"
    case doubleQuote = "\""
    case quotedString = #"[^"]*"#
    
    case eof
    case none
}
```

Next, define the tokens' availability for the possible modes by implementing the `activeForModes` property:

```swift
extension QuotedStringTextNumberTokens {
var activeForModes: Set<Modes> {
    switch self {
        case .doubleQuote:
            return [.quote, .normal]
        case .quotedString:
            return [.quote]
        default:
            return [.normal]
        }
    }
}
```
> - `.doubleQuote` is available for both `.normal` and `.quote` modes allowing to switch between them (by defining the end and the begining of a quote).<br>
> - `.quotedString` is only available for the `.quote` mode.<br>
> - All the other tokens are only availbale for the `.normal` mode. 

The last step is to tell when to change the curent mode. 

For that implement the function `changeMode(current mode: Modes?) -> Modes?`:

```swift
extension QuotedStringTextNumberTokens {
    func changeMode(current mode: Modes?) -> Modes? {
        switch self {
        case .doubleQuote:
            return mode == .normal ? .quote : .normal
        default:
            return mode
        }
    }
}
```

Finally create an instance of SwiLex and call the lex function with the initial mode:

```swift
let input = #"4lb3rt Einstein said "If you can't explain it to a 6 year old, you don't understand it yourself.""#

var lexer = SwiLex<QuotedStringTextNumberTokens>()
let tokenList = try lexer.lex(input: input, initialMode: .normal)

// [number[4], text[lb], number[3], text[rt], text[Einstein], text[said], doubleQuote["], 
//  quotedString[If you can't explain it to a 6 year old, you don't understand it yourself.], 
//  doubleQuote["]]

```

This will return a list of tokens with the type of the token and its value (the matched string).

### Documentation
A documentation with more examples is available [here](https://github.com/yassram/SwiLex/wiki)


## Features
- [x] Tokens defined using only a simple `SwiLexable` enum.
- [x] Support conditional tokens with custom modes.
- [x] Support actions on each match by implementing the `onLex(raw: Substring)` function.
- [x] Errors with line number and the issue's substring.
- [ ] Add detailed documentation with more examples.
- [ ] Support Cocoapods and Carthage.
- [x] 🔥 **SwiParse**, a general-purpose parser generator  that can be linked to **SwiLex** to generate a full parser. *([released here](https://github.com/yassram/SwiParse))* 🔥


## Contributing
This is an open source project, so feel free to contribute. How?
- Open an <a href="https://github.com/yassram/SwiLex/issues/new"> issue</a>.
- Send feedback via <a href="mailto:ramsserio@gmail.com">email</a>.
- Propose your own fixes, suggestions and open a pull request with the changes.

## Author
Yassir Ramdani

## License

```
MIT License

Copyright (c) 2020 yassir RAMDANI

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
