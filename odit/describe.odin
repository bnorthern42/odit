/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_describe_h__ :: 

/**
* Reference lookup strategy
*
* These behave like the --tags and --all options to git-describe,
* namely they say to look for any reference in either refs/tags/ or
* refs/ respectively.
*/
git_describe_strategy_t :: enum c.uint {
	DEFAULT,
	TAGS,
	ALL,
}

/**
* Describe options structure
*
* Initialize with `GIT_DESCRIBE_OPTIONS_INIT`. Alternatively, you can
* use `git_describe_options_init`.
*
*/
git_describe_options :: struct {
	version:             c.uint,
	max_candidates_tags: c.uint, /**< default: 10 */
	describe_strategy:   c.uint, /**< default: GIT_DESCRIBE_DEFAULT */
	pattern:             cstring,

	/**
	* When calculating the distance from the matching tag or
	* reference, only walk down the first-parent ancestry.
	*/
	only_follow_first_parent: c.int,

	/**
	* If no matching tag or reference is found, the describe
	* operation would normally fail. If this option is set, it
	* will instead fall back to showing the full id of the
	* commit.
	*/
	show_commit_oid_as_fallback: c.int,
}

/** Default maximum candidate tags */
GIT_DESCRIBE_DEFAULT_MAX_CANDIDATES_TAGS :: 10

/** Default abbreviated size */
GIT_DESCRIBE_DEFAULT_ABBREVIATED_SIZE :: 7

/** Current version for the `git_describe_options` structure */
GIT_DESCRIBE_OPTIONS_VERSION :: 1

/** Static constructor for `git_describe_options` */
GIT_DESCRIBE_OPTIONS_INIT :: {GIT_DESCRIBE_OPTIONS_VERSION, GIT_DESCRIBE_DEFAULT_MAX_CANDIDATES_TAGS, \
}

/**
* Describe format options structure
*
* Initialize with `GIT_DESCRIBE_FORMAT_OPTIONS_INIT`. Alternatively, you can
* use `git_describe_format_options_init`.
*
*/
git_describe_format_options :: struct {
	version: c.uint,

	/**
	* Size of the abbreviated commit id to use. This value is the
	* lower bound for the length of the abbreviated string. The
	* default is 7.
	*/
	abbreviated_size: c.uint,

	/**
	* Set to use the long format even when a shorter name could be used.
	*/
	always_use_long_format: c.int,

	/**
	* If the workdir is dirty and this is set, this string will
	* be appended to the description string.
	*/
	dirty_suffix: cstring,
}

/** Current version for the `git_describe_format_options` structure */
GIT_DESCRIBE_FORMAT_OPTIONS_VERSION :: 1

/** Static constructor for `git_describe_format_options` */
GIT_DESCRIBE_FORMAT_OPTIONS_INIT :: {GIT_DESCRIBE_FORMAT_OPTIONS_VERSION, GIT_DESCRIBE_DEFAULT_ABBREVIATED_SIZE, }

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Initialize git_describe_options structure
	*
	* Initializes a `git_describe_options` with default values. Equivalent to creating
	* an instance with GIT_DESCRIBE_OPTIONS_INIT.
	*
	* @param opts The `git_describe_options` struct to initialize.
	* @param version The struct version; pass `GIT_DESCRIBE_OPTIONS_VERSION`.
	* @return Zero on success; -1 on failure.
	*/
	git_describe_options_init :: proc(opts: ^git_describe_options, version: c.uint) -> c.int ---

	/**
	* Initialize git_describe_format_options structure
	*
	* Initializes a `git_describe_format_options` with default values. Equivalent to creating
	* an instance with GIT_DESCRIBE_FORMAT_OPTIONS_INIT.
	*
	* @param opts The `git_describe_format_options` struct to initialize.
	* @param version The struct version; pass `GIT_DESCRIBE_FORMAT_OPTIONS_VERSION`.
	* @return Zero on success; -1 on failure.
	*/
	git_describe_format_options_init :: proc(opts: ^git_describe_format_options, version: c.uint) -> c.int ---

	/**
	* Describe a commit
	*
	* Perform the describe operation on the given committish object.
	*
	* @param result pointer to store the result. You must free this once
	* you're done with it.
	* @param committish a committish to describe
	* @param opts the lookup options (or NULL for defaults)
	* @return 0 or an error code.
	*/
	git_describe_commit :: proc(result: ^^git_describe_result, committish: ^git_object, opts: ^git_describe_options) -> c.int ---

	/**
	* Describe a commit
	*
	* Perform the describe operation on the current commit and the
	* worktree. After performing describe on HEAD, a status is run and the
	* description is considered to be dirty if there are.
	*
	* @param out pointer to store the result. You must free this once
	* you're done with it.
	* @param repo the repository in which to perform the describe
	* @param opts the lookup options (or NULL for defaults)
	* @return 0 or an error code.
	*/
	git_describe_workdir :: proc(out: ^^git_describe_result, repo: ^git_repository, opts: ^git_describe_options) -> c.int ---

	/**
	* Print the describe result to a buffer
	*
	* @param out The buffer to store the result
	* @param result the result from `git_describe_commit()` or
	* `git_describe_workdir()`.
	* @param opts the formatting options (or NULL for defaults)
	* @return 0 or an error code.
	*/
	git_describe_format :: proc(out: ^git_buf, result: ^git_describe_result, opts: ^git_describe_format_options) -> c.int ---

	/**
	* Free the describe result.
	*
	* @param result The result to free.
	*/
	git_describe_result_free :: proc(result: ^git_describe_result) ---
}
