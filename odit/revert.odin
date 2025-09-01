/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_revert_h__ :: 

/**
* Options for revert
*/
git_revert_options :: struct {}

/** Current version for the `git_revert_options` structure */
GIT_REVERT_OPTIONS_VERSION :: 1

/** Static constructor for `git_revert_options` */
GIT_REVERT_OPTIONS_INIT :: {GIT_REVERT_OPTIONS_VERSION, 0, GIT_MERGE_OPTIONS_INIT, GIT_CHECKOUT_OPTIONS_INIT}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Initialize git_revert_options structure
	*
	* Initializes a `git_revert_options` with default values. Equivalent to
	* creating an instance with `GIT_REVERT_OPTIONS_INIT`.
	*
	* @param opts The `git_revert_options` struct to initialize.
	* @param version The struct version; pass `GIT_REVERT_OPTIONS_VERSION`.
	* @return Zero on success; -1 on failure.
	*/
	git_revert_options_init :: proc(opts: ^git_revert_options, version: c.uint) -> c.int ---

	/**
	* Reverts the given commit against the given "our" commit, producing an
	* index that reflects the result of the revert.
	*
	* The returned index must be freed explicitly with `git_index_free`.
	*
	* @param out pointer to store the index result in
	* @param repo the repository that contains the given commits
	* @param revert_commit the commit to revert
	* @param our_commit the commit to revert against (eg, HEAD)
	* @param mainline the parent of the revert commit, if it is a merge
	* @param merge_options the merge options (or null for defaults)
	* @return zero on success, -1 on failure.
	*/
	git_revert_commit :: proc(out: ^^git_index, repo: ^git_repository, revert_commit: ^git_commit, our_commit: ^git_commit, mainline: c.uint, merge_options: ^git_merge_options) -> c.int ---

	/**
	* Reverts the given commit, producing changes in the index and working directory.
	*
	* @param repo the repository to revert
	* @param commit the commit to revert
	* @param given_opts the revert options (or null for defaults)
	* @return zero on success, -1 on failure.
	*/
	git_revert :: proc(repo: ^git_repository, commit: ^git_commit, given_opts: ^git_revert_options) -> c.int ---
}
