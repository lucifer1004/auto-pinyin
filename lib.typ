// Load the WASM plugin for pinyin conversion
#let _plugin = plugin("easy-pinyin.wasm")

/// Convert a Chinese character string to pinyin string.
///
/// Parameters:
/// - chars: string or content - Chinese characters to convert
/// - style: string (default: "tone-num") - pinyin output style
///   - "tone-num": tone number after vowel (e.g., "pi1n")
///   - "tone-num-end": tone number at end (e.g., "pin1")
///   - "tone": with tone marks (e.g., "pīn")
///   - "plain": without tone (e.g., "pin")
///   - "first-letter": first letter only (e.g., "p")
/// - delimiter: string or none (default: none) - separator between each character's pinyin
///
/// Non-Chinese characters are passed through unchanged.
///
/// Examples:
///   #to-pinyin("汉语")                                  // → "ha4nyu3"
///   #to-pinyin("汉语", style: "tone-num-end")           // → "han4yu3"
///   #to-pinyin("汉语", style: "tone")                   // → "hànyǔ"
///   #to-pinyin("汉语", style: "plain")                  // → "hanyu"
///   #to-pinyin("汉语", style: "first-letter")           // → "hy"
///   #to-pinyin("汉语", delimiter: "|")                  // → "ha4n|yu3"
///   #to-pinyin("汉语", style: "plain", delimiter: "|")  // → "han|yu"
#let to-pinyin(chars, style: "tone-num", delimiter: none) = {
  let s = if type(chars) == str { chars } else { chars.text }

  // Select the appropriate plugin function based on style
  let result = if delimiter == none {
    // No delimiter
    if style == "tone-num" {
      str(_plugin.to_pinyin(bytes(s)))
    } else if style == "tone-num-end" {
      str(_plugin.to_pinyin_tone_num_end(bytes(s)))
    } else if style == "tone" {
      str(_plugin.to_pinyin_tone(bytes(s)))
    } else if style == "plain" {
      str(_plugin.to_pinyin_plain(bytes(s)))
    } else if style == "first-letter" {
      str(_plugin.to_pinyin_first_letter(bytes(s)))
    } else {
      panic(
        "Invalid style: "
          + style
          + ". Valid options: tone-num, tone-num-end, tone, plain, first-letter",
      )
    }
  } else {
    // With delimiter
    if style == "tone-num" {
      str(_plugin.to_pinyin_delimited(bytes(s), bytes(str(delimiter))))
    } else if style == "tone-num-end" {
      str(_plugin.to_pinyin_tone_num_end_delimited(bytes(s), bytes(
        str(delimiter),
      )))
    } else if style == "tone" {
      str(_plugin.to_pinyin_tone_delimited(bytes(s), bytes(str(delimiter))))
    } else if style == "plain" {
      str(_plugin.to_pinyin_plain_delimited(bytes(s), bytes(str(delimiter))))
    } else if style == "first-letter" {
      str(_plugin.to_pinyin_first_letter_delimited(bytes(s), bytes(
        str(delimiter),
      )))
    } else {
      panic(
        "Invalid style: "
          + style
          + ". Valid options: tone-num, tone-num-end, tone, plain, first-letter",
      )
    }
  }

  result
}

/// Convert pinyin notation with tone numbers to proper pinyin with tone marks.
/// e.g., "a1" -> "ɑ̄", "e2" -> "é", "v4" -> "ǜ"
#let pinyin(doc) = {
  show "a": [ɑ]
  show "a1": [ɑ̄]
  show "a2": [ɑ́]
  show "a3": [ɑ̌]
  show "a4": [ɑ̀]

  show "e1": [ē]
  show "e2": [é]
  show "e3": [ě]
  show "e4": [è]

  show "i1": [ī]
  show "i2": [í]
  show "i3": [ǐ]
  show "i4": [ì]

  show "o1": [ō]
  show "o2": [ó]
  show "o3": [ǒ]
  show "o4": [ò]

  show "u1": [ū]
  show "u2": [ú]
  show "u3": [ǔ]
  show "u4": [ù]

  show "v": [ü]
  show "v1": [ǖ]
  show "v2": [ǘ]
  show "v3": [ǚ]
  show "v4": [ǜ]

  doc
}

