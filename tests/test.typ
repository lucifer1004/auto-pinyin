// Test file for easy-pinyin with WASM plugin

#import "../lib.typ": auto-zhuyin, pinyin, to-pinyin, zhuyin

#set text(
  lang: "zh",
  region: "cn",
)

#set page(width: auto, height: auto, margin: 1em)

= Easy Pinyin Tests

== Test 1: to-pinyin function (default style: "tone-num")

Test single character:
- "汉" → #to-pinyin("汉")
- "语" → #to-pinyin("语")
- "拼" → #to-pinyin("拼")
- "音" → #to-pinyin("音")

Test multiple characters:
- "汉语拼音" → #to-pinyin("汉语拼音")
- "中国" → #to-pinyin("中国")
- "你好世界" → #to-pinyin("你好世界")

Test mixed content:
- "Hello世界" → #to-pinyin("Hello世界")
- "Java语言" → #to-pinyin("Java语言")

== Test 2: to-pinyin with all style options

Default style ("tone-num"):
- "汉语" → #to-pinyin("汉语", style: "tone-num")
- "中国" → #to-pinyin("中国", style: "tone-num")

Style "tone-num-end" (tone number at end):
- "汉语" → #to-pinyin("汉语", style: "tone-num-end")
- "中国" → #to-pinyin("中国", style: "tone-num-end")
- "你好世界" → #to-pinyin("你好世界", style: "tone-num-end")

Style "tone" (with tone marks):
- "汉语" → #to-pinyin("汉语", style: "tone")
- "中国" → #to-pinyin("中国", style: "tone")

Style "plain" (without tone):
- "汉语" → #to-pinyin("汉语", style: "plain")
- "中国" → #to-pinyin("中国", style: "plain")
- "你好世界" → #to-pinyin("你好世界", style: "plain")

Style "first-letter" (first letter only):
- "汉语" → #to-pinyin("汉语", style: "first-letter")
- "中国" → #to-pinyin("中国", style: "first-letter")
- "汉语拼音" → #to-pinyin("汉语拼音", style: "first-letter")

== Test 3: to-pinyin with delimiter options

With delimiter (default style "tone-num"):
- "汉语拼音" → #to-pinyin("汉语拼音", delimiter: "|")
- "中国" → #to-pinyin("中国", delimiter: "|")

With delimiter and style "plain":
- "汉语拼音" → #to-pinyin("汉语拼音", style: "plain", delimiter: "|")
- "中国" → #to-pinyin("中国", style: "plain", delimiter: "|")

With delimiter and style "tone-num-end":
- "汉语拼音" → #to-pinyin("汉语拼音", style: "tone-num-end", delimiter: "|")

With delimiter and style "first-letter":
- "汉语拼音" → #to-pinyin("汉语拼音", style: "first-letter", delimiter: "|")

Custom delimiter:
- "汉语拼音" with "\#" → #to-pinyin("汉语拼音", delimiter: "\#")
- "汉语拼音" with "," → #to-pinyin("你好世界", delimiter: ",")

== Test 4: auto-zhuyin function (default style: "tone-num")

Basic usage (character by character):
#auto-zhuyin("汉语拼音")

With custom scale:
#auto-zhuyin("汉语拼音", scale: 0.5)

With spacing:
#auto-zhuyin("汉语拼音", scale: 0.7, spacing: 0.2em)

With delimiter for grouping:
#auto-zhuyin("汉语|拼音", delimiter: "|", spacing: 0.5em)

== Test 5: auto-zhuyin with different styles

Style "plain" (no tone numbers):
#auto-zhuyin("汉语拼音", style: "plain")

Style "plain" with custom scale:
#auto-zhuyin("汉语拼音", style: "plain", scale: 0.5)

Style "tone-num-end":
#auto-zhuyin("汉语拼音", style: "tone-num-end")

Style "first-letter":
#auto-zhuyin("汉语拼音", style: "first-letter")

Style "plain" with delimiter grouping:
#auto-zhuyin("汉语|拼音", style: "plain", delimiter: "|", spacing: 0.5em)

== Test 6: Comparison - all styles

Style "tone-num" (default):
#auto-zhuyin("汉语拼音")

Style "tone-num-end":
#auto-zhuyin("汉语拼音", style: "tone-num-end")

Style "tone":
#auto-zhuyin("汉语拼音", style: "tone")

