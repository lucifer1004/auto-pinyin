use pinyin::ToPinyin;
use wasm_minimal_protocol::*;

initiate_protocol!();

/// Convert a single Chinese character to pinyin with tone number
/// Returns the pinyin string (e.g., "ha4n" for "汉")
/// If the character is not a Chinese character, returns the character itself
#[wasm_func]
pub fn char_to_pinyin(input: &[u8]) -> Vec<u8> {
    let s = match std::str::from_utf8(input) {
        Ok(s) => s,
        Err(_) => return input.to_vec(),
    };

    let ch = match s.chars().next() {
        Some(c) => c,
        None => return Vec::new(),
    };

    match ch.to_pinyin() {
        Some(pinyin) => pinyin.with_tone_num().as_bytes().to_vec(),
        None => input.to_vec(),
    }
}

/// Convert a string of Chinese characters to pinyin
/// Returns pinyin strings joined without separator (e.g., "ha4nyu3" for "汉语")
/// Non-Chinese characters are passed through unchanged
#[wasm_func]
pub fn to_pinyin(input: &[u8]) -> Vec<u8> {
    let s = match std::str::from_utf8(input) {
        Ok(s) => s,
        Err(_) => return input.to_vec(),
    };

    let mut result = Vec::new();

    for ch in s.chars() {
        match ch.to_pinyin() {
            Some(pinyin) => {
                result.extend_from_slice(pinyin.with_tone_num().as_bytes());
            }
            None => {
                let mut buf = [0u8; 4];
                result.extend_from_slice(ch.encode_utf8(&mut buf).as_bytes());
            }
        }
    }

    result
}

/// Convert a string of Chinese characters to pinyin with delimiter between each character
/// Returns pinyin strings separated by delimiter (e.g., "ha4n|yu3" for "汉语" with "|" delimiter)
/// Non-Chinese characters are passed through unchanged
#[wasm_func]
pub fn to_pinyin_delimited(input: &[u8], delimiter: &[u8]) -> Vec<u8> {
    let s = match std::str::from_utf8(input) {
        Ok(s) => s,
        Err(_) => return input.to_vec(),
    };

    let mut result = Vec::new();
    let mut first = true;

    for ch in s.chars() {
        if !first {
            result.extend_from_slice(delimiter);
        }
        first = false;

        match ch.to_pinyin() {
            Some(pinyin) => {
                result.extend_from_slice(pinyin.with_tone_num().as_bytes());
            }
            None => {
                let mut buf = [0u8; 4];
                result.extend_from_slice(ch.encode_utf8(&mut buf).as_bytes());
            }
        }
    }

    result
}

// ============================================
// Plain pinyin functions (without tone marks)
// ============================================

/// Convert a single Chinese character to plain pinyin (without tone)
/// Returns the pinyin string (e.g., "han" for "汉")
/// If the character is not a Chinese character, returns the character itself
#[wasm_func]
pub fn char_to_pinyin_plain(input: &[u8]) -> Vec<u8> {
    let s = match std::str::from_utf8(input) {
        Ok(s) => s,
        Err(_) => return input.to_vec(),
    };

    let ch = match s.chars().next() {
        Some(c) => c,
        None => return Vec::new(),
    };

    match ch.to_pinyin() {
        Some(pinyin) => pinyin.plain().as_bytes().to_vec(),
        None => input.to_vec(),
    }
}

/// Convert a string of Chinese characters to plain pinyin (without tone)
/// Returns pinyin strings joined without separator (e.g., "hanyu" for "汉语")
/// Non-Chinese characters are passed through unchanged
#[wasm_func]
pub fn to_pinyin_plain(input: &[u8]) -> Vec<u8> {
    let s = match std::str::from_utf8(input) {
        Ok(s) => s,
        Err(_) => return input.to_vec(),
    };

    let mut result = Vec::new();

    for ch in s.chars() {
        match ch.to_pinyin() {
            Some(pinyin) => {
                result.extend_from_slice(pinyin.plain().as_bytes());
            }
            None => {
                let mut buf = [0u8; 4];
                result.extend_from_slice(ch.encode_utf8(&mut buf).as_bytes());
            }
        }
    }

    result
}

/// Convert a string of Chinese characters to plain pinyin with delimiter between each character
/// Returns pinyin strings separated by delimiter (e.g., "han|yu" for "汉语" with "|" delimiter)
/// Non-Chinese characters are passed through unchanged
#[wasm_func]
pub fn to_pinyin_plain_delimited(input: &[u8], delimiter: &[u8]) -> Vec<u8> {
    let s = match std::str::from_utf8(input) {
        Ok(s) => s,
        Err(_) => return input.to_vec(),
    };

    let mut result = Vec::new();
    let mut first = true;

    for ch in s.chars() {
        if !first {
            result.extend_from_slice(delimiter);
        }
        first = false;

        match ch.to_pinyin() {
            Some(pinyin) => {
                result.extend_from_slice(pinyin.plain().as_bytes());
            }
            None => {
                let mut buf = [0u8; 4];
                result.extend_from_slice(ch.encode_utf8(&mut buf).as_bytes());
            }
        }
    }

    result
}

// ============================================
// Tone pinyin functions (with tone marks)
// ============================================

