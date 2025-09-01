/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_worktree_h__ :: 

/**
* Worktree add options structure
*
* Initialize with `GIT_WORKTREE_ADD_OPTIONS_INIT`. Alternatively, you can
* use `git_worktree_add_options_init`.
*
*/
git_worktree_add_options :: struct {
	version:           c.uint,
	lock:              c.int,          /**< lock newly created worktree */
	checkout_existing: c.int,          /**< allow checkout of existing branch matching worktree name */
	ref:               ^git_reference, /**< reference to use for the new worktree HEAD */

	/**
	* Options for the checkout.
	*/
	checkout_options: git_checkout_options,
}

/** Current version for the `git_worktree_add_options` structure */
GIT_WORKTREE_ADD_OPTIONS_VERSION :: 1

/** Static constructor for `git_worktree_add_options` */
GIT_WORKTREE_ADD_OPTIONS_INIT :: {GIT_WORKTREE_ADD_OPTIONS_VERSION, 0, 0, NULL, GIT_CHECKOUT_OPTIONS_INIT}

/**
* Flags which can be passed to git_worktree_prune to alter its
* behavior.
*/
git_worktree_prune_t :: enum c.uint {
	/* Prune working tree even if working tree is valid */
	VALID = 1,

	/* Prune working tree even if it is locked */
	LOCKED = 2,

	/* Prune checked out working tree */
	WORKING_TREE = 4,
}

/**
* Worktree prune options structure
*
* Initialize with `GIT_WORKTREE_PRUNE_OPTIONS_INIT`. Alternatively, you can
* use `git_worktree_prune_options_init`.
*
*/
git_worktree_prune_options :: struct {
	version: c.uint,

	/** A combination of `git_worktree_prune_t` */
	flags: u32,
}

/** Current version for the `git_worktree_prune_options` structure */
GIT_WORKTREE_PRUNE_OPTIONS_VERSION :: 1

