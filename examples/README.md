# odit Examples

This directory contains standalone, runnable examples demonstrating how to use `odit` for common Git operations.

## Available Examples

| Directory | Description |
| :--- | :--- |
| [minimal/](minimal/) | Minimal starter example initializing libgit2 and querying version. |
| [01_init_repo/](01_init_repo/) | Initialize a new repository, stage files to index, and create the root commit. |
| [02_log_revwalk/](02_log_revwalk/) | Traverse commit history with `git_revwalk`, inspect commit metadata and summaries. |
| [03_status_diff/](03_status_diff/) | Check working directory status and compute index-to-workdir diff statistics. |
| [04_branches_tags/](04_branches_tags/) | Create branches, iterate local branches, and create annotated release tags. |
| [05_config_inspect/](05_config_inspect/) | Read, write, and inspect typed Git configuration values (string, bool, int32). |

---

## Running an Example

Each example includes a `build.sh` script, or can be run directly with Odin:

```bash
cd examples/01_init_repo
odin run main.odin -file
```
