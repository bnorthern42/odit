/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_apply_h__ :: 

/**
* When applying a patch, callback that will be made per delta (file).
*
* When the callback:
* - returns < 0, the apply process will be aborted.
* - returns > 0, the delta will not be applied, but the apply process
*      continues
* - returns 0, the delta is applied, and the apply process continues.
*
* @param delta The delta to be applied
* @param payload User-specified payload
* @return 0 if the delta is applied, < 0 if the apply process will be aborted
*	or > 0 if the delta will not be applied.
*/
git_apply_delta_cb :: proc "c" (^git_diff_delta, rawptr) -> c.int

/**
* When applying a patch, callback that will be made per hunk.
*
* When the callback:
* - returns < 0, the apply process will be aborted.
* - returns > 0, the hunk will not be applied, but the apply process
*      continues
* - returns 0, the hunk is applied, and the apply process continues.
*
* @param hunk The hunk to be applied
* @param payload User-specified payload
* @return 0 if the hunk is applied, < 0 if the apply process will be aborted
*	or > 0 if the hunk will not be applied.
*/
git_apply_hunk_cb :: proc "c" (^git_diff_hunk, rawptr) -> c.int

/**
* Flags controlling the behavior of `git_apply`.
*
* When the callback:
* - returns < 0, the apply process will be aborted.
* - returns > 0, the hunk will not be applied, but the apply process
*      continues
* - returns 0, the hunk is applied, and the apply process continues.
*/
git_apply_flags_t :: enum c.uint {
	/**
	* Don't actually make changes, just test that the patch applies.
	* This is the equivalent of `git apply --check`.
	*/
	GIT_APPLY_CHECK = 1,
}

/**
* Apply options structure.
*
* When the callback:
* - returns < 0, the apply process will be aborted.
* - returns > 0, the hunk will not be applied, but the apply process
*      continues
* - returns 0, the hunk is applied, and the apply process continues.
*
* Initialize with `GIT_APPLY_OPTIONS_INIT`. Alternatively, you can
* use `git_apply_options_init`.
*
* @see git_apply_to_tree
* @see git_apply
*/
git_apply_options :: struct {
	version: c.uint, /**< The version */

	/** When applying a patch, callback that will be made per delta (file). */
	delta_cb: git_apply_delta_cb,

	/** When applying a patch, callback that will be made per hunk. */
	hunk_cb: git_apply_hunk_cb,

	/** Payload passed to both `delta_cb` & `hunk_cb`. */
	payload: rawptr,

	/** Bitmask of `git_apply_flags_t` */
	flags: c.uint,
}

/** Current version for the `git_apply_options` structure */
GIT_APPLY_OPTIONS_VERSION :: 1

/** Static constructor for `git_apply_options` */
GIT_APPLY_OPTIONS_INIT :: {GIT_APPLY_OPTIONS_VERSION}

/** Possible application locations for git_apply */
git_apply_location_t :: enum c.uint {
	/**
	* Apply the patch to the workdir, leaving the index untouched.
	* This is the equivalent of `git apply` with no location argument.
	*/
	WORKDIR,

	/**
	* Apply the patch to the index, leaving the working directory
	* untouched.  This is the equivalent of `git apply --cached`.
	*/
	INDEX,

	/**
	* Apply the patch to both the working directory and the index.
	* This is the equivalent of `git apply --index`.
	*/
	BOTH,
}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Initialize git_apply_options structure
	*
	* Initialize a `git_apply_options` with default values. Equivalent to creating
	* an instance with GIT_APPLY_OPTIONS_INIT.
	*
	* @param opts The `git_apply_options` struct to initialize.
	* @param version The struct version; pass `GIT_APPLY_OPTIONS_VERSION`
	* @return 0 on success or -1 on failure.
	*/
	git_apply_options_init :: proc(opts: ^git_apply_options, version: c.uint) -> c.int ---

	/**
	* Apply a `git_diff` to a `git_tree`, and return the resulting image
	* as an index.
	*
	* @param out the postimage of the application
	* @param repo the repository to apply
	* @param preimage the tree to apply the diff to
	* @param diff the diff to apply
	* @param options the options for the apply (or null for defaults)
	* @return 0 or an error code
	*/
	git_apply_to_tree :: proc(out: ^^git_index, repo: ^git_repository, preimage: ^git_tree, diff: ^git_diff, options: ^git_apply_options) -> c.int ---

	/**
	* Apply a `git_diff` to the given repository, making changes directly
	* in the working directory, the index, or both.
	*
	* @param repo the repository to apply to
	* @param diff the diff to apply
	* @param location the location to apply (workdir, index or both)
	* @param options the options for the apply (or null for defaults)
	* @return 0 or an error code
	*/
	git_apply :: proc(repo: ^git_repository, diff: ^git_diff, location: git_apply_location_t, options: ^git_apply_options) -> c.int ---
}