/** Static constructor for `git_worktree_prune_options` */
GIT_WORKTREE_PRUNE_OPTIONS_INIT :: {GIT_WORKTREE_PRUNE_OPTIONS_VERSION, 0}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* List names of linked working trees
	*
	* The returned list should be released with `git_strarray_free`
	* when no longer needed.
	*
	* @param out pointer to the array of working tree names
	* @param repo the repo to use when listing working trees
	* @return 0 or an error code
	*/
	git_worktree_list :: proc(out: ^git_strarray, repo: ^git_repository) -> c.int ---

	/**
	* Lookup a working tree by its name for a given repository
	*
	* @param out Output pointer to looked up worktree or `NULL`
	* @param repo The repository containing worktrees
	* @param name Name of the working tree to look up
	* @return 0 or an error code
	*/
	git_worktree_lookup :: proc(out: ^^git_worktree, repo: ^git_repository, name: cstring) -> c.int ---

	/**
	* Open a worktree of a given repository
	*
	* If a repository is not the main tree but a worktree, this
	* function will look up the worktree inside the parent
	* repository and create a new `git_worktree` structure.
	*
	* @param out Out-pointer for the newly allocated worktree
	* @param repo Repository to look up worktree for
	* @return 0 or an error code
	*/
	git_worktree_open_from_repository :: proc(out: ^^git_worktree, repo: ^git_repository) -> c.int ---

	/**
	* Free a previously allocated worktree
	*
	* @param wt worktree handle to close. If NULL nothing occurs.
	*/
	git_worktree_free :: proc(wt: ^git_worktree) ---

	/**
	* Check if worktree is valid
	*
	* A valid worktree requires both the git data structures inside
	* the linked parent repository and the linked working copy to be
	* present.
	*
	* @param wt Worktree to check
	* @return 0 when worktree is valid, error-code otherwise
	*/
	git_worktree_validate :: proc(wt: ^git_worktree) -> c.int ---

	/**
	* Initialize git_worktree_add_options structure
	*
	* Initializes a `git_worktree_add_options` with default values. Equivalent to
	* creating an instance with `GIT_WORKTREE_ADD_OPTIONS_INIT`.
	*
	* @param opts The `git_worktree_add_options` struct to initialize.
	* @param version The struct version; pass `GIT_WORKTREE_ADD_OPTIONS_VERSION`.
	* @return Zero on success; -1 on failure.
	*/
	git_worktree_add_options_init :: proc(opts: ^git_worktree_add_options, version: c.uint) -> c.int ---

	/**
	* Add a new working tree
	*
	* Add a new working tree for the repository, that is create the
	* required data structures inside the repository and check out
	* the current HEAD at `path`
	*
	* @param out Output pointer containing new working tree
	* @param repo Repository to create working tree for
	* @param name Name of the working tree
	* @param path Path to create working tree at
	* @param opts Options to modify default behavior. May be NULL
	* @return 0 or an error code
	*/
	git_worktree_add :: proc(out: ^^git_worktree, repo: ^git_repository, name: cstring, path: cstring, opts: ^git_worktree_add_options) -> c.int ---

	/**
	* Lock worktree if not already locked
	*
	* Lock a worktree, optionally specifying a reason why the linked
	* working tree is being locked.
	*
	* @param wt Worktree to lock
	* @param reason Reason why the working tree is being locked
	* @return 0 on success, non-zero otherwise
	*/
	git_worktree_lock :: proc(wt: ^git_worktree, reason: cstring) -> c.int ---

	/**
	* Unlock a locked worktree
	*
	* @param wt Worktree to unlock
	* @return 0 on success, 1 if worktree was not locked, error-code
	*  otherwise
	*/
	git_worktree_unlock :: proc(wt: ^git_worktree) -> c.int ---

	/**
	* Check if worktree is locked
	*
	* A worktree may be locked if the linked working tree is stored
	* on a portable device which is not available.
	*
	* @param reason Buffer to store reason in. If NULL no reason is stored.
	* @param wt Worktree to check
	* @return 0 when the working tree not locked, a value greater
	*  than zero if it is locked, less than zero if there was an
	*  error
	*/
	git_worktree_is_locked :: proc(reason: ^git_buf, wt: ^git_worktree) -> c.int ---

	/**
	* Retrieve the name of the worktree
	*
	* @param wt Worktree to get the name for
	* @return The worktree's name. The pointer returned is valid for the
	*  lifetime of the git_worktree
	*/
	git_worktree_name :: proc(wt: ^git_worktree) -> cstring ---

	/**
	* Retrieve the filesystem path for the worktree
	*
	* @param wt Worktree to get the path for
	* @return The worktree's filesystem path. The pointer returned
	*  is valid for the lifetime of the git_worktree.
	*/
	git_worktree_path :: proc(wt: ^git_worktree) -> cstring ---

	/**
	* Initialize git_worktree_prune_options structure
	*
	* Initializes a `git_worktree_prune_options` with default values. Equivalent to
	* creating an instance with `GIT_WORKTREE_PRUNE_OPTIONS_INIT`.
	*
	* @param opts The `git_worktree_prune_options` struct to initialize.
	* @param version The struct version; pass `GIT_WORKTREE_PRUNE_OPTIONS_VERSION`.
	* @return Zero on success; -1 on failure.
	*/
	git_worktree_prune_options_init :: proc(opts: ^git_worktree_prune_options, version: c.uint) -> c.int ---

	/**
	* Is the worktree prunable with the given options?
	*
	* A worktree is not prunable in the following scenarios:
	*
	* - the worktree is linking to a valid on-disk worktree. The
	*   `valid` member will cause this check to be ignored.
	* - the worktree is locked. The `locked` flag will cause this
	*   check to be ignored.
	*
	* If the worktree is not valid and not locked or if the above
	* flags have been passed in, this function will return a
	* positive value. If the worktree is not prunable, an error
	* message will be set (visible in `giterr_last`) with details about
	* why.
	*
	* @param wt Worktree to check.
	* @param opts The prunable options.
	* @return 1 if the worktree is prunable, 0 otherwise, or an error code.
	*/
	git_worktree_is_prunable :: proc(wt: ^git_worktree, opts: ^git_worktree_prune_options) -> c.int ---

	/**
	* Prune working tree
	*
	* Prune the working tree, that is remove the git data
	* structures on disk. The repository will only be pruned of
	* `git_worktree_is_prunable` succeeds.
	*
	* @param wt Worktree to prune
	* @param opts Specifies which checks to override. See
	*        `git_worktree_is_prunable`. May be NULL
	* @return 0 or an error code
	*/
	git_worktree_prune :: proc(wt: ^git_worktree, opts: ^git_worktree_prune_options) -> c.int ---
}