Style "plain":
#auto-zhuyin("汉语拼音", style: "plain")

Style "first-letter":
#auto-zhuyin("汉语拼音", style: "first-letter")

== Test 7: Comparison with manual zhuyin

Manual zhuyin (style "tone-num"):
#zhuyin(delimiter: "|")[汉|语][ha4n|yu3]

Auto zhuyin (style "tone-num"):
#auto-zhuyin("汉语")

Manual zhuyin (style "plain"):
#zhuyin(delimiter: "|")[汉|语][han|yu]

Auto zhuyin (style "plain"):
#auto-zhuyin("汉语", style: "plain")

Manual zhuyin (style "tone-num-end"):
#zhuyin(delimiter: "|")[汉|语][han4|yu3]

Auto zhuyin (style "tone-num-end"):
#auto-zhuyin("汉语", style: "tone-num-end")

== Test 8: Original pinyin function

#pinyin[a1] #pinyin[a2] #pinyin[a3] #pinyin[a4]
#pinyin[e1] #pinyin[e2] #pinyin[e3] #pinyin[e4]
#pinyin[i1] #pinyin[i2] #pinyin[i3] #pinyin[i4]
#pinyin[o1] #pinyin[o2] #pinyin[o3] #pinyin[o4]
#pinyin[u1] #pinyin[u2] #pinyin[u3] #pinyin[u4]
#pinyin[v] #pinyin[v1] #pinyin[v2] #pinyin[v3] #pinyin[v4]

== Test 9: tone-num-end consistency test

This test verifies that tone-num-end style is consistent (no partial pinyin formatting):

#table(
  columns: (auto, auto, auto),
  align: (center + horizon, center, center),
  [Style], [Output], [Notes],
  [tone-num], [#auto-zhuyin("他谈")], [Formatted: ta1n -> tɑ̄n (a1 converted)],
  [tone-num-end],
  [#auto-zhuyin("他谈", style: "tone-num-end")],
  [Raw: ta1, tan1 (no conversion)],
)

Individual comparison for "他" (ta1) and "谈" (tan1):
- tone-num: #auto-zhuyin("他谈") (should show formatted pinyin with tone marks)
- tone-num-end: #auto-zhuyin("他谈", style: "tone-num-end") (should show consistent tone numbers at end)

== Test 10: Complex examples

A sentence with style "tone-num" (default):
#auto-zhuyin("汉语拼音很好用", scale: 0.6, spacing: 0.1em)

A sentence with style "plain":
#auto-zhuyin("汉语拼音很好用", style: "plain", scale: 0.6, spacing: 0.1em)

A sentence with style "first-letter":
#auto-zhuyin("汉语拼音很好用", style: "first-letter", scale: 0.5)

Mixed with normal text (style "tone-num"):
我们学习#auto-zhuyin("中文", scale: 0.6)很有趣。

Mixed with style "plain":
我们学习#auto-zhuyin("中文", style: "plain", scale: 0.6)很有趣。

Mixed with style "first-letter":
我们学习#auto-zhuyin("中文", style: "first-letter", scale: 0.6)很有趣。

== Test 11: Override parameter for polyphonic characters

The override parameter allows manual override of specific characters, useful for polyphonic characters (多音字).

Basic override example - "重庆" (Chóngqìng):
- Without override: #auto-zhuyin("重庆") (重 may be wrong: zho4ng)
- With override: #auto-zhuyin("重庆", override: (重: "cho2ng")) (重 is correct: cho2ng)

Multiple character override:
- Without override: #auto-zhuyin("重庆大学")
- With override: #auto-zhuyin("重庆大学", override: (重: "cho2ng", 庆: "qi4ng"))

Override with different styles:
- Plain style with override: #auto-zhuyin("重庆", style: "plain", override: (重: "chong"))
- First-letter with override: #auto-zhuyin("重庆", style: "first-letter", override: (重: "c"))

Override with delimiter:
- Without override: #auto-zhuyin("重庆|大学", delimiter: "|")
- With override: #auto-zhuyin("重庆|大学", delimiter: "|", override: (重: "cho2ng"))

Comparison table:
#table(
  columns: (auto, auto, auto),
  align: (center + horizon, center, center),
  [Method], [Output], [Notes],
  [Auto], [#auto-zhuyin("重庆")], [May be incorrect],
  [Override], [#auto-zhuyin("重庆", override: (重: "cho2ng"))], [Correct pronunciation],
)
