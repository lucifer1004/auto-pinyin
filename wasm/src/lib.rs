use pinyin::{ToPinyin, ToPinyinMulti};
use wasm_minimal_protocol::*;

initiate_protocol!();

// Version information embedded at compile time
const AUTO_PINYIN_VERSION: &str = env!("AUTO_PINYIN_VERSION");
const RUST_PINYIN_COMMIT: &str = env!("RUST_PINYIN_COMMIT");

// ============================================
// Internal helper functions
// ============================================

/// Convert a single character to pinyin using the provided converter function
fn convert_char<F>(input: &[u8], converter: F) -> Vec<u8>
where
    F: Fn(&pinyin::Pinyin) -> &'static str,
{
    let s = match std::str::from_utf8(input) {
        Ok(s) => s,
        Err(_) => return input.to_vec(),
    };

    let ch = match s.chars().next() {
        Some(c) => c,
        None => return Vec::new(),
    };

    match ch.to_pinyin() {
        Some(pinyin) => converter(&pinyin).as_bytes().to_vec(),
        None => input.to_vec(),
    }
}

/// Convert a single character to multiple pinyin readings (heteronym)
/// Returns readings separated by '|'
fn convert_char_multi<F>(input: &[u8], converter: F) -> Vec<u8>
where
    F: Fn(&pinyin::Pinyin) -> &'static str,
{
    let s = match std::str::from_utf8(input) {
        Ok(s) => s,
        Err(_) => return input.to_vec(),
    };

    let ch = match s.chars().next() {
        Some(c) => c,
        None => return Vec::new(),
    };

    match ch.to_pinyin_multi() {
        Some(multi) => {
            let mut result = Vec::new();
            let mut first = true;
            for pinyin in multi {
                if !first {
                    result.push(b'|');
                }
                first = false;
                result.extend_from_slice(converter(&pinyin).as_bytes());
            }
            result
        }
        None => input.to_vec(),
    }
}

// ============================================
// Single character conversion functions
// ============================================

/// Convert a single Chinese character to pinyin with tone number after vowel
/// Returns the pinyin string (e.g., "ha4n" for "汉")
#[wasm_func]
pub fn char_to_pinyin(input: &[u8]) -> Vec<u8> {
    convert_char(input, |p| p.with_tone_num())
}

/// Convert a single Chinese character to plain pinyin (without tone)
/// Returns the pinyin string (e.g., "han" for "汉")
#[wasm_func]
pub fn char_to_pinyin_plain(input: &[u8]) -> Vec<u8> {
    convert_char(input, |p| p.plain())
}

/// Convert a single Chinese character to pinyin with tone marks
/// Returns the pinyin string (e.g., "hàn" for "汉")
#[wasm_func]
pub fn char_to_pinyin_tone(input: &[u8]) -> Vec<u8> {
    convert_char(input, |p| p.with_tone())
}

/// Convert a single Chinese character to pinyin with tone number at end
/// Returns the pinyin string (e.g., "han4" for "汉")
#[wasm_func]
pub fn char_to_pinyin_tone_num_end(input: &[u8]) -> Vec<u8> {
    convert_char(input, |p| p.with_tone_num_end())
}

/// Convert a single Chinese character to first letter of pinyin
/// Returns the first letter (e.g., "h" for "汉")
#[wasm_func]
pub fn char_to_pinyin_first_letter(input: &[u8]) -> Vec<u8> {
    convert_char(input, |p| p.first_letter())
}

// ============================================
// Heteronym (multi-reading) functions
// ============================================

/// Get all possible pinyin readings for a single Chinese character (heteronym)
/// Returns readings separated by '|' (e.g., "ha2i|huan2|fu2" for "还")
#[wasm_func]
pub fn char_to_pinyin_multi(input: &[u8]) -> Vec<u8> {
    convert_char_multi(input, |p| p.with_tone_num())
}

/// Get all possible plain pinyin readings for a single Chinese character (heteronym)
/// Returns readings separated by '|' (e.g., "hai|huan|fu" for "还")
#[wasm_func]
pub fn char_to_pinyin_multi_plain(input: &[u8]) -> Vec<u8> {
    convert_char_multi(input, |p| p.plain())
}

/// Get all possible pinyin readings with tone marks for a single Chinese character (heteronym)
/// Returns readings separated by '|' (e.g., "hái|huán|fú" for "还")
#[wasm_func]
pub fn char_to_pinyin_multi_tone(input: &[u8]) -> Vec<u8> {
    convert_char_multi(input, |p| p.with_tone())
}

/// Get all possible pinyin readings with tone number at end for a single Chinese character (heteronym)
/// Returns readings separated by '|' (e.g., "hai2|huan2|fu2" for "还")
#[wasm_func]
pub fn char_to_pinyin_multi_tone_num_end(input: &[u8]) -> Vec<u8> {
    convert_char_multi(input, |p| p.with_tone_num_end())
}

/// Get all possible first letters for a single Chinese character (heteronym)
/// Returns letters separated by '|' (e.g., "h|h|f" for "还")
#[wasm_func]
pub fn char_to_pinyin_multi_first_letter(input: &[u8]) -> Vec<u8> {
    convert_char_multi(input, |p| p.first_letter())
}

// ============================================
// Version information
// ============================================

/// Get version information about auto-pinyin and its dependencies
/// Returns formatted version information
#[wasm_func]
pub fn version() -> Vec<u8> {
    format!(
        "auto-pinyin: {}\nrust-pinyin commit: {}",
        AUTO_PINYIN_VERSION, RUST_PINYIN_COMMIT
    )
    .into_bytes()
}
