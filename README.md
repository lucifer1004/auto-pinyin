# Easy Pinyin

Write Chinese pinyin easily with automatic pinyin generation from Chinese characters.

## Features

- **Automatic Pinyin Generation**: Convert Chinese characters to pinyin automatically using a WASM plugin
- **Multiple Output Styles**: Support 5 different pinyin output styles:
  - `tone-num`: tone number after vowel (default, e.g., "pi1n")
  - `tone-num-end`: tone number at end (e.g., "pin1")
  - `tone`: with tone marks (e.g., "pīn")
  - `plain`: without tone (e.g., "pin")
  - `first-letter`: first letter only (e.g., "p")
- **Flexible Delimiters**: Add separators between each character's pinyin
- **Pinyin Formatting**: Convert pinyin notation (like `a1`, `e2`) to proper tone marks (like `ɑ̄`, `é`)
- **Ruby Annotation**: Add pinyin above Chinese text easily

## Usage

Import the package:

```typst
#import "@preview/easy-pinyin:0.2.0": pinyin, zhuyin, to-pinyin, auto-zhuyin
```

### Auto-generate Pinyin from Chinese Characters

The `auto-zhuyin` function automatically generates pinyin from Chinese characters:

```typst
// Basic usage - each character with tone numbers (default style)
#auto-zhuyin("汉语拼音")

// Different style options
#auto-zhuyin("汉语拼音", style: "tone-num-end")   // Tone number at end
#auto-zhuyin("汉语拼音", style: "tone")           // With tone marks
#auto-zhuyin("汉语拼音", style: "plain")          // Without tone
#auto-zhuyin("汉语拼音", style: "first-letter")   // First letters only

// With custom scale
#auto-zhuyin("汉语拼音", scale: 0.5)

// With spacing between characters
#auto-zhuyin("汉语拼音", scale: 0.7, spacing: 0.2em)

// Group characters using delimiter
#auto-zhuyin("汉语|拼音", delimiter: "|", spacing: 0.5em)

// Plain pinyin with grouping
#auto-zhuyin("汉语|拼音", style: "plain", delimiter: "|", spacing: 0.5em)

// Override specific characters (useful for polyphonic characters)
#auto-zhuyin("重庆", override: (重: "cho2ng"))  // "重" is "chóng" not "zhòng"
#auto-zhuyin("重庆大学", override: (重: "cho2ng", 庆: "qi4ng"))
```

### Convert Chinese to Pinyin String

Use `to-pinyin` to get the pinyin string with flexible options:

```typst
// Default style "tone-num" (tone number after vowel)
#to-pinyin("汉语")        // Returns "ha4nyu3"
#to-pinyin("中国")        // Returns "zho1ngguo2"
#to-pinyin("Hello世界")   // Returns "Helloshi4jie4"

// Style "tone-num-end" (tone number at end)
#to-pinyin("汉语", style: "tone-num-end")        // Returns "han4yu3"
#to-pinyin("中国", style: "tone-num-end")        // Returns "zhong1guo2"

// Style "tone" (with tone marks)
#to-pinyin("汉语", style: "tone")                // Returns "hànyǔ"
#to-pinyin("中国", style: "tone")                // Returns "zhōngguó"

// Style "plain" (without tone)
#to-pinyin("汉语", style: "plain")               // Returns "hanyu"
#to-pinyin("中国", style: "plain")               // Returns "zhongguo"

// Style "first-letter" (first letter only)
#to-pinyin("汉语", style: "first-letter")        // Returns "hy"
#to-pinyin("中国", style: "first-letter")        // Returns "zg"

// With delimiter between each character
#to-pinyin("汉语拼音", delimiter: "|")           // Returns "ha4n|yu3|pi1n|yi1n"
#to-pinyin("汉语", delimiter: "#")              // Returns "ha4n#yu3"

// Plain pinyin with delimiter
#to-pinyin("汉语拼音", style: "plain", delimiter: "|")  // Returns "han|yu|pin|yin"

// First letter with delimiter
#to-pinyin("汉语拼音", style: "first-letter", delimiter: "|")  // Returns "h|y|p|y"
```

