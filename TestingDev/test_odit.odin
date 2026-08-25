package test_odit

import "core:c"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:testing"
import "../odit"

cleanup_test_dir :: proc(path: string) {
	_ = os.remove_all(path)
}

@test
test_01_global_init_version_and_features :: proc(t: ^testing.T) {
	count := odit.git_libgit2_init()
	testing.expect(t, count >= 1, "git_libgit2_init should return count >= 1")

	major, minor, rev: c.int
	err := odit.git_libgit2_version(&major, &minor, &rev)
	testing.expect_value(t, err, 0)
	testing.expect_value(t, major, 1)
	testing.expect_value(t, minor, 9)

	features := odit.git_libgit2_features()
	testing.expect(t, features > 0, "features bitmask should be non-zero")

	opts_err := odit.git_libgit2_opts(c.int(odit.git_libgit2_opt_t.SET_SEARCH_PATH), c.int(odit.git_config_level_t.LEVEL_GLOBAL), nil)
	_ = opts_err

	shutdown_count := odit.git_libgit2_shutdown()
	testing.expect(t, shutdown_count >= 0, "shutdown should return count >= 0")
}

@test
test_02_oid_operations :: proc(t: ^testing.T) {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	hex_str: cstring = "4b825dc642cb6eb9a060e54bf8d69288fbee4904"
	oid: odit.git_oid
	err := odit.git_oid_fromstr(&oid, hex_str)
	testing.expect_value(t, err, 0)

	out_hex := odit.git_oid_tostr_s(&oid)
	testing.expect_value(t, string(out_hex), string(hex_str))

	buf: [41]u8
	odit.git_oid_nfmt(cstring(&buf[0]), 41, &oid)
	testing.expect_value(t, string(buf[:40]), string(hex_str))

	oid2: odit.git_oid
	odit.git_oid_fromstr(&oid2, hex_str)
	testing.expect(t, odit.git_oid_equal(&oid, &oid2) != 0, "OIDs should be equal")
	testing.expect_value(t, odit.git_oid_cmp(&oid, &oid2), 0)

	zero_bytes: [20]u8
	zero_oid: odit.git_oid
	odit.git_oid_fromraw(&zero_oid, &zero_bytes[0])
	testing.expect(t, odit.git_oid_is_zero(&zero_oid) != 0, "zero OID should be zero")
}

@test
test_03_buffer_operations :: proc(t: ^testing.T) {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	buf: odit.git_buf = odit.GIT_BUF_INIT
	testing.expect(t, buf.ptr == nil, "buf.ptr should be nil initially")
	testing.expect_value(t, buf.size, 0)

	odit.git_buf_dispose(&buf)
}

@test
test_04_signature_operations :: proc(t: ^testing.T) {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	sig: ^odit.git_signature
	err := odit.git_signature_new(&sig, "Test Author", "author@example.com", 1600000000, 0)
	testing.expect_value(t, err, 0)
	defer odit.git_signature_free(sig)

	testing.expect_value(t, string(sig.name), "Test Author")
	testing.expect_value(t, string(sig.email), "author@example.com")
	testing.expect_value(t, sig._when.time, 1600000000)

	sig_dup: ^odit.git_signature
	err = odit.git_signature_dup(&sig_dup, sig)
	testing.expect_value(t, err, 0)
	defer odit.git_signature_free(sig_dup)

	testing.expect_value(t, string(sig_dup.name), "Test Author")
}

