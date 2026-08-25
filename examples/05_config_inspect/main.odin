package main

import "core:c"
import "core:fmt"
import "core:os"
import "../../odit"

main :: proc() {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	repo_path: cstring = "/tmp/odit_config_example_repo"
	_ = os.remove_all(string(repo_path))
	defer _ = os.remove_all(string(repo_path))

	repo: ^odit.git_repository
	odit.git_repository_init(&repo, repo_path, 0)
	defer odit.git_repository_free(repo)

	cfg: ^odit.git_config
	odit.git_repository_config(&cfg, repo)
	defer odit.git_config_free(cfg)

	fmt.println("--- Setting Repository Configuration ---")
	// Set strings
	odit.git_config_set_string(cfg, "user.name", "Odin Architect")
	odit.git_config_set_string(cfg, "user.email", "architect@odin-lang.org")
	odit.git_config_set_string(cfg, "init.defaultBranch", "main")

	// Set booleans and integers
	odit.git_config_set_bool(cfg, "core.filemode", 1)
	odit.git_config_set_bool(cfg, "core.bare", 0)
	odit.git_config_set_int32(cfg, "core.repositoryformatversion", 0)

	fmt.println("[+] Configuration values written to $GIT_DIR/config")

	fmt.println("\n--- Reading Configuration Back ---")
	buf: odit.git_buf = odit.GIT_BUF_INIT
	defer odit.git_buf_dispose(&buf)

	if odit.git_config_get_string_buf(&buf, cfg, "user.name") == 0 {
		fmt.printf("  user.name:                 %s\n", buf.ptr)
	}

	odit.git_buf_dispose(&buf)
	if odit.git_config_get_string_buf(&buf, cfg, "user.email") == 0 {
		fmt.printf("  user.email:                %s\n", buf.ptr)
	}

	odit.git_buf_dispose(&buf)
	if odit.git_config_get_string_buf(&buf, cfg, "init.defaultBranch") == 0 {
		fmt.printf("  init.defaultBranch:        %s\n", buf.ptr)
	}

	bval: c.int
	if odit.git_config_get_bool(&bval, cfg, "core.filemode") == 0 {
		fmt.printf("  core.filemode:             %s\n", bval != 0 ? "true" : "false")
	}

	ival: c.int
	if odit.git_config_get_int32(&ival, cfg, "core.repositoryformatversion") == 0 {
		fmt.printf("  repositoryformatversion:   %d\n", ival)
	}
}