### Manual Pinyin with Tone Formatting

With the `pinyin` function, you can use `a2` to write an `ɑ́`, `o3` to write an `ǒ`, `v4` to represent `ǜ`, etc.

```typst
汉（#pinyin[ha4n]）语（#pinyin[yu3]）拼（#pinyin[pi1n]）音（#pinyin[yi1n]）。
```

### Manual Zhuyin (Ruby Annotation)

With `zhuyin` function, you can put pinyin above the text manually:

```typst
// Single character with pinyin
#zhuyin[汉][ha4n]

// Multiple characters with delimiter
#zhuyin(delimiter: "|")[汉|语|拼|音][ha4n|yu3|pi1n|yi1n]
```

## Complete Example

```typst
#import "@preview/easy-pinyin:0.2.0": *

#set text(lang: "zh", region: "cn")

= Easy Pinyin Demo

== Auto-generate Pinyin

// Default style "tone-num"
#auto-zhuyin("汉语拼音")

// Style "plain" (no tones)
#auto-zhuyin("汉语拼音", style: "plain")

// Style "first-letter"
#auto-zhuyin("汉语拼音", style: "first-letter")

// With styling
#auto-zhuyin("汉语拼音", scale: 0.6, spacing: 0.15em)

// Group by delimiter
#auto-zhuyin("汉语|拼音", delimiter: "|", spacing: 0.5em)

== Pinyin String Conversion

- "汉语" (tone-num) → #to-pinyin("汉语")
- "汉语" (plain) → #to-pinyin("汉语", style: "plain")
- "汉语" (tone-num-end) → #to-pinyin("汉语", style: "tone-num-end")
- "汉语" (first-letter) → #to-pinyin("汉语", style: "first-letter")
- "汉语" (delimited) → #to-pinyin("汉语", delimiter: "|")
- "汉语" (plain + delimited) → #to-pinyin("汉语", style: "plain", delimiter: "|")

== Manual Pinyin Input

汉（#pinyin[ha4n]）语（#pinyin[yu3]）拼（#pinyin[pi1n]）音（#pinyin[yi1n]）。
```

## API Reference

### `to-pinyin(chars, style: "tone-num", delimiter: none)`

Convert Chinese characters to pinyin string.

**Parameters:**
- `chars`: string or content - Chinese characters to convert
- `style`: string (default: `"tone-num"`) - pinyin output style
  - `"tone-num"`: tone number after vowel (e.g., "pi1n")
  - `"tone-num-end"`: tone number at end (e.g., "pin1")
  - `"tone"`: with tone marks (e.g., "pīn")
  - `"plain"`: without tone (e.g., "pin")
  - `"first-letter"`: first letter only (e.g., "p")
- `delimiter`: string or none (default: `none`) - separator between each character's pinyin

**Returns:** string - pinyin representation

**Examples:**
```typst
#to-pinyin("汉语")                                      // → "ha4nyu3"
#to-pinyin("汉语", style: "tone-num-end")               // → "han4yu3"
#to-pinyin("汉语", style: "tone")                       // → "hànyǔ"
#to-pinyin("汉语", style: "plain")                      // → "hanyu"
#to-pinyin("汉语", style: "first-letter")               // → "hy"
#to-pinyin("汉语", delimiter: "|")                      // → "ha4n|yu3"
#to-pinyin("汉语", style: "plain", delimiter: "|")      // → "han|yu"
```

### `auto-zhuyin(doc, style: "tone-num", scale: 0.7, gutter: 0.3em, spacing: none, delimiter: none)`

Add ruby annotation with auto-generated pinyin.