@test
test_05_repository_lifecycle_and_bare :: proc(t: ^testing.T) {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	repo_path := "/tmp/odit_test_05_repo"
	bare_path := "/tmp/odit_test_05_bare_repo"
	cleanup_test_dir(repo_path)
	cleanup_test_dir(bare_path)
	defer cleanup_test_dir(repo_path)
	defer cleanup_test_dir(bare_path)

	repo: ^odit.git_repository
	err := odit.git_repository_init(&repo, cstring(raw_data(repo_path)), 0)
	testing.expect_value(t, err, 0)
	defer odit.git_repository_free(repo)

	testing.expect(t, odit.git_repository_is_bare(repo) == 0, "standard repo is not bare")
	testing.expect(t, odit.git_repository_is_empty(repo) != 0, "new repo should be empty")

	workdir := odit.git_repository_workdir(repo)
	testing.expect(t, workdir != nil, "workdir should exist")

	path := odit.git_repository_path(repo)
	testing.expect(t, path != nil, "git path should exist")

	// Bare repo test
	bare_repo: ^odit.git_repository
	err = odit.git_repository_init(&bare_repo, cstring(raw_data(bare_path)), 1)
	testing.expect_value(t, err, 0)
	defer odit.git_repository_free(bare_repo)

	testing.expect(t, odit.git_repository_is_bare(bare_repo) != 0, "bare repo should report bare")
}

@test
test_06_index_and_blob_operations :: proc(t: ^testing.T) {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	repo_path := "/tmp/odit_test_06_repo"
	cleanup_test_dir(repo_path)
	defer cleanup_test_dir(repo_path)

	repo: ^odit.git_repository
	odit.git_repository_init(&repo, cstring(raw_data(repo_path)), 0)
	defer odit.git_repository_free(repo)

	// Create a blob directly in repository odb
	blob_data := "Hello, libgit2 blob from Odin!"
	blob_oid: odit.git_oid
	err := odit.git_blob_create_from_buffer(&blob_oid, repo, raw_data(blob_data), c.int(len(blob_data)))
	testing.expect_value(t, err, 0)

	blob: ^odit.git_blob
	err = odit.git_blob_lookup(&blob, repo, &blob_oid)
	testing.expect_value(t, err, 0)
	defer odit.git_blob_free(blob)

	blob_size := odit.git_blob_rawsize(blob)
	testing.expect_value(t, blob_size, odit.git_object_size_t(len(blob_data)))

	raw_content := odit.git_blob_rawcontent(blob)
	testing.expect(t, raw_content != nil, "blob raw content should not be nil")

	// Index operations
	index: ^odit.git_index
	err = odit.git_repository_index(&index, repo)
	testing.expect_value(t, err, 0)
	defer odit.git_index_free(index)

	file_path := fmt.tprintf("%s/test.txt", repo_path)
	_ = os.write_entire_file(file_path, transmute([]u8)blob_data)

	err = odit.git_index_add_bypath(index, "test.txt")
	testing.expect_value(t, err, 0)
	testing.expect_value(t, odit.git_index_entrycount(index), 1)

	entry := odit.git_index_get_bypath(index, "test.txt", 0)
	testing.expect(t, entry != nil, "index entry should exist")
	testing.expect_value(t, string(entry.path), "test.txt")

	err = odit.git_index_write(index)
	testing.expect_value(t, err, 0)
}

