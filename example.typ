// Example file for auto-pinyin
// This file contains all examples from documentation for verification

#import "lib.typ": to-pinyin, to-pinyin-multi, version

#set text(lang: "zh", region: "cn")
#set page(width: auto, height: auto, margin: 1em)

= Auto Pinyin Examples Verification

== Version Information

Version: #version()

== to-pinyin Function Tests

=== Basic Conversion

Test 1: "汉语" (default style: tone-num)\
Expected: ("ha4n", "yu3")\
Result: #to-pinyin("汉语")

Test 2: "汉语" with style "plain"\
Expected: ("han", "yu")\
Result: #to-pinyin("汉语", style: "plain")

Test 3: "汉语" with style "tone-num-end"\
Expected: ("han4", "yu3")\
Result: #to-pinyin("汉语", style: "tone-num-end")

Test 4: "汉语" with style "tone"\
Expected: ("hàn", "yǔ")\
Result: #to-pinyin("汉语", style: "tone")

Test 5: "汉语" with style "first-letter"\
Expected: ("h", "y")\
Result: #to-pinyin("汉语", style: "first-letter")

=== Mixed Content

Test 6: "Hello世界" (mixed content)\
Expected: ("H", "e", "l", "l", "o", "shi4", "jie4")\
Result: #to-pinyin("Hello世界")

Test 7: "Hello世界" with style "plain"\
Expected: ("H", "e", "l", "l", "o", "shi", "jie")\
Result: #to-pinyin("Hello世界", style: "plain")

=== Join Operations

Test 8: "汉语" joined with "" \
Expected: "ha4nyu3"\
Result: #to-pinyin("汉语").join("")

Test 9: "汉语" joined with "|" \
Expected: "ha4n|yu3"\
Result: #to-pinyin("汉语").join("|")

Test 10: "汉语" joined with " " \
Expected: "ha4n yu3"\
Result: #to-pinyin("汉语").join(" ")

=== Override Functionality

Test 11: "重庆" with single char override\
Expected: ("cho2ng", "qi4ng")\
Result: #to-pinyin("重庆", override: (重: "cho2ng"))

Test 12: "重庆大学" with phrase override\
Expected: ("cho2ng", "qi4ng", "da4", "xue2")\
Result: #to-pinyin("重庆大学", override: (重庆: ("cho2ng", "qi4ng")))

Test 13: "重庆大学" with multiple char overrides\
Expected: ("cho2ng", "qi4ng", "da4", "xue2")\
Result: #to-pinyin("重庆大学", override: (重: "cho2ng", 庆: "qi4ng"))

Test 14: "重庆" with override and plain style\
Expected: ("chong", "qing")\
Result: #to-pinyin("重庆", style: "plain", override: (重: "chong"))

Test 15: "重庆" with override and first-letter style\
Expected: ("c", "q")\
Result: #to-pinyin("重庆", style: "first-letter", override: (重: "c"))

=== Array Operations

Test 16: "汉语" array length\
Expected: 2\
Result: #to-pinyin("汉语").len()

Test 17: "汉语" first element\
Expected: "ha4n"\
Result: #to-pinyin("汉语").first()

Test 18: "汉语" last element\
Expected: "yu3"\
Result: #to-pinyin("汉语").last()

=== Long Text

Test 19: "汉语拼音很好用" (longer text)\
Expected: ("ha4n", "yu3", "pi1n", "yi1n", "he3n", "ha3o", "yo4ng")\
Result: #to-pinyin("汉语拼音很好用")

Test 20: "汉语拼音很好用" joined\
Expected: "ha4nyu3pi1nyi1nhe3nha3oyo4ng"\
Result: #to-pinyin("汉语拼音很好用").join("")

== to-pinyin-multi Function Tests

=== Single Character

Test 21: "还" (default style: tone-num)\
Expected: ("ha2i", "hua2n", "fu2")\
Result: #to-pinyin-multi("还")

Test 22: "还" with style "plain"\
Expected: ("hai", "huan", "fu")\
Result: #to-pinyin-multi("还", style: "plain")

Test 23: "还" with style "tone"\
Expected: ("hái", "huán", "fú")\
Result: #to-pinyin-multi("还", style: "tone")

Test 24: "还" with style "tone-num-end"\
Expected: ("hai2", "huan2", "fu2")\
Result: #to-pinyin-multi("还", style: "tone-num-end")

Test 25: "还" with style "first-letter"\
Expected: ("h", "h", "f")\
Result: #to-pinyin-multi("还", style: "first-letter")

Test 26: "还" joined with "|" \
Expected: "ha2i|hua2n|fu2"\
Result: #to-pinyin-multi("还").join("|")

Test 27: "还" first reading\
Expected: "ha2i"\
Result: #to-pinyin-multi("还").first()

=== Multiple Characters

Test 28: "还没" (multiple characters)\
Expected: (("ha2i", "hua2n", "fu2"), ("me2i", "mo4", "me"))\
Result: #to-pinyin-multi("还没")

Test 29: "还没" first char readings\
Expected: ("ha2i", "hua2n", "fu2")\
Result: #to-pinyin-multi("还没").at(0)

Test 30: "还没" second char first reading\
Expected: "me2i"\
Result: #to-pinyin-multi("还没").at(1).first()

=== Non-Chinese Characters

Test 31: "a" (non-Chinese)\
Expected: ("a",)\
Result: #to-pinyin-multi("a")

Test 32: "123" (numbers)\
Expected: (("1",), ("2",), ("3",))\
Result: #to-pinyin-multi("123")

== Edge Cases

Test 33: Empty string\
Expected: ()\
Result: #to-pinyin("")

Test 34: Single Chinese character "中"\
Expected: ("zho1ng",)\
Result: #to-pinyin("中")

Test 35: Single non-Chinese character "a"\
Expected: ("a",)\
Result: #to-pinyin("a")

Test 36: String with spaces "汉 语"\
Expected: ("ha4n", " ", "yu3")\
Result: #to-pinyin("汉 语")

== Complete Examples from README

Example 1: Basic usage\
#to-pinyin("汉语拼音")

Example 2: With plain style\
#to-pinyin("汉语拼音", style: "plain")

Example 3: Custom formatting\
#to-pinyin("汉语拼音").join(" - ")

Example 4: Polyphonic character handling\
#to-pinyin("重庆", override: (重: "cho2ng"))

Example 5: Phrase override\
#to-pinyin("重庆大学", override: (重庆: ("cho2ng", "qi4ng")))

Example 6: Multiple readings exploration\
#to-pinyin-multi("还").join(", ")
