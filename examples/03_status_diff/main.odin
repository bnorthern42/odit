package main

import "core:c"
import "core:fmt"
import "core:os"
import "../../odit"

main :: proc() {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	repo_path: cstring = "/tmp/odit_status_diff_example_repo"
	_ = os.remove_all(string(repo_path))
	defer _ = os.remove_all(string(repo_path))

	repo: ^odit.git_repository
	odit.git_repository_init(&repo, repo_path, 0)
	defer odit.git_repository_free(repo)

	index: ^odit.git_index
	odit.git_repository_index(&index, repo)
	defer odit.git_index_free(index)

	sig: ^odit.git_signature
	odit.git_signature_now(&sig, "Diff Inspector", "diff@example.com")
	defer odit.git_signature_free(sig)

	// Create initial file & commit
	tracked_file := fmt.tprintf("%s/tracked.txt", repo_path)
	_ = os.write_entire_file(tracked_file, transmute([]u8)string("Line 1: Original text\nLine 2: Keep this line\n"))
	odit.git_index_add_bypath(index, "tracked.txt")
	odit.git_index_write(index)

	tree_id: odit.git_oid
	odit.git_index_write_tree(&tree_id, index)
	tree: ^odit.git_tree
	odit.git_tree_lookup(&tree, repo, &tree_id)
	defer odit.git_tree_free(tree)

	commit_id: odit.git_oid
	odit.git_commit_create(&commit_id, repo, "HEAD", sig, sig, nil, "Initial tracked file", tree, 0, nil)

	// Modify tracked file, stage another file, and leave a third untracked
	_ = os.write_entire_file(tracked_file, transmute([]u8)string("Line 1: MODIFIED text\nLine 2: Keep this line\nLine 3: Added line\n"))

	staged_file := fmt.tprintf("%s/staged.txt", repo_path)
	_ = os.write_entire_file(staged_file, transmute([]u8)string("Staged content\n"))
	odit.git_index_add_bypath(index, "staged.txt")
	odit.git_index_write(index)

	untracked_file := fmt.tprintf("%s/untracked.txt", repo_path)
	_ = os.write_entire_file(untracked_file, transmute([]u8)string("Untracked new file\n"))

	// 1. Inspect Status
	fmt.println("--- Working Directory Status ---")
	status_opts: odit.git_status_options = odit.GIT_STATUS_OPTIONS_INIT
	status_opts.show = odit.git_status_show_t.INDEX_AND_WORKDIR
	status_opts.flags = c.uint(odit.git_status_opt_t.INCLUDE_UNTRACKED)

	status_list: ^odit.git_status_list
	odit.git_status_list_new(&status_list, repo, &status_opts)
	defer odit.git_status_list_free(status_list)

	count := odit.git_status_list_entrycount(status_list)
	for i in 0..<count {
		entry := odit.git_status_byindex(status_list, i)
		path := entry.head_to_index != nil ? entry.head_to_index.new_file.path : entry.index_to_workdir.new_file.path
		st := u32(entry.status)

		desc := "UNKNOWN"
		if st & u32(odit.git_status_t.INDEX_NEW) != 0 do desc = "STAGED NEW"
		else if st & u32(odit.git_status_t.WT_MODIFIED) != 0 do desc = "MODIFIED  "
		else if st & u32(odit.git_status_t.WT_NEW) != 0 do desc = "UNTRACKED "

		fmt.printf("  [%s] %s\n", desc, path)
	}

	// 2. Compute Diff Statistics
	fmt.println("\n--- Diff Statistics (index to workdir) ---")
	diff: ^odit.git_diff
	diff_opts: odit.git_diff_options = odit.GIT_DIFF_OPTIONS_INIT
	odit.git_diff_index_to_workdir(&diff, repo, index, &diff_opts)
	defer odit.git_diff_free(diff)

	stats: ^odit.git_diff_stats
	odit.git_diff_get_stats(&stats, diff)
	defer odit.git_diff_stats_free(stats)

	fmt.printf("  Files Changed: %d\n", odit.git_diff_stats_files_changed(stats))
	fmt.printf("  Insertions:    +%d\n", odit.git_diff_stats_insertions(stats))
	fmt.printf("  Deletions:     -%d\n", odit.git_diff_stats_deletions(stats))
}