@test
test_07_tree_and_commit_creation :: proc(t: ^testing.T) {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	repo_path := "/tmp/odit_test_07_repo"
	cleanup_test_dir(repo_path)
	defer cleanup_test_dir(repo_path)

	repo: ^odit.git_repository
	odit.git_repository_init(&repo, cstring(raw_data(repo_path)), 0)
	defer odit.git_repository_free(repo)

	index: ^odit.git_index
	odit.git_repository_index(&index, repo)
	defer odit.git_index_free(index)

	file_path := fmt.tprintf("%s/file.txt", repo_path)
	_ = os.write_entire_file(file_path, transmute([]u8)string("commit test content\n"))
	odit.git_index_add_bypath(index, "file.txt")
	odit.git_index_write(index)

	tree_id: odit.git_oid
	err := odit.git_index_write_tree(&tree_id, index)
	testing.expect_value(t, err, 0)

	tree: ^odit.git_tree
	err = odit.git_tree_lookup(&tree, repo, &tree_id)
	testing.expect_value(t, err, 0)
	defer odit.git_tree_free(tree)

	testing.expect_value(t, odit.git_tree_entrycount(tree), 1)
	tree_entry := odit.git_tree_entry_byname(tree, "file.txt")
	testing.expect(t, tree_entry != nil, "tree entry by name should exist")

	sig: ^odit.git_signature
	odit.git_signature_now(&sig, "Committer", "committer@example.com")
	defer odit.git_signature_free(sig)

	commit_id: odit.git_oid
	err = odit.git_commit_create(
		&commit_id,
		repo,
		"HEAD",
		sig,
		sig,
		nil,
		"Initial commit for test_07\n\nDetailed commit body description.",
		tree,
		0,
		nil,
	)
	testing.expect_value(t, err, 0)

	commit: ^odit.git_commit
	err = odit.git_commit_lookup(&commit, repo, &commit_id)
	testing.expect_value(t, err, 0)
	defer odit.git_commit_free(commit)

	summary := odit.git_commit_summary(commit)
	testing.expect_value(t, string(summary), "Initial commit for test_07")

	body := odit.git_commit_body(commit)
	testing.expect_value(t, string(body), "Detailed commit body description.")

	testing.expect_value(t, odit.git_commit_parentcount(commit), 0)
}

@test
test_08_revwalk_and_branches :: proc(t: ^testing.T) {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	repo_path := "/tmp/odit_test_08_repo"
	cleanup_test_dir(repo_path)
	defer cleanup_test_dir(repo_path)

	repo: ^odit.git_repository
	odit.git_repository_init(&repo, cstring(raw_data(repo_path)), 0)
	defer odit.git_repository_free(repo)

	index: ^odit.git_index
	odit.git_repository_index(&index, repo)
	defer odit.git_index_free(index)

	sig: ^odit.git_signature
	odit.git_signature_now(&sig, "Dev", "dev@example.com")
	defer odit.git_signature_free(sig)

	// Commit 1
	_ = os.write_entire_file(fmt.tprintf("%s/a.txt", repo_path), transmute([]u8)string("A"))
	odit.git_index_add_bypath(index, "a.txt")
	odit.git_index_write(index)

	tree1_id: odit.git_oid
	odit.git_index_write_tree(&tree1_id, index)
	tree1: ^odit.git_tree
	odit.git_tree_lookup(&tree1, repo, &tree1_id)
	defer odit.git_tree_free(tree1)

	commit1_id: odit.git_oid
	odit.git_commit_create(&commit1_id, repo, "HEAD", sig, sig, nil, "Commit 1", tree1, 0, nil)

	// Commit 2
	_ = os.write_entire_file(fmt.tprintf("%s/b.txt", repo_path), transmute([]u8)string("B"))
	odit.git_index_add_bypath(index, "b.txt")
	odit.git_index_write(index)

	tree2_id: odit.git_oid
	odit.git_index_write_tree(&tree2_id, index)
	tree2: ^odit.git_tree
	odit.git_tree_lookup(&tree2, repo, &tree2_id)
	defer odit.git_tree_free(tree2)

	parent1: ^odit.git_commit
	odit.git_commit_lookup(&parent1, repo, &commit1_id)
	defer odit.git_commit_free(parent1)

	parents := [1]^odit.git_commit{parent1}
	commit2_id: odit.git_oid
	odit.git_commit_create(&commit2_id, repo, "HEAD", sig, sig, nil, "Commit 2", tree2, 1, &parents[0])

	// Create Branch
	commit2: ^odit.git_commit
	odit.git_commit_lookup(&commit2, repo, &commit2_id)
	defer odit.git_commit_free(commit2)

	branch_ref: ^odit.git_reference
	err := odit.git_branch_create(&branch_ref, repo, "feature/test-branch", commit2, 0)
	testing.expect_value(t, err, 0)
	defer odit.git_reference_free(branch_ref)

	branch_name: cstring
	odit.git_branch_name(&branch_name, branch_ref)
	testing.expect_value(t, string(branch_name), "feature/test-branch")

	// Revwalk
	walker: ^odit.git_revwalk
	err = odit.git_revwalk_new(&walker, repo)
	testing.expect_value(t, err, 0)
	defer odit.git_revwalk_free(walker)

	odit.git_revwalk_sorting(walker, u32(odit.git_sort_t.TOPOLOGICAL) | u32(odit.git_sort_t.TIME))
	err = odit.git_revwalk_push_head(walker)
	testing.expect_value(t, err, 0)

	walk_id: odit.git_oid
	walk_count := 0
	for odit.git_revwalk_next(&walk_id, walker) == 0 {
		walk_count += 1
	}
	testing.expect_value(t, walk_count, 2)
}

