package main

import "core:c"
import "core:fmt"
import "core:os"
import "core:time"
import "../../odit"

main :: proc() {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	repo_path: cstring = "/tmp/odit_revwalk_example_repo"
	_ = os.remove_all(string(repo_path))
	defer _ = os.remove_all(string(repo_path))

	repo: ^odit.git_repository
	odit.git_repository_init(&repo, repo_path, 0)
	defer odit.git_repository_free(repo)

	index: ^odit.git_index
	odit.git_repository_index(&index, repo)
	defer odit.git_index_free(index)

	sig: ^odit.git_signature
	odit.git_signature_now(&sig, "Git Explorer", "explorer@odin-lang.org")
	defer odit.git_signature_free(sig)

	// Create 3 commits in sequence
	parent_commit: ^odit.git_commit = nil
	messages := [3]cstring{
		"feat: initialize project scaffolding",
		"docs: add architectural documentation",
		"refactor: optimize parser performance",
	}

	for msg, i in messages {
		filename := fmt.tprintf("%s/file_%d.txt", repo_path, i + 1)
		_ = os.write_entire_file(filename, transmute([]u8)fmt.tprintf("Content for file %d\n", i + 1))
		odit.git_index_add_bypath(index, cstring(raw_data(fmt.tprintf("file_%d.txt", i + 1))))
		odit.git_index_write(index)

		tree_id: odit.git_oid
		odit.git_index_write_tree(&tree_id, index)

		tree: ^odit.git_tree
		odit.git_tree_lookup(&tree, repo, &tree_id)
		defer odit.git_tree_free(tree)

		commit_id: odit.git_oid
		if parent_commit == nil {
			odit.git_commit_create(&commit_id, repo, "HEAD", sig, sig, nil, msg, tree, 0, nil)
		} else {
			parents := [1]^odit.git_commit{parent_commit}
			odit.git_commit_create(&commit_id, repo, "HEAD", sig, sig, nil, msg, tree, 1, &parents[0])
			odit.git_commit_free(parent_commit)
		}

		odit.git_commit_lookup(&parent_commit, repo, &commit_id)
	}
	if parent_commit != nil do odit.git_commit_free(parent_commit)

	// Traverse commit history using revwalk
	fmt.println("--- Commit History (git revwalk) ---")
	walker: ^odit.git_revwalk
	odit.git_revwalk_new(&walker, repo)
	defer odit.git_revwalk_free(walker)

	odit.git_revwalk_sorting(walker, u32(odit.git_sort_t.TIME) | u32(odit.git_sort_t.TOPOLOGICAL))
	odit.git_revwalk_push_head(walker)

	oid: odit.git_oid
	for odit.git_revwalk_next(&oid, walker) == 0 {
		commit: ^odit.git_commit
		if odit.git_commit_lookup(&commit, repo, &oid) == 0 {
			author := odit.git_commit_author(commit)
			summary := odit.git_commit_summary(commit)
			commit_time := time.unix(i64(author._when.time), 0)

			fmt.printf("* \x1b[33m%.7s\x1b[0m - %s (\x1b[36m%s\x1b[0m, %v)\n",
				odit.git_oid_tostr_s(&oid),
				summary,
				author.name,
				commit_time,
			)

			odit.git_commit_free(commit)
		}
	}
}