/// Add zhuyin (ruby annotation) above the text with manually specified pinyin.
/// Parameters:
/// - doc: main text content
/// - ruby: zhuyin/pinyin content to display above
/// - scale: font size scale of ruby (default 0.7)
/// - gutter: spacing between doc and ruby (default 0.3em)
/// - delimiter: if not none, split doc and ruby by this character
/// - spacing: spacing between each parts (default none)
/// Internal helper to create a single zhuyin annotation
/// If format-ruby is true, applies pinyin() to the ruby text
#let _make-single-zhuyin(
  doc,
  ruby,
  scale: 0.7,
  gutter: 0.3em,
  format-ruby: true,
) = {
  let ruby-content = if format-ruby { pinyin(ruby) } else { ruby }
  box(align(
    bottom,
    table(
      columns: (auto,),
      align: (center,),
      inset: 0pt,
      stroke: none,
      row-gutter: gutter,
      text(1em * scale, ruby-content),
      doc,
    ),
  ))
}

#let zhuyin(
  doc,
  ruby,
  scale: 0.7,
  gutter: 0.3em,
  delimiter: none,
  spacing: none,
) = {
  if delimiter == none {
    return _make-single-zhuyin(
      doc,
      ruby,
      scale: scale,
      gutter: gutter,
      format-ruby: true,
    )
  }

  let extract-text(thing) = if type(thing) == str { thing } else { thing.text }
  let chars = extract-text(doc).split(delimiter)
  let aboves = extract-text(ruby).split(delimiter)

  if chars.len() != aboves.len() {
    error("count of character and zhuyin is different")
  }

  chars
    .zip(aboves)
    .map(((c, above)) => [#zhuyin(scale: scale)[#c][#above]])
    .join(if spacing != none [#h(spacing)])
}

/// Add zhuyin (ruby annotation) above the text with automatically generated pinyin.
/// This function automatically converts Chinese characters to pinyin using the WASM plugin.
///
/// Parameters:
/// - doc: string or content - Chinese text
/// - style: string (default: "tone-num") - pinyin output style
///   - "tone-num": tone number after vowel (e.g., "pi1n")
///   - "tone-num-end": tone number at end (e.g., "pin1")
///   - "tone": with tone marks (e.g., "pīn")
///   - "plain": without tone (e.g., "pin")
///   - "first-letter": first letter only (e.g., "p")
/// - override: dictionary (default: (:)) - character/phrase to pinyin mapping for manual override
///   - Supports both single characters and multi-character phrases
///   - Uses greedy matching: longer phrases are matched first
///   - Useful for polyphonic characters (多音字) or fixed phrases
///   - Example: (重: "cho2ng") for single character
///   - Example: (重庆: "cho2ngqi4ng") for phrase (displayed as one annotation)
/// - scale: number (default: 0.7) - font size scale for pinyin
/// - gutter: length (default: 0.3em) - spacing between text and pinyin
/// - spacing: length or none (default: none) - spacing between character groups
/// - delimiter: string or none (default: none) - character to split input into groups
///
/// When delimiter is none (default), each character gets its own pinyin annotation.
/// When delimiter is specified (e.g., "|"), characters between delimiters are grouped together.
///
/// Examples:
///   #auto-zhuyin("汉语拼音")                          // Each character with tone number
///   #auto-zhuyin("汉语拼音", style: "plain")          // Each character without tone
///   #auto-zhuyin("汉语|拼音", delimiter: "|")         // Grouped by delimiter
///   #auto-zhuyin("汉语", style: "first-letter")       // First letters only
///   #auto-zhuyin("重庆", override: (重: "cho2ng"))     // Override single character
///   #auto-zhuyin("重庆大学", override: (重庆: "cho2ngqi4ng")) // Override phrase
#let auto-zhuyin(
  doc,
  style: "tone-num",
  override: (:),
  scale: 0.7,
  gutter: 0.3em,
  spacing: none,
  delimiter: none,
) = {
  let extract-text(thing) = if type(thing) == str { thing } else { thing.text }
  let s = extract-text(doc)

  // Decide whether to apply pinyin() formatting based on style
  // - "tone-num": apply pinyin() to convert tone numbers to marks (e.g., "a1" -> "ɑ̄")
  // - "tone-num-end": don't apply pinyin() because tone position is inconsistent
  // - "tone": already has tone marks, no need to apply pinyin()
  // - "plain": no tone info, no need to apply pinyin()
  // - "first-letter": just letters, no need to apply pinyin()
  let format-ruby = (style == "tone-num")

  // Helper: Get all override keys sorted by length (longest first) for greedy matching
  let override-keys-sorted = override.keys().sorted(key: (k) => k.clusters().len()).rev()

  // Helper: Try to match a phrase in override starting at position i
  // Returns (matched-text, pinyin, length) or none
  let try-match-override = (clusters, start-i) => {
    for key in override-keys-sorted {
      let key-clusters = key.clusters()
      let key-len = key-clusters.len()

      // Check if remaining text is long enough
      if start-i + key-len > clusters.len() {
        continue
      }

      // Check if text matches
      let matches = true
      for j in range(key-len) {
        if clusters.at(start-i + j) != key-clusters.at(j) {
          matches = false
          break
        }
      }

      if matches {
        return (key, override.at(key), key-len)
      }
    }
    return none
  }

  // Helper: Get pinyin for a single character (for auto-generation)
  let get-auto-pinyin = (c) => {
    to-pinyin(c, style: style)
  }

  if delimiter == none {
    // Process with phrase override support using greedy matching
    let result = ()
    let clusters = s.clusters()
    let i = 0

    while i < clusters.len() {
      // Try to match a phrase override first (greedy: longest match wins)
      let match-result = try-match-override(clusters, i)

      if match-result != none {
        let (matched-text, pinyin-str, len) = match-result
        result.push(_make-single-zhuyin(
          matched-text,
          pinyin-str,
          scale: scale,
          gutter: gutter,
          format-ruby: format-ruby,
        ))
        i += len
      } else {
        // No override match, use auto-generated pinyin
        let c = clusters.at(i)
        result.push(_make-single-zhuyin(
          c,
          get-auto-pinyin(c),
          scale: scale,
          gutter: gutter,
          format-ruby: format-ruby,
        ))
        i += 1
      }
    }
    return result.join(if spacing != none [#h(spacing)])
  }

  // Process by delimiter
  let groups = s.split(delimiter)
  let result = ()
  for g in groups {
    // Build pinyin for the group with phrase override support
    let group-clusters = g.clusters()
    let pinyin-str = ""
    let i = 0

    while i < group-clusters.len() {
      let match-result = try-match-override(group-clusters, i)

      if match-result != none {
        let (_, pinyin, len) = match-result
        pinyin-str += pinyin
        i += len
      } else {
        pinyin-str += get-auto-pinyin(group-clusters.at(i))
        i += 1
      }
    }

    result.push(_make-single-zhuyin(
      g,
      pinyin-str,
      scale: scale,
      gutter: gutter,
      format-ruby: format-ruby,
    ))
  }
  result.join(if spacing != none [#h(spacing)])
}

/*

#set text(
   lang: "zh", region: "cn",
   font: ("LXGW WenKai", ),
   fallback: false,
)

// Manual pinyin usage (original API)
汉（#pinyin[ha4n]）语（#pinyin[yu3]）拼（#pinyin[pi1n]）音（#pinyin[yi1n]）。

// Auto pinyin conversion
#to-pinyin("汉语拼音")  // Returns "ha4nyu3pi1nyi1n"
#to-pinyin-delimited("汉语拼音", delimiter: "|")  // Returns "ha4n|yu3|pi1n|yi1n"

// Auto zhuyin - each character with its own pinyin
#auto-zhuyin("汉语拼音")

// Auto zhuyin with custom spacing
#auto-zhuyin("汉语拼音", scale: 0.6, spacing: 0.1em)

// Auto zhuyin with grouping
#auto-zhuyin("汉语|拼音", delimiter: "|", spacing: 0.5em)

// Comparison with manual zhuyin
#let per-char(f) = [#f(delimiter: "|")[汉|语|拼|音][ha4n|yu3|pi1n|yi1n]]
#let per-word(f) = [#f(delimiter: "|")[汉语|拼音][ha4nyu3|pi1nyi1n]]
#let all-in-one(f) = [#f[汉语拼音][ha4nyu3pi1nyi1n]]
#let example(f) = (per-char(f), per-word(f), all-in-one(f))

// argument of scale and spacing
#let arguments = ((0.5, none), (0.7, none), (0.7, 0.1em), (1.0, none), (1.0, 0.2em))

#table(
  columns: (auto, auto, auto, auto),
  align: (center + horizon, center, center, center),
  [arguments], [per char], [per word], [all in one],
  ..arguments.map(((scale, spacing)) => (
    text(size: 0.7em)[#scale,#repr(spacing)],
    ..example(zhuyin.with(scale: scale, spacing: spacing))
  )).flatten(),
)

// Auto zhuyin examples
#table(
  columns: (auto, auto, auto),
  align: (center + horizon, center, center, center),
  [function], [result], [notes],
  [auto-zhuyin], [#auto-zhuyin("汉语拼音")], [character by character],
  [auto-zhuyin with spacing], [#auto-zhuyin("汉语拼音", spacing: 0.1em)], [with spacing],
  [auto-zhuyin with delimiter], [#auto-zhuyin("汉语|拼音", delimiter: "|", spacing: 0.5em)], [grouped by delimiter],
)

// */
