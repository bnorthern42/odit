package main

import "core:c"
import "core:fmt"
import "core:os"
import "core:strings"
import "odit"

main :: proc() {
	fmt.println("==================================================")
	fmt.println("  odit - libgit2 Odin Bindings Showcase & Demo   ")
	fmt.println("==================================================")

	// 1. Initialize libgit2
	init_count := odit.git_libgit2_init()
	if init_count < 0 {
		fmt.eprintf("Failed to initialize libgit2\n")
		return
	}
	defer odit.git_libgit2_shutdown()

	major, minor, rev: c.int
	odit.git_libgit2_version(&major, &minor, &rev)
	features := odit.git_libgit2_features()
	fmt.printf("[+] libgit2 initialized (v%d.%d.%d, feature bitmask: 0x%X)\n", major, minor, rev, features)

	// 2. Initialize a temporary repository
	repo_path: cstring = "/tmp/odit_demo_repo"
	os.remove_all(string(repo_path))
	defer os.remove_all(string(repo_path))

	repo: ^odit.git_repository
	if err := odit.git_repository_init(&repo, repo_path, 0); err != 0 {
		print_git_error("git_repository_init failed")
		return
	}
	defer odit.git_repository_free(repo)

	fmt.printf("[+] Initialized new repository at: %s\n", odit.git_repository_path(repo))
	fmt.printf("    Working directory: %s\n", odit.git_repository_workdir(repo))

	// 3. Configure author in repository config
	cfg: ^odit.git_config
	if err := odit.git_repository_config(&cfg, repo); err == 0 {
		odit.git_config_set_string(cfg, "user.name", "Odin Developer")
		odit.git_config_set_string(cfg, "user.email", "developer@odin-lang.org")
		odit.git_config_free(cfg)
		fmt.println("[+] Configured repo user.name and user.email")
	}

	// 4. Create and stage files
	readme_path := fmt.tprintf("%s/README.md", string(repo_path))
	code_path := fmt.tprintf("%s/main.odin", string(repo_path))

	_ = os.write_entire_file(readme_path, transmute([]u8)string("# odit Demo\n\nLibgit2 bindings for Odin!\n"))
	_ = os.write_entire_file(code_path, transmute([]u8)string("package main\n\nimport \"core:fmt\"\n\nmain :: proc() {\n\tfmt.println(\"Hello Odin Git!\")\n}\n"))

	index: ^odit.git_index
	if err := odit.git_repository_index(&index, repo); err != 0 {
		print_git_error("git_repository_index failed")
		return
	}
	defer odit.git_index_free(index)

	odit.git_index_add_bypath(index, "README.md")
	odit.git_index_add_bypath(index, "main.odin")
	odit.git_index_write(index)
	fmt.printf("[+] Staged files in index (entry count: %d)\n", odit.git_index_entrycount(index))

	// 5. Create initial commit
	tree_id: odit.git_oid
	odit.git_index_write_tree(&tree_id, index)

	tree: ^odit.git_tree
	odit.git_tree_lookup(&tree, repo, &tree_id)
	defer odit.git_tree_free(tree)

	sig: ^odit.git_signature
	odit.git_signature_now(&sig, "Odin Developer", "developer@odin-lang.org")
	defer odit.git_signature_free(sig)

	commit1_id: odit.git_oid
	if err := odit.git_commit_create(
		&commit1_id,
		repo,
		"HEAD",
		sig,
		sig,
		nil,
		"Initial commit: add README and main.odin",
		tree,
		0,
		nil,
	); err != 0 {
		print_git_error("git_commit_create failed for commit 1")
		return
	}

	commit1_hex := odit.git_oid_tostr_s(&commit1_id)
	fmt.printf("[+] Created commit 1: %.7s (\"Initial commit: add README and main.odin\")\n", commit1_hex)

	// 6. Create a second commit
	_ = os.write_entire_file(readme_path, transmute([]u8)string("# odit Demo\n\nLibgit2 bindings for Odin!\n\nUpdated with feature additions.\n"))
	odit.git_index_add_bypath(index, "README.md")
	odit.git_index_write(index)

	tree2_id: odit.git_oid
	odit.git_index_write_tree(&tree2_id, index)

	tree2: ^odit.git_tree
	odit.git_tree_lookup(&tree2, repo, &tree2_id)
	defer odit.git_tree_free(tree2)

	parent_commit: ^odit.git_commit
	odit.git_commit_lookup(&parent_commit, repo, &commit1_id)
	defer odit.git_commit_free(parent_commit)

	commit2_id: odit.git_oid
	parents := [1]^odit.git_commit{parent_commit}
	if err := odit.git_commit_create(
		&commit2_id,
		repo,
		"HEAD",
		sig,
		sig,
		nil,
		"Update README.md with feature list",
		tree2,
		1,
		&parents[0],
	); err != 0 {
		print_git_error("commit2 create failed")
		return
	}
	commit2_hex := odit.git_oid_tostr_s(&commit2_id)
	fmt.printf("[+] Created commit 2: %.7s (\"Update README.md with feature list\")\n", commit2_hex)

	// 7. Create a feature branch
	branch_ref: ^odit.git_reference
	commit2_commit: ^odit.git_commit
	odit.git_commit_lookup(&commit2_commit, repo, &commit2_id)
	defer odit.git_commit_free(commit2_commit)

	if err := odit.git_branch_create(&branch_ref, repo, "feature/awesome-git", commit2_commit, 0); err == 0 {
		fmt.printf("[+] Created branch: %s\n", odit.git_reference_name(branch_ref))
		odit.git_reference_free(branch_ref)
	}

	// 8. Revwalk commit history
	fmt.println("\n--- Commit Log (git revwalk) ---")
	walker: ^odit.git_revwalk
	if err := odit.git_revwalk_new(&walker, repo); err == 0 {
		defer odit.git_revwalk_free(walker)

		odit.git_revwalk_sorting(walker, u32(odit.git_sort_t.TOPOLOGICAL) | u32(odit.git_sort_t.TIME))
		push_err := odit.git_revwalk_push(walker, &commit2_id)
		if push_err != 0 {
			print_git_error("revwalk_push failed")
		}

		walk_id: odit.git_oid
		for {
			next_err := odit.git_revwalk_next(&walk_id, walker)
			if next_err != 0 {
				break
			}
			c_obj: ^odit.git_commit
			if odit.git_commit_lookup(&c_obj, repo, &walk_id) == 0 {
				author := odit.git_commit_author(c_obj)
				msg := odit.git_commit_message(c_obj)
				oid_str := odit.git_oid_tostr_s(&walk_id)
				clean_msg := strings.trim_space(string(msg))
				fmt.printf("* %.7s - %s (%s)\n", oid_str, clean_msg, author.name)
				odit.git_commit_free(c_obj)
			}
		}
	}

	// 9. Inspect working directory status
	fmt.println("\n--- Working Directory Status ---")
	test_untracked := fmt.tprintf("%s/notes.txt", string(repo_path))
	_ = os.write_entire_file(test_untracked, transmute([]u8)string("scratch notes\n"))

	status_opts := odit.GIT_STATUS_OPTIONS_INIT
	status_opts.show = .INDEX_AND_WORKDIR
	status_opts.flags = u32(odit.git_status_opt_t.INCLUDE_UNTRACKED)

	status_list: ^odit.git_status_list
	if err := odit.git_status_list_new(&status_list, repo, &status_opts); err == 0 {
		count := odit.git_status_list_entrycount(status_list)
		for i in 0 ..< count {
			entry := odit.git_status_byindex(status_list, c.int(i))
			if entry != nil {
				path := entry.index_to_workdir != nil ? entry.index_to_workdir.new_file.path : entry.head_to_index != nil ? entry.head_to_index.new_file.path : "unknown"
				fmt.printf("  Status [%v]: %s\n", entry.status, path)
			}
		}
		odit.git_status_list_free(status_list)
	}

	fmt.println("==================================================")
	fmt.println("  All odit operations completed successfully!     ")
	fmt.println("==================================================")
}

print_git_error :: proc(context_msg: string) {
	last_err := odit.git_error_last()
	if last_err != nil && last_err.message != nil {
		fmt.eprintf("[!] %s: %s (class: %v)\n", context_msg, last_err.message, last_err.klass)
	} else {
		fmt.eprintf("[!] %s\n", context_msg)
	}
}
