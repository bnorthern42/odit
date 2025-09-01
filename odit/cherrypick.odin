/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_cherrypick_h__ :: 

/**
* Cherry-pick options
*/
git_cherrypick_options :: struct {}

/** Current version for the `git_cherrypick_options` structure */
GIT_CHERRYPICK_OPTIONS_VERSION :: 1

/** Static constructor for `git_cherrypick_options` */
GIT_CHERRYPICK_OPTIONS_INIT :: {GIT_CHERRYPICK_OPTIONS_VERSION, 0, GIT_MERGE_OPTIONS_INIT, GIT_CHECKOUT_OPTIONS_INIT}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Initialize git_cherrypick_options structure
	*
	* Initializes a `git_cherrypick_options` with default values. Equivalent to creating
	* an instance with GIT_CHERRYPICK_OPTIONS_INIT.
	*
	* @param opts The `git_cherrypick_options` struct to initialize.
	* @param version The struct version; pass `GIT_CHERRYPICK_OPTIONS_VERSION`.
	* @return Zero on success; -1 on failure.
	*/
	git_cherrypick_options_init :: proc(opts: ^git_cherrypick_options, version: c.uint) -> c.int ---

	/**
	* Cherry-picks the given commit against the given "our" commit, producing an
	* index that reflects the result of the cherry-pick.
	*
	* The returned index must be freed explicitly with `git_index_free`.
	*
	* @param out pointer to store the index result in
	* @param repo the repository that contains the given commits
	* @param cherrypick_commit the commit to cherry-pick
	* @param our_commit the commit to cherry-pick against (eg, HEAD)
	* @param mainline the parent of the `cherrypick_commit`, if it is a merge
	* @param merge_options the merge options (or null for defaults)
	* @return zero on success, -1 on failure.
	*/
	git_cherrypick_commit :: proc(out: ^^git_index, repo: ^git_repository, cherrypick_commit: ^git_commit, our_commit: ^git_commit, mainline: c.uint, merge_options: ^git_merge_options) -> c.int ---

	/**
	* Cherry-pick the given commit, producing changes in the index and working directory.
	*
	* @param repo the repository to cherry-pick
	* @param commit the commit to cherry-pick
	* @param cherrypick_options the cherry-pick options (or null for defaults)
	* @return zero on success, -1 on failure.
	*/
	git_cherrypick :: proc(repo: ^git_repository, commit: ^git_commit, cherrypick_options: ^git_cherrypick_options) -> c.int ---
}
