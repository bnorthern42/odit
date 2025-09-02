# odit - Odin Bindings for libgit2

**Warning: This project is a major Work In Progress (WIP). Use at your own risk! It may contain bugs, incomplete features, or breaking changes.**

## Description

odit is an unofficial Odin language binding for libgit2, a portable, pure C implementation of Git core methods provided as a linkable library. These bindings are automatically generated using the odin-c-bindgen tool, which analyzes C headers to produce Odin-compatible code. The goal is to provide easy access to Git functionality in Odin projects, starting with core operations like initialization, repository management, and more.

Currently, the bindings cover key libgit2 APIs, but expansion is ongoing. For full libgit2 capabilities (e.g., over 175 API calls for repository management, commit parsing, and thread safety), refer to the upstream documentation.

## Installation

1. **Clone the Repository**:
   ```
   git clone https://your-repo-url/odit.git
   cd odit
   ```

2. **Initialize Submodules**:
   This project vendors libgit2 as a submodule for portability.
   ```
   git submodule update --init --recursive
   ```

3. **Build libgit2**:
   Navigate to the submodule and build it statically (recommended for self-contained binaries):
   ```
   cd libs/libgit2
   mkdir build && cd build
   cmake .. -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release
   cmake --build .
   ```
   This produces `libgit2.a` in the build directory. Adjust CMake flags as needed (e.g., disable features like HTTPS or SSH to reduce dependencies).

4. **Generate Bindings (If Needed)**:
   If you want to regenerate bindings (e.g., for a different libgit2 version), use odin-c-bindgen:
   - Clone it separately: `git clone https://github.com/karl-zylinski/odin-c-bindgen.git`
   - Build: `cd odin-c-bindgen && odin build . -out:bindgen`
   - Run with your `bindgen.sjson`: `./bindgen` (update paths in sjson to point to libgit2 headers).
   Generated files go into the `odit/` directory.

5. **Dependencies**:
   - Odin compiler (latest version recommended).
   - libgit2 dependencies (e.g., zlib, openssl if enabled—install via your package manager like `apt install libz-dev libssl-dev`).

## Usage

Place the `odit/` directory in your Odin project (or use Odin's collections for global access).

Example `main.odin`:
```odin
package main

import "odit"
import "core:fmt"

main :: proc() {
    count := odit.git_libgit2_init()
    fmt.printf("libgit2 initialized with count: %d\n", count)
    // Add more operations, e.g., open a repository
    odit.git_libgit2_shutdown()
}
```

Build your project:
```
odin build . -extra-linker-flags:"-L./libs/build -l:git2.a -lz"
```
(Adjust linker flags for your setup; use `-lgit2` for dynamic linking if preferred.)

For testing:
- Create a test Git repo: `git init /tmp/test-repo`
- Extend the example to call `odit.git_repository_open` and print details.

## Roadmap

- Core initialization and shutdown.
- Version querying.
- Repository open and basic exploration (e.g., branches, status).
- Expand to cloning, committing, etc.
- Add Odin-friendly wrappers for safety and ergonomics.

Contributions welcome! See issues for TODOs.

## Attributions and Licenses

- **libgit2**: This project uses libgit2 (vendored as a submodule at commit 58d9363), licensed under GPLv2 with a Linking Exception. This allows linking from any program, but modifications to libgit2 itself require source distribution. Full terms: [COPYING](https://github.com/libgit2/libgit2/blob/main/COPYING).
- **odin-c-bindgen**: Bindings generated using odin-c-bindgen by Karl Zylinski, inspired by floooh's Sokol bindgen. No specific license mentioned; check the repo for details.

odit itself is licensed under MIT as seen at [LICENSE](LICENSE). Respect upstream licenses in your usage.

## Contributing

Fork, make changes, PR. Focus on tests and portability.

## Disclaimer

As a WIP, expect issues. Not affiliated with libgit2 or odin-c-bindgen maintainers. Report bugs here.
