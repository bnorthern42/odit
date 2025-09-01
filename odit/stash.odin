/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_stash_h__ :: 

/**
* Stash flags
*/
git_stash_flags :: enum c.uint {
	/**
	* No option, default
	*/
	DEFAULT = 0,

	/**
	* All changes already added to the index are left intact in
	* the working directory
	*/
	KEEP_INDEX = 1,

	/**
	* All untracked files are also stashed and then cleaned up
	* from the working directory
	*/
	INCLUDE_UNTRACKED = 2,

	/**
	* All ignored files are also stashed and then cleaned up from
	* the working directory
	*/
	INCLUDE_IGNORED = 4,

	/**
	* All changes in the index and working directory are left intact
	*/
	KEEP_ALL = 8,
}

/**
* Stash save options structure
*
* Initialize with `GIT_STASH_SAVE_OPTIONS_INIT`. Alternatively, you can
* use `git_stash_save_options_init`.
*
*/
git_stash_save_options :: struct {
	version: c.uint,

	/** Flags to control the stashing process. (see GIT_STASH_* above) */
	flags: u32,

	/** The identity of the person performing the stashing. */
	stasher: ^git_signature,

	/** Optional description along with the stashed state. */
	message: cstring,

	/** Optional paths that control which files are stashed. */
	paths: git_strarray,
}

/** Current version for the `git_stash_save_options` structure */
GIT_STASH_SAVE_OPTIONS_VERSION :: 1

/** Static constructor for `git_stash_save_options` */
GIT_STASH_SAVE_OPTIONS_INIT :: {GIT_STASH_SAVE_OPTIONS_VERSION}

/** Stash application flags. */
git_stash_apply_flags :: enum c.uint {
	DEFAULT,

	/* Try to reinstate not only the working tree's changes,
	* but also the index's changes.
	*/
	REINSTATE_INDEX,
}

/** Stash apply progression states */
git_stash_apply_progress_t :: enum c.uint {
	NONE,

	/** Loading the stashed data from the object database. */
	LOADING_STASH,

	/** The stored index is being analyzed. */
	ANALYZE_INDEX,

	/** The modified files are being analyzed. */
	ANALYZE_MODIFIED,

	/** The untracked and ignored files are being analyzed. */
	ANALYZE_UNTRACKED,

	/** The untracked files are being written to disk. */
	CHECKOUT_UNTRACKED,

	/** The modified files are being written to disk. */
	CHECKOUT_MODIFIED,

	/** The stash was applied successfully. */
	DONE,
}

/**
* Stash application progress notification function.
* Return 0 to continue processing, or a negative value to
* abort the stash application.
*
* @param progress the progress information
* @param payload the user-specified payload to the apply function
* @return 0 on success, -1 on error
*/
git_stash_apply_progress_cb :: proc "c" (git_stash_apply_progress_t, rawptr) -> c.int

/**
* Stash application options structure
*
* Initialize with `GIT_STASH_APPLY_OPTIONS_INIT`. Alternatively, you can
* use `git_stash_apply_options_init`.
*
*/
git_stash_apply_options :: struct {
	version:          c.uint,

	/** See `git_stash_apply_flags`, above. */
	flags: u32,

	/** Options to use when writing files to the working directory. */
	checkout_options: git_checkout_options,

	/** Optional callback to notify the consumer of application progress. */
	progress_cb: git_stash_apply_progress_cb,
	progress_payload: rawptr,
}

/** Current version for the `git_stash_apply_options` structure */
GIT_STASH_APPLY_OPTIONS_VERSION :: 1

/** Static constructor for `git_stash_apply_options` */
GIT_STASH_APPLY_OPTIONS_INIT :: {GIT_STASH_APPLY_OPTIONS_VERSION, GIT_STASH_APPLY_DEFAULT, GIT_CHECKOUT_OPTIONS_INIT}

