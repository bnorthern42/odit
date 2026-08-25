# Contributing to odit

Thank you for your interest in contributing to `odit`! This guide explains how to set up the development environment, build libgit2, run tests, and submit changes.

---

## Development Setup

### Prerequisites
1. **Odin Compiler**: Make sure `odin` is installed and available in your `PATH`.
2. **CMake (3.15+)** and a C compiler (`gcc` or `clang`).
3. **Dependencies**:
   - Debian/Ubuntu: `sudo apt install build-essential cmake libssl-dev zlib1g-dev`
   - Fedora/RHEL: `sudo dnf install gcc cmake openssl-devel zlib-devel`
   - Arch Linux: `sudo pacman -S base-devel cmake openssl zlib`
   - macOS: `brew install cmake openssl`

---

## Building and Testing

### 1. Build the Static C Library
Before running tests, ensure `libs/build/libgit2.a` is built:

```bash
cd libs
cmake -B build -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTS=OFF -DBUILD_CLI=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON
cmake --build build -j$(nproc)
cd ..
```

### 2. Run the Automated Test Suite
Run all unit tests using the test script or Odin's test runner:

```bash
./tests/run_tests.sh
# or directly:
odin test tests -all-packages
```

### 3. Run the CLI Showcase Demo
Verify that the end-to-end demo application builds and executes:

```bash
odin run main.odin -file
```

---

## Code Guidelines

1. **Exact C ABI Mapping**:
   - Bindings in `odit/*.odin` must faithfully match upstream libgit2 header declarations.
   - Use proper Odin foreign types (`c.int`, `c.uint`, `c.size_t`, `cstring`, `rawptr`, `[^]Type` for C arrays).
2. **Typed Initializers**:
   - When introducing options structs, provide standard typed Odin initializers (e.g. `GIT_MY_OPTIONS_INIT :: git_my_options{version = GIT_MY_OPTIONS_VERSION}`).
3. **Memory Safety & Clean Handles**:
   - Ensure all `git_*_free` and `git_*_dispose` calls are tested in unit tests and showcase code.
4. **No Unrelated Files**:
   - Avoid checking in `.o`, `.a`, `.bin`, or IDE-specific config files.

---

## Submitting Pull Requests

1. Fork the repository and create a feature branch (`git checkout -b feature/my-feature`).
2. Make your changes with clear, descriptive commit messages.
3. Ensure all tests pass (`./tests/run_tests.sh`).
4. Submit a Pull Request targeting the `master` branch using the provided PR template.

---

## Code of Conduct

Please adhere to the [Code of Conduct](CODE_OF_CONDUCT.md) in all community spaces and issue discussions.
