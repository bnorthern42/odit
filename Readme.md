# odit - libgit2 Bindings for Odin

`odit` provides comprehensive, high-performance Odin bindings for [libgit2](https://libgit2.org/) (v1.9.0), the portable, pure-C implementation of Git core methods.

With `odit`, you can build custom Git tooling, automate version control workflows, or embed Git capabilities directly into your Odin applications with zero overhead and native C ABI performance.

---

## Features

- **Full libgit2 API Coverage**: Over 65 module bindings covering the entirety of the core libgit2 API:
  - **Repositories & Worktrees**: `git_repository_init`, `git_repository_open`, `git_worktree_*`
  - **Commits & History**: `git_commit_*`, `git_tree_*`, `git_blob_*`, `git_tag_*`
  - **Revision Walking**: `git_revwalk_*` with topological, time, and reverse sorting
  - **Index & Staging**: `git_index_*`, `git_status_*`, `git_status_list_*`
  - **Diffs & Patches**: `git_diff_*`, `git_patch_*`, `git_diff_stats_*`
  - **Branches & References**: `git_branch_*`, `git_reference_*`, `git_reflog_*`
  - **Remotes & Networking**: `git_remote_*`, `git_fetch_*`, `git_push_*`, `git_clone_*`
  - **Configuration**: `git_config_*` on-disk and in-memory management
  - **Merge & Rebase**: `git_merge_*`, `git_rebase_*`, `git_cherrypick_*`, `git_revert_*`
  - **Credentials & Auth**: SSH, HTTPS, userpass, certificate inspection
- **Cross-Platform Support**: Built-in `foreign import lib` definitions for Linux, macOS, and Windows.
- **Type-Safe Initializers**: Idiomatic Odin constant initializers (`GIT_STATUS_OPTIONS_INIT`, `GIT_DIFF_OPTIONS_INIT`, `GIT_CLONE_OPTIONS_INIT`, `GIT_BUF_INIT`, etc.).
- **Automated Test Suite**: Built-in test coverage using Odin's native testing framework.

---

## Project Structure

```text
odit/
├── odit/                # Complete libgit2 Odin package bindings
│   ├── link.odin        # Cross-platform static linking configurations
│   ├── types.odin       # Opaque handles, struct declarations, and types
│   ├── repository.odin  # Repository management
│   ├── commit.odin      # Commit creation, inspection, and lookup
│   ├── revwalk.odin     # Revision graph traversal
│   ├── status.odin      # Working directory and index status
│   ├── diff.odin        # Diffs, hunks, binary deltas, and stats
│   └── ...              # All remaining libgit2 modules (68 files)
├── libs/                # Vendored libgit2 source & build targets
├── main.odin            # Full interactive showcase and CLI demo
├── tests/               # Comprehensive automated test suite & run_tests.sh
└── TestingSandbox/      # Minimal sandbox example with build.sh
```

---

## Quickstart

### 1. Prerequisites
- **Odin compiler** (dev-2024 or newer).
- **CMake** (v3.15+) and a C compiler (`gcc` or `clang`).
- System development libraries:
  - Linux: `libz-dev`, `libssl-dev` (or distro equivalents).
  - macOS: `zlib`, `openssl` (via Homebrew or Xcode command line tools).
  - Windows: Visual Studio Build Tools / MSVC.

### 2. Building libgit2 Statically

Before compiling Odin programs that import `odit`, build the vendored `libgit2` static library:

```bash
cd libs
cmake -B build -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTS=OFF -DBUILD_CLI=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON
cmake --build build -j$(nproc)
cd ..
```

This generates `libs/build/libgit2.a` (or `git2.lib` on Windows), which `odit` links automatically.

### 3. Running the Test Suite

Run the test suite using the included shell script or Odin CLI:

```bash
./tests/run_tests.sh
# or directly:
odin test tests -all-packages
```

### 4. Running the Showcase Demo

Execute the live demonstration program:

```bash
odin run main.odin -file
```

---

## Usage Example

Here is a minimal example demonstrating repository initialization, staging files, committing, and traversing history:

```odin
package main

import "core:fmt"
import "core:os"
import "core:strings"
import "odit"

main :: proc() {
    // 1. Initialize libgit2
    odit.git_libgit2_init()
    defer odit.git_libgit2_shutdown()

    // 2. Initialize a repository
    repo_path: cstring = "/tmp/my_git_repo"
    repo: ^odit.git_repository
    if odit.git_repository_init(&repo, repo_path, 0) != 0 {
        fmt.eprintln("Failed to initialize repository")
        return
    }
    defer odit.git_repository_free(repo)

    // 3. Create a signature
    sig: ^odit.git_signature
    odit.git_signature_now(&sig, "Odin Developer", "dev@example.com")
    defer odit.git_signature_free(sig)

    // 4. Stage a file in the index
    index: ^odit.git_index
    odit.git_repository_index(&index, repo)
    defer odit.git_index_free(index)

    _ = os.write_entire_file("/tmp/my_git_repo/hello.txt", transmute([]u8)string("Hello Odin!"))
    odit.git_index_add_bypath(index, "hello.txt")
    odit.git_index_write(index)

    // 5. Write tree & create commit
    tree_id: odit.git_oid
    odit.git_index_write_tree(&tree_id, index)

    tree: ^odit.git_tree
    odit.git_tree_lookup(&tree, repo, &tree_id)
    defer odit.git_tree_free(tree)

    commit_id: odit.git_oid
    odit.git_commit_create(
        &commit_id,
        repo,
        "HEAD",
        sig,
        sig,
        nil,
        "Initial commit via odit",
        tree,
        0,
        nil,
    )

    fmt.printf("Created commit: %s\n", odit.git_oid_tostr_s(&commit_id))

    // 6. Traverse commits with revwalk
    walker: ^odit.git_revwalk
    odit.git_revwalk_new(&walker, repo)
    defer odit.git_revwalk_free(walker)

    odit.git_revwalk_sorting(walker, u32(odit.git_sort_t.TOPOLOGICAL) | u32(odit.git_sort_t.TIME))
    odit.git_revwalk_push(walker, &commit_id)

    walk_id: odit.git_oid
    for odit.git_revwalk_next(&walk_id, walker) == 0 {
        commit: ^odit.git_commit
        if odit.git_commit_lookup(&commit, repo, &walk_id) == 0 {
            fmt.printf("* %.7s: %s\n", odit.git_oid_tostr_s(&walk_id), odit.git_commit_summary(commit))
            odit.git_commit_free(commit)
        }
    }
}
```

---

## Linking & Platform Configuration

`odit` handles foreign linking via [odit/link.odin](file:///home/bradn4/Projects/Software_Dev/Shell/tutorials/languages/odit/odit/link.odin):

- **Linux**: Links `libs/build/libgit2.a` along with system `z`, `ssl`, `crypto`, and `pthread`.
- **macOS**: Links `libs/build/libgit2.a` along with system `z`, `iconv`, `Security`, `CoreFoundation`, and `pthread`.
- **Windows**: Links `git2.lib` along with system `ws2_32`, `crypt32`, `rpcrt4`, `ole32`, `advapi32`, `shell32`, and `user32`.

To build your project, simply import `odit` and run:

```bash
odin build .
```

---

## License

- **odit**: Released under the [MIT License](LICENSE).
- **libgit2**: Vendored under the [GPLv2 with Linking Exception](https://github.com/libgit2/libgit2/blob/main/COPYING), enabling static and dynamic linking into any application.