@test
test_09_status_and_diff :: proc(t: ^testing.T) {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	repo_path := "/tmp/odit_test_09_repo"
	cleanup_test_dir(repo_path)
	defer cleanup_test_dir(repo_path)

	repo: ^odit.git_repository
	odit.git_repository_init(&repo, cstring(raw_data(repo_path)), 0)
	defer odit.git_repository_free(repo)

	// Create uncommitted file
	_ = os.write_entire_file(fmt.tprintf("%s/untracked.txt", repo_path), transmute([]u8)string("untracked content"))

	opts: odit.git_status_options = odit.GIT_STATUS_OPTIONS_INIT
	opts.show = odit.git_status_show_t.INDEX_AND_WORKDIR
	opts.flags = c.uint(odit.git_status_opt_t.INCLUDE_UNTRACKED)

	status_list: ^odit.git_status_list
	err := odit.git_status_list_new(&status_list, repo, &opts)
	testing.expect_value(t, err, 0)
	defer odit.git_status_list_free(status_list)

	entry_count := odit.git_status_list_entrycount(status_list)
	testing.expect_value(t, entry_count, 1)

	entry := odit.git_status_byindex(status_list, 0)
	testing.expect(t, entry != nil, "status entry should exist")
	testing.expect(t, u32(entry.status) & u32(odit.git_status_t.WT_NEW) != 0, "status should be WT_NEW")

	// Diff index to workdir
	diff: ^odit.git_diff
	diff_opts: odit.git_diff_options = odit.GIT_DIFF_OPTIONS_INIT
	err = odit.git_diff_index_to_workdir(&diff, repo, nil, &diff_opts)
	testing.expect_value(t, err, 0)
	defer odit.git_diff_free(diff)

	stats: ^odit.git_diff_stats
	err = odit.git_diff_get_stats(&stats, diff)
	testing.expect_value(t, err, 0)
	defer odit.git_diff_stats_free(stats)

	files_changed := odit.git_diff_stats_files_changed(stats)
	testing.expect_value(t, files_changed, 0)
}

