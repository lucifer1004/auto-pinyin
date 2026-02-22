use std::fs;
use std::path::Path;
use std::process::Command;

fn main() {
    // ==================== Read version from typst.toml ====================
    let typst_toml_path = Path::new("../typst.toml");

    let auto_pinyin_version = if typst_toml_path.exists() {
        match fs::read_to_string(typst_toml_path) {
            Ok(content) => {
                // Parse version from typst.toml
                // Looking for: version = "X.Y.Z"
                let version = content
                    .lines()
                    .find(|line| line.trim().starts_with("version"))
                    .and_then(|line| {
                        let parts: Vec<&str> = line.split('=').collect();
                        if parts.len() == 2 {
                            let version_str = parts[1].trim();
                            // Remove quotes
                            Some(version_str.trim_matches('"').to_string())
                        } else {
                            None
                        }
                    });

                match version {
                    Some(v) => {
                        println!("cargo:rustc-env=AUTO_PINYIN_VERSION={}", v);
                        v
                    }
                    None => {
                        println!("cargo:warning=Could not parse version from typst.toml, using 'unknown'");
                        println!("cargo:rustc-env=AUTO_PINYIN_VERSION=unknown");
                        "unknown".to_string()
                    }
                }
            }
            Err(e) => {
                println!(
                    "cargo:warning=Failed to read typst.toml: {}, using 'unknown' for version",
                    e
                );
                println!("cargo:rustc-env=AUTO_PINYIN_VERSION=unknown");
                "unknown".to_string()
            }
        }
    } else {
        println!("cargo:warning=typst.toml not found, using 'unknown' for version");
        println!("cargo:rustc-env=AUTO_PINYIN_VERSION=unknown");
        "unknown".to_string()
    };

    // Rerun if typst.toml changes
    if typst_toml_path.exists() {
        println!("cargo:rerun-if-changed={}", typst_toml_path.display());
    }

    // ==================== Get rust-pinyin commit id ====================
    let rust_pinyin_dir = Path::new("../rust-pinyin");

    let commit_id = if rust_pinyin_dir.exists() {
        // Try to get the git commit id of rust-pinyin
        match Command::new("git")
            .args(&["rev-parse", "HEAD"])
            .current_dir(rust_pinyin_dir)
            .output()
        {
            Ok(output) => {
                if output.status.success() {
                    String::from_utf8_lossy(&output.stdout).trim().to_string()
                } else {
                    println!("cargo:warning=Git command failed, using 'unknown' for commit id");
                    "unknown".to_string()
                }
            }
            Err(e) => {
                println!(
                    "cargo:warning=Failed to execute git: {}, using 'unknown' for commit id",
                    e
                );
                "unknown".to_string()
            }
        }
    } else {
        println!("cargo:warning=rust-pinyin directory not found, using 'unknown' for commit id");
        "unknown".to_string()
    };

    // Set the environment variable for rust-pinyin commit
    println!("cargo:rustc-env=RUST_PINYIN_COMMIT={}", commit_id);

    // Rerun build.rs if git HEAD changes
    let git_head = rust_pinyin_dir.join(".git/HEAD");
    if git_head.exists() {
        println!("cargo:rerun-if-changed={}", git_head.display());
    }

    // Also rerun if the build script itself changes
    println!("cargo:rerun-if-changed=build.rs");

    // Print info for debugging
    println!("cargo:warning=auto-pinyin version: {}", auto_pinyin_version);
    println!("cargo:warning=rust-pinyin commit: {}", commit_id);
}
