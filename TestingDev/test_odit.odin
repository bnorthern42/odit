package test_odit

import "core:testing"
import "core:c"
import "core:fmt"
import "core:os"
import "core:strings"
import "../odit"

@test
test_libgit2_init_and_version :: proc(t: ^testing.T) {
	init_count := odit.git_libgit2_init()
	testing.expect(t, init_count >= 1, "Expected libgit2 initialization count >= 1")

	major, minor, rev: c.int
	odit.git_libgit2_version(&major, &minor, &rev)
	testing.expect_value(t, major, 1)
	testing.expect_value(t, minor, 9)

	features := odit.git_libgit2_features()
	testing.expect(t, features != 0, "Expected non-zero libgit2 feature flags")

	shutdown_count := odit.git_libgit2_shutdown()
	testing.expect(t, shutdown_count >= 0, "Expected shutdown count >= 0")
}

@test
test_oid_conversion :: proc(t: ^testing.T) {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	hex_in: cstring = "4b825dc642cb6eb9a060e54bf8d69288fbee4904"
	oid: odit.git_oid
	err := odit.git_oid_fromstr(&oid, hex_in)
	testing.expect_value(t, err, 0)

	hex_out := odit.git_oid_tostr_s(&oid)
	testing.expect(t, strings.compare(string(hex_out), string(hex_in)) == 0, "OID string mismatch")

	short_oid: [8]c.char
	err = odit.git_oid_nfmt(cstring(&short_oid[0]), 8, &oid)
	testing.expect_value(t, err, 0)
	testing.expect(t, strings.has_prefix(string(hex_in), string(cstring(&short_oid[0]))), "Short OID prefix mismatch")
}

@test
test_repo_init_commit_and_walk :: proc(t: ^testing.T) {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	test_repo_path: cstring = "/tmp/test_odit_repo"
	os.remove_all(string(test_repo_path))
	defer os.remove_all(string(test_repo_path))

	repo: ^odit.git_repository
	err := odit.git_repository_init(&repo, test_repo_path, 0)
	testing.expect_value(t, err, 0)
	testing.expect(t, repo != nil, "Repository pointer is nil")
	defer odit.git_repository_free(repo)

	is_bare := odit.git_repository_is_bare(repo)
	testing.expect_value(t, is_bare, 0)

	// Create a dummy file in working directory
	test_file_path := fmt.tprintf("%s/hello.txt", string(test_repo_path))
	write_err := os.write_entire_file(test_file_path, transmute([]u8)string("Hello Odin and Git!\n"))
	testing.expect(t, write_err == nil, "Failed to write test file in repo")

	// Add file to index
	index: ^odit.git_index
	err = odit.git_repository_index(&index, repo)
	testing.expect_value(t, err, 0)
	defer odit.git_index_free(index)

	err = odit.git_index_add_bypath(index, "hello.txt")
	testing.expect_value(t, err, 0)

	entry_count := odit.git_index_entrycount(index)
	testing.expect_value(t, entry_count, 1)

	entry := odit.git_index_get_bypath(index, "hello.txt", 0)
	testing.expect(t, entry != nil, "Index entry was nil")
	testing.expect(t, strings.compare(string(entry.path), "hello.txt") == 0, "Index entry path mismatch")

	tree_id: odit.git_oid
	err = odit.git_index_write_tree(&tree_id, index)
	testing.expect_value(t, err, 0)
	err = odit.git_index_write(index)
	testing.expect_value(t, err, 0)

	tree: ^odit.git_tree
	err = odit.git_tree_lookup(&tree, repo, &tree_id)
	testing.expect_value(t, err, 0)
	defer odit.git_tree_free(tree)

	// Create signature
	sig: ^odit.git_signature
	err = odit.git_signature_now(&sig, "Odin Developer", "odin@example.com")
	testing.expect_value(t, err, 0)
	defer odit.git_signature_free(sig)

	// Create initial commit
	commit_id: odit.git_oid
	err = odit.git_commit_create(
		&commit_id,
		repo,
		"HEAD",
		sig,
		sig,
		nil,
		"Initial commit from Odin bindings",
		tree,
		0,
		nil,
	)
	testing.expect_value(t, err, 0)

	// Lookup created commit
	commit: ^odit.git_commit
	err = odit.git_commit_lookup(&commit, repo, &commit_id)
	testing.expect_value(t, err, 0)
	defer odit.git_commit_free(commit)

	msg := odit.git_commit_message(commit)
	testing.expect(t, strings.has_prefix(string(msg), "Initial commit"), "Commit message mismatch")

	author := odit.git_commit_author(commit)
	testing.expect(t, strings.compare(string(author.name), "Odin Developer") == 0, "Author name mismatch")

	// Revwalk
	walker: ^odit.git_revwalk
	err = odit.git_revwalk_new(&walker, repo)
	testing.expect_value(t, err, 0)
	defer odit.git_revwalk_free(walker)

	err = odit.git_revwalk_push_head(walker)
	testing.expect_value(t, err, 0)

	walked_id: odit.git_oid
	err = odit.git_revwalk_next(&walked_id, walker)
	testing.expect_value(t, err, 0)
	testing.expect(t, odit.git_oid_equal(&walked_id, &commit_id) != 0, "Revwalk OID mismatch")

	// Next walk should hit end of iteration
	err = odit.git_revwalk_next(&walked_id, walker)
	testing.expect_value(t, err, c.int(odit.git_error_code.ITEROVER))
}

@test
test_config_operations :: proc(t: ^testing.T) {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	config_path: cstring = "/tmp/test_odit_config"
	os.remove(string(config_path))
	defer os.remove(string(config_path))

	cfg: ^odit.git_config
	err := odit.git_config_open_ondisk(&cfg, config_path)
	testing.expect_value(t, err, 0)
	defer odit.git_config_free(cfg)

	buf := odit.GIT_BUF_INIT
	defer odit.git_buf_dispose(&buf)

	err = odit.git_config_set_string(cfg, "core.customkey", "odin_value")
	testing.expect_value(t, err, 0)

	err = odit.git_config_get_string_buf(&buf, cfg, "core.customkey")
	testing.expect_value(t, err, 0)
	testing.expect(t, strings.compare(string(buf.ptr), "odin_value") == 0, "Config string mismatch")
}

@test
test_status_list :: proc(t: ^testing.T) {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	test_repo_path: cstring = "/tmp/test_odit_status_repo"
	os.remove_all(string(test_repo_path))
	defer os.remove_all(string(test_repo_path))

	repo: ^odit.git_repository
	err := odit.git_repository_init(&repo, test_repo_path, 0)
	testing.expect_value(t, err, 0)
	defer odit.git_repository_free(repo)

	// Create an untracked file
	test_file_path := fmt.tprintf("%s/untracked.txt", string(test_repo_path))
	_ = os.write_entire_file(test_file_path, transmute([]u8)string("untracked content"))

	status_opts := odit.GIT_STATUS_OPTIONS_INIT
	status_opts.show = .INDEX_AND_WORKDIR
	status_opts.flags = u32(odit.git_status_opt_t.INCLUDE_UNTRACKED)

	status_list: ^odit.git_status_list
	err = odit.git_status_list_new(&status_list, repo, &status_opts)
	testing.expect_value(t, err, 0)
	defer odit.git_status_list_free(status_list)

	count := odit.git_status_list_entrycount(status_list)
	testing.expect_value(t, count, 1)

	entry := odit.git_status_byindex(status_list, 0)
	testing.expect(t, entry != nil, "Status entry was nil")
	testing.expect(t, entry.status == .WT_NEW, "Expected WT_NEW status")
}
