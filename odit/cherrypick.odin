/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c

when ODIN_OS == .Windows {
	foreign import lib {
		"git2.lib",
		"system:ws2_32",
		"system:crypt32",
		"system:rpcrt4",
		"system:ole32",
		"system:advapi32",
		"system:shell32",
		"system:user32",
	}
} else when ODIN_OS == .Darwin {
	foreign import lib {
		"../libs/build/libgit2.a",
		"system:z",
		"system:iconv",
		"system:Security",
		"system:CoreFoundation",
		"system:pthread",
	}
} else {
	foreign import lib {
		"../libs/build/libgit2.a",
		"system:z",
		"system:ssl",
		"system:crypto",
		"system:pthread",
	}
}




// INCLUDE_git_cherrypick_h__ :: 

/**
* Cherry-pick options
*/
git_cherrypick_options :: struct {
	version:       c.uint,
	mainline:      c.uint,
	merge_opts:    git_merge_options,
	checkout_opts: git_checkout_options,
}

/** Current version for the `git_cherrypick_options` structure */
GIT_CHERRYPICK_OPTIONS_VERSION :: 1

/** Static constructor for `git_cherrypick_options` */
GIT_CHERRYPICK_OPTIONS_INIT :: git_cherrypick_options{version = GIT_CHERRYPICK_OPTIONS_VERSION, merge_opts = {version = GIT_MERGE_OPTIONS_VERSION, flags = u32(git_merge_flag_t.FIND_RENAMES)}, checkout_opts = {version = GIT_CHECKOUT_OPTIONS_VERSION, dir_mode = 0o755, file_mode = 0o644}}

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