@test
test_10_config_and_tags :: proc(t: ^testing.T) {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	repo_path := "/tmp/odit_test_10_repo"
	cleanup_test_dir(repo_path)
	defer cleanup_test_dir(repo_path)

	repo: ^odit.git_repository
	odit.git_repository_init(&repo, cstring(raw_data(repo_path)), 0)
	defer odit.git_repository_free(repo)

	// Config
	cfg: ^odit.git_config
	err := odit.git_repository_config(&cfg, repo)
	testing.expect_value(t, err, 0)
	defer odit.git_config_free(cfg)

	err = odit.git_config_set_string(cfg, "user.name", "Odin Tester")
	testing.expect_value(t, err, 0)

	err = odit.git_config_set_bool(cfg, "core.autocrlf", 0)
	testing.expect_value(t, err, 0)

	buf: odit.git_buf = odit.GIT_BUF_INIT
	defer odit.git_buf_dispose(&buf)

	err = odit.git_config_get_string_buf(&buf, cfg, "user.name")
	testing.expect_value(t, err, 0)
	testing.expect_value(t, string(buf.ptr), "Odin Tester")

	bool_val: c.int
	err = odit.git_config_get_bool(&bool_val, cfg, "core.autocrlf")
	testing.expect_value(t, err, 0)
	testing.expect_value(t, bool_val, 0)

	// Commit and Tag
	index: ^odit.git_index
	odit.git_repository_index(&index, repo)
	defer odit.git_index_free(index)

	_ = os.write_entire_file(fmt.tprintf("%s/tagged.txt", repo_path), transmute([]u8)string("tagged"))
	odit.git_index_add_bypath(index, "tagged.txt")
	odit.git_index_write(index)

	tree_id: odit.git_oid
	odit.git_index_write_tree(&tree_id, index)
	tree: ^odit.git_tree
	odit.git_tree_lookup(&tree, repo, &tree_id)
	defer odit.git_tree_free(tree)

	sig: ^odit.git_signature
	odit.git_signature_now(&sig, "Tagger", "tagger@example.com")
	defer odit.git_signature_free(sig)

	commit_id: odit.git_oid
	odit.git_commit_create(&commit_id, repo, "HEAD", sig, sig, nil, "Commit to tag", tree, 0, nil)

	commit: ^odit.git_commit
	odit.git_commit_lookup(&commit, repo, &commit_id)
	defer odit.git_commit_free(commit)

	tag_oid: odit.git_oid
	err = odit.git_tag_create(&tag_oid, repo, "v1.0.0", (^odit.git_object)(commit), sig, "Release version 1.0.0", 0)
	testing.expect_value(t, err, 0)

	tag: ^odit.git_tag
	err = odit.git_tag_lookup(&tag, repo, &tag_oid)
	testing.expect_value(t, err, 0)
	defer odit.git_tag_free(tag)

	testing.expect_value(t, string(odit.git_tag_name(tag)), "v1.0.0")
	testing.expect_value(t, string(odit.git_tag_message(tag)), "Release version 1.0.0")

	// Delete tag
	err = odit.git_tag_delete(repo, "v1.0.0")
	testing.expect_value(t, err, 0)
}

@test
test_11_odb_operations :: proc(t: ^testing.T) {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	repo_path := "/tmp/odit_test_11_repo"
	cleanup_test_dir(repo_path)
	defer cleanup_test_dir(repo_path)

	repo: ^odit.git_repository
	odit.git_repository_init(&repo, cstring(raw_data(repo_path)), 0)
	defer odit.git_repository_free(repo)

	odb: ^odit.git_odb
	err := odit.git_repository_odb(&odb, repo)
	testing.expect_value(t, err, 0)
	defer odit.git_odb_free(odb)

	data := "Direct ODB custom object content"
	obj_id: odit.git_oid
	err = odit.git_odb_write(&obj_id, odb, raw_data(data), c.int(len(data)), odit.git_object_t.BLOB)
	testing.expect_value(t, err, 0)

	exists := odit.git_odb_exists(odb, &obj_id)
	testing.expect_value(t, exists, 1)

	obj: ^odit.git_odb_object
	err = odit.git_odb_read(&obj, odb, &obj_id)
	testing.expect_value(t, err, 0)
	defer odit.git_odb_object_free(obj)

	obj_size := odit.git_odb_object_size(obj)
	testing.expect_value(t, obj_size, c.int(len(data)))

	obj_type := odit.git_odb_object_type(obj)
	testing.expect_value(t, obj_type, odit.git_object_t.BLOB)
}

