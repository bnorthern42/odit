package main

import "core:fmt"
import "core:os"
import "../../odit"

main :: proc() {
	// Initialize libgit2 library
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	repo_path: cstring = "/tmp/odit_example_repo"
	_ = os.remove_all(string(repo_path))
	defer _ = os.remove_all(string(repo_path))

	// 1. Initialize a new standard Git repository
	repo: ^odit.git_repository
	if err := odit.git_repository_init(&repo, repo_path, 0); err != 0 {
		fmt.eprintln("Failed to initialize repository")
		return
	}
	defer odit.git_repository_free(repo)
	fmt.printf("[+] Initialized repository at %s\n", repo_path)

	// 2. Create a committer signature
	sig: ^odit.git_signature
	odit.git_signature_now(&sig, "Odin Coder", "odin@example.com")
	defer odit.git_signature_free(sig)

	// 3. Write a file and stage it in the index
	readme_file := fmt.tprintf("%s/README.md", repo_path)
	_ = os.write_entire_file(readme_file, transmute([]u8)string("# Hello from odit!\n\nThis repository was initialized using Odin libgit2 bindings.\n"))

	index: ^odit.git_index
	odit.git_repository_index(&index, repo)
	defer odit.git_index_free(index)

	odit.git_index_add_bypath(index, "README.md")
	odit.git_index_write(index)
	fmt.printf("[+] Staged README.md (Index entries: %d)\n", odit.git_index_entrycount(index))

	// 4. Write tree from index
	tree_id: odit.git_oid
	odit.git_index_write_tree(&tree_id, index)

	tree: ^odit.git_tree
	odit.git_tree_lookup(&tree, repo, &tree_id)
	defer odit.git_tree_free(tree)

	// 5. Create initial root commit
	commit_id: odit.git_oid
	if err := odit.git_commit_create(
		&commit_id,
		repo,
		"HEAD",
		sig,
		sig,
		nil,
		"Initial commit from Odin",
		tree,
		0,
		nil,
	); err != 0 {
		fmt.eprintln("Failed to create commit")
		return
	}

	fmt.printf("[+] Created root commit: %.7s (\"Initial commit from Odin\")\n", odit.git_oid_tostr_s(&commit_id))
}