/**
* This is a callback function you can provide to iterate over all the
* stashed states that will be invoked per entry.
*
* @param index The position within the stash list. 0 points to the
*              most recent stashed state.
* @param message The stash message.
* @param stash_id The commit oid of the stashed state.
* @param payload Extra parameter to callback function.
* @return 0 to continue iterating or non-zero to stop.
*/
git_stash_cb :: proc "c" (c.int, cstring, ^git_oid, rawptr) -> c.int

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Save the local modifications to a new stash.
	*
	* @param out Object id of the commit containing the stashed state.
	* This commit is also the target of the direct reference refs/stash.
	* @param repo The owning repository.
	* @param stasher The identity of the person performing the stashing.
	* @param message Optional description along with the stashed state.
	* @param flags Flags to control the stashing process. (see GIT_STASH_* above)
	* @return 0 on success, GIT_ENOTFOUND where there's nothing to stash,
	* or error code.
	*/
	git_stash_save :: proc(out: ^git_oid, repo: ^git_repository, stasher: ^git_signature, message: cstring, flags: u32) -> c.int ---

	/**
	* Initialize git_stash_save_options structure
	*
	* Initializes a `git_stash_save_options` with default values. Equivalent to
	* creating an instance with `GIT_STASH_SAVE_OPTIONS_INIT`.
	*
	* @param opts The `git_stash_save_options` struct to initialize.
	* @param version The struct version; pass `GIT_STASH_SAVE_OPTIONS_VERSION`.
	* @return Zero on success; -1 on failure.
	*/
	git_stash_save_options_init :: proc(opts: ^git_stash_save_options, version: c.uint) -> c.int ---

	/**
	* Save the local modifications to a new stash, with options.
	*
	* @param out Object id of the commit containing the stashed state.
	* This commit is also the target of the direct reference refs/stash.
	* @param repo The owning repository.
	* @param opts The stash options.
	* @return 0 on success, GIT_ENOTFOUND where there's nothing to stash,
	* or error code.
	*/
	git_stash_save_with_opts :: proc(out: ^git_oid, repo: ^git_repository, opts: ^git_stash_save_options) -> c.int ---

	/**
	* Initialize git_stash_apply_options structure
	*
	* Initializes a `git_stash_apply_options` with default values. Equivalent to
	* creating an instance with `GIT_STASH_APPLY_OPTIONS_INIT`.
	*
	* @param opts The `git_stash_apply_options` struct to initialize.
	* @param version The struct version; pass `GIT_STASH_APPLY_OPTIONS_VERSION`.
	* @return Zero on success; -1 on failure.
	*/
	git_stash_apply_options_init :: proc(opts: ^git_stash_apply_options, version: c.uint) -> c.int ---

	/**
	* Apply a single stashed state from the stash list.
	*
	* If local changes in the working directory conflict with changes in the
	* stash then GIT_EMERGECONFLICT will be returned.  In this case, the index
	* will always remain unmodified and all files in the working directory will
	* remain unmodified.  However, if you are restoring untracked files or
	* ignored files and there is a conflict when applying the modified files,
	* then those files will remain in the working directory.
	*
	* If passing the GIT_STASH_APPLY_REINSTATE_INDEX flag and there would be
	* conflicts when reinstating the index, the function will return
	* GIT_EMERGECONFLICT and both the working directory and index will be left
	* unmodified.
	*
	* @param repo The owning repository.
	* @param index The position within the stash list. 0 points to the
	*              most recent stashed state.
	* @param options Optional options to control how stashes are applied.
	*
	* @return 0 on success, GIT_ENOTFOUND if there's no stashed state for the
	*         given index, GIT_EMERGECONFLICT if changes exist in the working
	*         directory, or an error code
	*/
	git_stash_apply :: proc(repo: ^git_repository, index: c.int, options: ^git_stash_apply_options) -> c.int ---

	/**
	* Loop over all the stashed states and issue a callback for each one.
	*
	* If the callback returns a non-zero value, this will stop looping.
	*
	* @param repo Repository where to find the stash.
	*
	* @param callback Callback to invoke per found stashed state. The most
	*                 recent stash state will be enumerated first.
	*
	* @param payload Extra parameter to callback function.
	*
	* @return 0 on success, non-zero callback return value, or error code.
	*/
	git_stash_foreach :: proc(repo: ^git_repository, callback: git_stash_cb, payload: rawptr) -> c.int ---

	/**
	* Remove a single stashed state from the stash list.
	*
	* @param repo The owning repository.
	*
	* @param index The position within the stash list. 0 points to the
	* most recent stashed state.
	*
	* @return 0 on success, GIT_ENOTFOUND if there's no stashed state for the given
	* index, or error code.
	*/
	git_stash_drop :: proc(repo: ^git_repository, index: c.int) -> c.int ---

	/**
	* Apply a single stashed state from the stash list and remove it from the list
	* if successful.
	*
	* @param repo The owning repository.
	* @param index The position within the stash list. 0 points to the
	*              most recent stashed state.
	* @param options Optional options to control how stashes are applied.
	*
	* @return 0 on success, GIT_ENOTFOUND if there's no stashed state for the given
	* index, or error code. (see git_stash_apply() above for details)
	*/
	git_stash_pop :: proc(repo: ^git_repository, index: c.int, options: ^git_stash_apply_options) -> c.int ---
}
