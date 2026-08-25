package main

import "core:c"
import "core:fmt"
import "core:os"
import "../../odit"

main :: proc() {
	odit.git_libgit2_init()
	defer odit.git_libgit2_shutdown()

	repo_path: cstring = "/tmp/odit_branches_tags_example_repo"
	_ = os.remove_all(string(repo_path))
	defer _ = os.remove_all(string(repo_path))

	repo: ^odit.git_repository
	odit.git_repository_init(&repo, repo_path, 0)
	defer odit.git_repository_free(repo)

	index: ^odit.git_index
	odit.git_repository_index(&index, repo)
	defer odit.git_index_free(index)

	sig: ^odit.git_signature
	odit.git_signature_now(&sig, "Release Manager", "release@odin-lang.org")
	defer odit.git_signature_free(sig)

	// Create root commit
	_ = os.write_entire_file(fmt.tprintf("%s/release.txt", repo_path), transmute([]u8)string("v1.0.0 Release Notes\n"))
	odit.git_index_add_bypath(index, "release.txt")
	odit.git_index_write(index)

	tree_id: odit.git_oid
	odit.git_index_write_tree(&tree_id, index)
	tree: ^odit.git_tree
	odit.git_tree_lookup(&tree, repo, &tree_id)
	defer odit.git_tree_free(tree)

	commit_id: odit.git_oid
	odit.git_commit_create(&commit_id, repo, "HEAD", sig, sig, nil, "Release version 1.0.0", tree, 0, nil)

	commit: ^odit.git_commit
	odit.git_commit_lookup(&commit, repo, &commit_id)
	defer odit.git_commit_free(commit)

	// 1. Create Branches
	fmt.println("--- Branch Management ---")
	branch_names := [3]string{"feature/login-system", "feature/dark-mode", "hotfix/security-patch"}
	for name in branch_names {
		branch_ref: ^odit.git_reference
		if err := odit.git_branch_create(&branch_ref, repo, cstring(raw_data(name)), commit, 0); err == 0 {
			defer odit.git_reference_free(branch_ref)
			fmt.printf("[+] Created branch: %s\n", name)
		}
	}

	// 2. Iterate Branches
	fmt.println("\n--- Local Branches in Repository ---")
	branch_iter: ^odit.git_branch_iterator
	odit.git_branch_iterator_new(&branch_iter, repo, odit.git_branch_t.LOCAL)
	defer odit.git_branch_iterator_free(branch_iter)

	ref: ^odit.git_reference
	btype: odit.git_branch_t
	for odit.git_branch_next(&ref, &btype, branch_iter) == 0 {
		bname: cstring
		odit.git_branch_name(&bname, ref)
		is_head := odit.git_branch_is_head(ref)
		fmt.printf("  %s %s\n", is_head != 0 ? "*" : " ", bname)
		odit.git_reference_free(ref)
	}

	// 3. Create Annotated Tag
	fmt.println("\n--- Tag Management ---")
	tag_id: odit.git_oid
	err := odit.git_tag_create(&tag_id, repo, "v1.0.0", (^odit.git_object)(commit), sig, "Official 1.0.0 Production Release", 0)
	if err == 0 {
		fmt.printf("[+] Created annotated tag: v1.0.0 (OID: %.7s)\n", odit.git_oid_tostr_s(&tag_id))
	}

	// 4. Lookup Tag and Inspect Details
	tag: ^odit.git_tag
	if odit.git_tag_lookup(&tag, repo, &tag_id) == 0 {
		defer odit.git_tag_free(tag)
		tagger := odit.git_tag_tagger(tag)
		fmt.printf("  Tag Name:    %s\n", odit.git_tag_name(tag))
		fmt.printf("  Tagger:      %s <%s>\n", tagger.name, tagger.email)
		fmt.printf("  Tag Message: %s\n", odit.git_tag_message(tag))
	}
}
