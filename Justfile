# Justfile for typst-easy-pinyin
# Run `just --list` to see available commands

# Default recipe - show available commands
default:
    @just --list

# Initialize git submodules (rust-pinyin and its pinyin-data)
init-submodules:
    git submodule update --init --recursive
    cd rust-pinyin && git submodule update --init --recursive

# Build the WASM plugin
build-wasm:
    cd wasm && cargo build --release --target wasm32-unknown-unknown

# Copy built WASM to root directory
copy-wasm: build-wasm
    cp wasm/target/wasm32-unknown-unknown/release/easy_pinyin_wasm.wasm easy-pinyin.wasm
    @echo "WASM plugin copied to easy-pinyin.wasm"

# Build WASM and copy to root (main build command)
build: copy-wasm

# Run typst tests
test: build
    typst compile --root . tests/test.typ tests/test.pdf
    @echo "Test PDF generated at tests/test.pdf"

# Run typst tests and open the PDF
test-open: test
    open tests/test.pdf

# Watch for changes and recompile tests
watch:
    typst watch --root . tests/test.typ tests/test.pdf

# Clean build artifacts
clean:
    rm -rf wasm/target
    rm -f tests/test.pdf
    rm -f Cargo.lock
    @echo "Cleaned build artifacts"

# Clean everything including the generated WASM
clean-all: clean
    rm -f easy-pinyin.wasm
    @echo "Cleaned all generated files"

# Check if required tools are installed
check-deps:
    @echo "Checking dependencies..."
    @command -v cargo >/dev/null 2>&1 || { echo "Error: cargo is required but not installed."; exit 1; }
    @command -v rustup >/dev/null 2>&1 || { echo "Error: rustup is required but not installed."; exit 1; }
    @command -v typst >/dev/null 2>&1 || { echo "Error: typst is required but not installed."; exit 1; }
    @rustup target list --installed | grep -q "wasm32-unknown-unknown" || { echo "Error: wasm32-unknown-unknown target is not installed. Run: rustup target add wasm32-unknown-unknown"; exit 1; }
    @echo "All dependencies are installed!"

# Setup the project after cloning
setup: check-deps init-submodules build
    @echo "Setup complete! You can now use 'just test' to run tests."

# Build and show WASM file size
build-info: build
    @ls -lh easy-pinyin.wasm