/// Convert a string of Chinese characters to pinyin with tone marks
/// Returns pinyin strings joined without separator (e.g., "hànyǔ" for "汉语")
/// Non-Chinese characters are passed through unchanged
#[wasm_func]
pub fn to_pinyin_tone(input: &[u8]) -> Vec<u8> {
    let s = match std::str::from_utf8(input) {
        Ok(s) => s,
        Err(_) => return input.to_vec(),
    };

    let mut result = Vec::new();

    for ch in s.chars() {
        match ch.to_pinyin() {
            Some(pinyin) => {
                result.extend_from_slice(pinyin.with_tone().as_bytes());
            }
            None => {
                let mut buf = [0u8; 4];
                result.extend_from_slice(ch.encode_utf8(&mut buf).as_bytes());
            }
        }
    }

    result
}

/// Convert a string of Chinese characters to pinyin with tone marks and delimiter
/// Returns pinyin strings separated by delimiter (e.g., "hàn|yǔ" for "汉语" with "|" delimiter)
/// Non-Chinese characters are passed through unchanged
#[wasm_func]
pub fn to_pinyin_tone_delimited(input: &[u8], delimiter: &[u8]) -> Vec<u8> {
    let s = match std::str::from_utf8(input) {
        Ok(s) => s,
        Err(_) => return input.to_vec(),
    };

    let mut result = Vec::new();
    let mut first = true;

    for ch in s.chars() {
        if !first {
            result.extend_from_slice(delimiter);
        }
        first = false;

        match ch.to_pinyin() {
            Some(pinyin) => {
                result.extend_from_slice(pinyin.with_tone().as_bytes());
            }
            None => {
                let mut buf = [0u8; 4];
                result.extend_from_slice(ch.encode_utf8(&mut buf).as_bytes());
            }
        }
    }

    result
}

// ============================================
// Tone number at end functions
// ============================================

/// Convert a string of Chinese characters to pinyin with tone number at the end
/// Returns pinyin strings joined without separator (e.g., "han4yu3" for "汉语")
/// Non-Chinese characters are passed through unchanged
#[wasm_func]
pub fn to_pinyin_tone_num_end(input: &[u8]) -> Vec<u8> {
    let s = match std::str::from_utf8(input) {
        Ok(s) => s,
        Err(_) => return input.to_vec(),
    };

    let mut result = Vec::new();

    for ch in s.chars() {
        match ch.to_pinyin() {
            Some(pinyin) => {
                result.extend_from_slice(pinyin.with_tone_num_end().as_bytes());
            }
            None => {
                let mut buf = [0u8; 4];
                result.extend_from_slice(ch.encode_utf8(&mut buf).as_bytes());
            }
        }
    }

    result
}

/// Convert a string of Chinese characters to pinyin with tone number at the end and delimiter
/// Returns pinyin strings separated by delimiter (e.g., "han4|yu3" for "汉语" with "|" delimiter)
/// Non-Chinese characters are passed through unchanged
#[wasm_func]
pub fn to_pinyin_tone_num_end_delimited(input: &[u8], delimiter: &[u8]) -> Vec<u8> {
    let s = match std::str::from_utf8(input) {
        Ok(s) => s,
        Err(_) => return input.to_vec(),
    };

    let mut result = Vec::new();
    let mut first = true;

    for ch in s.chars() {
        if !first {
            result.extend_from_slice(delimiter);
        }
        first = false;

        match ch.to_pinyin() {
            Some(pinyin) => {
                result.extend_from_slice(pinyin.with_tone_num_end().as_bytes());
            }
            None => {
                let mut buf = [0u8; 4];
                result.extend_from_slice(ch.encode_utf8(&mut buf).as_bytes());
            }
        }
    }

    result
}

// ============================================
// First letter functions
// ============================================

/// Convert a string of Chinese characters to first letters of pinyin
/// Returns first letters joined without separator (e.g., "hy" for "汉语")
/// Non-Chinese characters are passed through unchanged
#[wasm_func]
pub fn to_pinyin_first_letter(input: &[u8]) -> Vec<u8> {
    let s = match std::str::from_utf8(input) {
        Ok(s) => s,
        Err(_) => return input.to_vec(),
    };

    let mut result = Vec::new();

    for ch in s.chars() {
        match ch.to_pinyin() {
            Some(pinyin) => {
                result.extend_from_slice(pinyin.first_letter().as_bytes());
            }
            None => {
                let mut buf = [0u8; 4];
                result.extend_from_slice(ch.encode_utf8(&mut buf).as_bytes());
            }
        }
    }

    result
}

/// Convert a string of Chinese characters to first letters with delimiter
/// Returns first letters separated by delimiter (e.g., "h|y" for "汉语" with "|" delimiter)
/// Non-Chinese characters are passed through unchanged
#[wasm_func]
pub fn to_pinyin_first_letter_delimited(input: &[u8], delimiter: &[u8]) -> Vec<u8> {
    let s = match std::str::from_utf8(input) {
        Ok(s) => s,
        Err(_) => return input.to_vec(),
    };

    let mut result = Vec::new();
    let mut first = true;

    for ch in s.chars() {
        if !first {
            result.extend_from_slice(delimiter);
        }
        first = false;

        match ch.to_pinyin() {
            Some(pinyin) => {
                result.extend_from_slice(pinyin.first_letter().as_bytes());
            }
            None => {
                let mut buf = [0u8; 4];
                result.extend_from_slice(ch.encode_utf8(&mut buf).as_bytes());
            }
        }
    }

    result
}