@test
test_12_stash_operations :: proc(t: ^testing.T) {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	repo_path := "/tmp/odit_test_12_repo"
	cleanup_test_dir(repo_path)
	defer cleanup_test_dir(repo_path)

	repo: ^odit.git_repository
	odit.git_repository_init(&repo, cstring(raw_data(repo_path)), 0)
	defer odit.git_repository_free(repo)

	index: ^odit.git_index
	odit.git_repository_index(&index, repo)
	defer odit.git_index_free(index)

	sig: ^odit.git_signature
	odit.git_signature_now(&sig, "Stasher", "stasher@example.com")
	defer odit.git_signature_free(sig)

	// Commit baseline
	_ = os.write_entire_file(fmt.tprintf("%s/base.txt", repo_path), transmute([]u8)string("base"))
	odit.git_index_add_bypath(index, "base.txt")
	odit.git_index_write(index)

	tree_id: odit.git_oid
	odit.git_index_write_tree(&tree_id, index)
	tree: ^odit.git_tree
	odit.git_tree_lookup(&tree, repo, &tree_id)
	defer odit.git_tree_free(tree)

	commit_id: odit.git_oid
	odit.git_commit_create(&commit_id, repo, "HEAD", sig, sig, nil, "Base commit", tree, 0, nil)

	// Make uncommitted changes
	_ = os.write_entire_file(fmt.tprintf("%s/base.txt", repo_path), transmute([]u8)string("base modified"))

	stash_id: odit.git_oid
	err := odit.git_stash_save(&stash_id, repo, sig, "Work in progress stash", 0)
	testing.expect_value(t, err, 0)

	// Drop the stash
	err = odit.git_stash_drop(repo, 0)
	testing.expect_value(t, err, 0)
}

@test
test_13_reset_operations :: proc(t: ^testing.T) {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	repo_path := "/tmp/odit_test_13_repo"
	cleanup_test_dir(repo_path)
	defer cleanup_test_dir(repo_path)

	repo: ^odit.git_repository
	odit.git_repository_init(&repo, cstring(raw_data(repo_path)), 0)
	defer odit.git_repository_free(repo)

	index: ^odit.git_index
	odit.git_repository_index(&index, repo)
	defer odit.git_index_free(index)

	sig: ^odit.git_signature
	odit.git_signature_now(&sig, "Resetter", "resetter@example.com")
	defer odit.git_signature_free(sig)

	// Commit 1
	_ = os.write_entire_file(fmt.tprintf("%s/file.txt", repo_path), transmute([]u8)string("v1"))
	odit.git_index_add_bypath(index, "file.txt")
	odit.git_index_write(index)

	tree1_id: odit.git_oid
	odit.git_index_write_tree(&tree1_id, index)
	tree1: ^odit.git_tree
	odit.git_tree_lookup(&tree1, repo, &tree1_id)
	defer odit.git_tree_free(tree1)

	commit1_id: odit.git_oid
	odit.git_commit_create(&commit1_id, repo, "HEAD", sig, sig, nil, "Commit 1", tree1, 0, nil)

	// Commit 2
	_ = os.write_entire_file(fmt.tprintf("%s/file.txt", repo_path), transmute([]u8)string("v2"))
	odit.git_index_add_bypath(index, "file.txt")
	odit.git_index_write(index)

	tree2_id: odit.git_oid
	odit.git_index_write_tree(&tree2_id, index)
	tree2: ^odit.git_tree
	odit.git_tree_lookup(&tree2, repo, &tree2_id)
	defer odit.git_tree_free(tree2)

	parent: ^odit.git_commit
	odit.git_commit_lookup(&parent, repo, &commit1_id)
	defer odit.git_commit_free(parent)

	parents := [1]^odit.git_commit{parent}
	commit2_id: odit.git_oid
	odit.git_commit_create(&commit2_id, repo, "HEAD", sig, sig, nil, "Commit 2", tree2, 1, &parents[0])

	// Soft reset to commit 1
	commit1: ^odit.git_commit
	odit.git_commit_lookup(&commit1, repo, &commit1_id)
	defer odit.git_commit_free(commit1)

	err := odit.git_reset(repo, (^odit.git_object)(commit1), odit.git_reset_t.SOFT, nil)
	testing.expect_value(t, err, 0)

	head_ref: ^odit.git_reference
	odit.git_repository_head(&head_ref, repo)
	defer odit.git_reference_free(head_ref)

	head_oid := odit.git_reference_target(head_ref)
	testing.expect(t, odit.git_oid_equal(head_oid, &commit1_id) != 0, "HEAD points to commit 1 after reset")
}