**Parameters:**
- `doc`: string or content - Chinese text
- `style`: string (default: `"tone-num"`) - pinyin output style (same options as `to-pinyin`)
  - `"tone-num"`: tone number after vowel (e.g., "pi1n")
  - `"tone-num-end"`: tone number at end (e.g., "pin1")
  - `"tone"`: with tone marks (e.g., "pīn")
  - `"plain"`: without tone (e.g., "pin")
  - `"first-letter"`: first letter only (e.g., "p")
- `override`: dictionary (default: `(:)`) - character to pinyin mapping for manual override
  - Useful for polyphonic characters (多音字) or special pronunciations
  - Example: `(重: "cho2ng")` to override "重" in "重庆"
- `scale`: number (default: `0.7`) - font size scale for pinyin
- `gutter`: length (default: `0.3em`) - spacing between text and pinyin
- `spacing`: length or none (default: `none`) - spacing between character groups
- `delimiter`: string or none (default: `none`) - character to split input into groups

**Behavior:**
- When `delimiter` is `none` (default), each character gets its own pinyin annotation
- When `delimiter` is specified (e.g., `"|"`), characters between delimiters are grouped together

### `pinyin(doc)`

Convert pinyin notation to proper tone marks.

**Parameters:**
- `doc`: content - content containing pinyin notation

**Supported notations:**
- `a1`, `a2`, `a3`, `a4` → `ɑ̄`, `ɑ́`, `ɑ̌`, `ɑ̀`
- `e1`, `e2`, `e3`, `e4` → `ē`, `é`, `ě`, `è`
- `i1`, `i2`, `i3`, `i4` → `ī`, `í`, `ǐ`, `ì`
- `o1`, `o2`, `o3`, `o4` → `ō`, `ó`, `ǒ`, `ò`
- `u1`, `u2`, `u3`, `u4` → `ū`, `ú`, `ǔ`, `ù`
- `v`, `v1`, `v2`, `v3`, `v4` → `ü`, `ǖ`, `ǘ`, `ǚ`, `ǜ`

### `zhuyin(doc, ruby, scale: 0.7, gutter: 0.3em, delimiter: none, spacing: none)`

Add ruby annotation with manual pinyin.

**Parameters:**
- `doc`: content or string - main text
- `ruby`: content or string - pinyin annotation
- `scale`: number (default: `0.7`) - font size scale
- `gutter`: length (default: `0.3em`) - spacing between text and ruby
- `delimiter`: string or none (default: `none`) - split delimiter
- `spacing`: length or none (default: `none`) - spacing between parts

## Technical Details

This package includes a WASM plugin built with Rust that converts Chinese characters to pinyin using the `rust-pinyin` library. The plugin is automatically loaded when you import the package.

## Development

This project uses [just](https://github.com/casey/just) as a command runner. Install it first if you want to use the convenient commands.

### Setup after Cloning

```bash
# Setup the project (check dependencies, init submodules, build WASM)
just setup
```

### Available Commands

```bash
just --list              # Show all available commands
just build               # Build WASM plugin
just test                # Build and run tests
just test-open           # Run tests and open PDF
just watch               # Watch for changes and recompile
just clean               # Clean build artifacts
just clean-all           # Clean everything including WASM
```

### Manual Build (without just)

If you don't have `just` installed, you can manually build the WASM plugin:

```bash
# Initialize submodules
git submodule update --init --recursive
cd rust-pinyin && git submodule update --init --recursive

# Build WASM
cd wasm
cargo build --release --target wasm32-unknown-unknown
cp target/wasm32-unknown-unknown/release/easy_pinyin_wasm.wasm ../easy-pinyin.wasm

# Run tests
cd ..
typst compile --root . tests/test.typ tests/test.pdf
```

### Requirements

- [Rust](https://rustup.rs/) with `wasm32-unknown-unknown` target
- [typst](https://github.com/typst/typst) for compiling tests
- [just](https://github.com/casey/just) (optional, for convenience)

## LICENSE

MIT, see License file.