@test
test_14_notes_operations :: proc(t: ^testing.T) {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	repo_path := "/tmp/odit_test_14_repo"
	cleanup_test_dir(repo_path)
	defer cleanup_test_dir(repo_path)

	repo: ^odit.git_repository
	odit.git_repository_init(&repo, cstring(raw_data(repo_path)), 0)
	defer odit.git_repository_free(repo)

	index: ^odit.git_index
	odit.git_repository_index(&index, repo)
	defer odit.git_index_free(index)

	sig: ^odit.git_signature
	odit.git_signature_now(&sig, "Noter", "noter@example.com")
	defer odit.git_signature_free(sig)

	_ = os.write_entire_file(fmt.tprintf("%s/doc.txt", repo_path), transmute([]u8)string("doc"))
	odit.git_index_add_bypath(index, "doc.txt")
	odit.git_index_write(index)

	tree_id: odit.git_oid
	odit.git_index_write_tree(&tree_id, index)
	tree: ^odit.git_tree
	odit.git_tree_lookup(&tree, repo, &tree_id)
	defer odit.git_tree_free(tree)

	commit_id: odit.git_oid
	odit.git_commit_create(&commit_id, repo, "HEAD", sig, sig, nil, "Commit for note", tree, 0, nil)

	// Create Note
	note_oid: odit.git_oid
	err := odit.git_note_create(&note_oid, repo, nil, sig, sig, &commit_id, "Special note message", 0)
	testing.expect_value(t, err, 0)

	note: ^odit.git_note
	err = odit.git_note_read(&note, repo, nil, &commit_id)
	testing.expect_value(t, err, 0)
	defer odit.git_note_free(note)

	note_msg := odit.git_note_message(note)
	testing.expect_value(t, string(note_msg), "Special note message")

	// Remove Note
	err = odit.git_note_remove(repo, nil, sig, sig, &commit_id)
	testing.expect_value(t, err, 0)
}

@test
test_15_pathspec_and_ignore :: proc(t: ^testing.T) {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	repo_path := "/tmp/odit_test_15_repo"
	cleanup_test_dir(repo_path)
	defer cleanup_test_dir(repo_path)

	repo: ^odit.git_repository
	odit.git_repository_init(&repo, cstring(raw_data(repo_path)), 0)
	defer odit.git_repository_free(repo)

	// Ignore rules
	err := odit.git_ignore_add_rule(repo, "*.tmp\nbuild/\n")
	testing.expect_value(t, err, 0)

	ignored: c.int
	err = odit.git_ignore_path_is_ignored(&ignored, repo, "scratch.tmp")
	testing.expect_value(t, err, 0)
	testing.expect_value(t, ignored, 1)

	err = odit.git_ignore_path_is_ignored(&ignored, repo, "source.odin")
	testing.expect_value(t, err, 0)
	testing.expect_value(t, ignored, 0)

	// Pathspec
	path_str: cstring = "*.odin"
	str_arr := odit.git_strarray{
		strings = &path_str,
		count = 1,
	}

	ps: ^odit.git_pathspec
	err = odit.git_pathspec_new(&ps, &str_arr)
	testing.expect_value(t, err, 0)
	defer odit.git_pathspec_free(ps)

	_ = os.write_entire_file(fmt.tprintf("%s/main.odin", repo_path), transmute([]u8)string("package main\n"))

	match_list: ^odit.git_pathspec_match_list
	err = odit.git_pathspec_match_workdir(&match_list, repo, 0, ps)
	testing.expect_value(t, err, 0)
	defer odit.git_pathspec_match_list_free(match_list)

	match_count := odit.git_pathspec_match_list_entrycount(match_list)
	testing.expect_value(t, match_count, 1)
}

