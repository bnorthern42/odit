/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_checkout_h__ :: 

/**
* Checkout behavior flags
*
* In libgit2, checkout is used to update the working directory and index
* to match a target tree.  Unlike git checkout, it does not move the HEAD
* commit for you - use `git_repository_set_head` or the like to do that.
*
* Checkout looks at (up to) four things: the "target" tree you want to
* check out, the "baseline" tree of what was checked out previously, the
* working directory for actual files, and the index for staged changes.
*
* You give checkout one of two strategies for update:
*
* - `GIT_CHECKOUT_SAFE` is the default, and similar to git's default,
*   which will make modifications that will not lose changes in the
*   working directory.
*
*                         |  target == baseline   |  target != baseline  |
*    ---------------------|-----------------------|----------------------|
*     workdir == baseline |       no action       |  create, update, or  |
*                         |                       |     delete file      |
*    ---------------------|-----------------------|----------------------|
*     workdir exists and  |       no action       |   conflict (notify   |
*       is != baseline    | notify dirty MODIFIED | and cancel checkout) |
*    ---------------------|-----------------------|----------------------|
*      workdir missing,   | notify dirty DELETED  |     create file      |
*      baseline present   |                       |                      |
*    ---------------------|-----------------------|----------------------|
*
* - `GIT_CHECKOUT_FORCE` will take any action to make the working
*   directory match the target (including potentially discarding
*   modified files).
*
* To emulate `git checkout`, use `GIT_CHECKOUT_SAFE` with a checkout
* notification callback (see below) that displays information about dirty
* files.  The default behavior will cancel checkout on conflicts.
*
* To emulate `git checkout-index`, use `GIT_CHECKOUT_SAFE` with a
* notification callback that cancels the operation if a dirty-but-existing
* file is found in the working directory.  This core git command isn't
* quite "force" but is sensitive about some types of changes.
*
* To emulate `git checkout -f`, use `GIT_CHECKOUT_FORCE`.
*
*
* There are some additional flags to modify the behavior of checkout:
*
* - `GIT_CHECKOUT_DRY_RUN` is a dry-run strategy that checks for conflicts,
*   etc., but doesn't make any actual changes.
*
* - GIT_CHECKOUT_ALLOW_CONFLICTS makes SAFE mode apply safe file updates
*   even if there are conflicts (instead of cancelling the checkout).
*
* - GIT_CHECKOUT_REMOVE_UNTRACKED means remove untracked files (i.e. not
*   in target, baseline, or index, and not ignored) from the working dir.
*
* - GIT_CHECKOUT_REMOVE_IGNORED means remove ignored files (that are also
*   untracked) from the working directory as well.
*
* - GIT_CHECKOUT_UPDATE_ONLY means to only update the content of files that
*   already exist.  Files will not be created nor deleted.  This just skips
*   applying adds, deletes, and typechanges.
*
* - GIT_CHECKOUT_DONT_UPDATE_INDEX prevents checkout from writing the
*   updated files' information to the index.
*
* - Normally, checkout will reload the index and git attributes from disk
*   before any operations.  GIT_CHECKOUT_NO_REFRESH prevents this reload.
*
* - Unmerged index entries are conflicts.  GIT_CHECKOUT_SKIP_UNMERGED skips
*   files with unmerged index entries instead.  GIT_CHECKOUT_USE_OURS and
*   GIT_CHECKOUT_USE_THEIRS to proceed with the checkout using either the
*   stage 2 ("ours") or stage 3 ("theirs") version of files in the index.
*
* - GIT_CHECKOUT_DONT_OVERWRITE_IGNORED prevents ignored files from being
*   overwritten.  Normally, files that are ignored in the working directory
*   are not considered "precious" and may be overwritten if the checkout
*   target contains that file.
*
* - GIT_CHECKOUT_DONT_REMOVE_EXISTING prevents checkout from removing
*   files or folders that fold to the same name on case insensitive
*   filesystems.  This can cause files to retain their existing names
*   and write through existing symbolic links.
*
* @flags
*/
git_checkout_strategy_t :: enum c.uint {
	/**
	* Allow safe updates that cannot overwrite uncommitted data.
	* If the uncommitted changes don't conflict with the checked
	* out files, the checkout will still proceed, leaving the
	* changes intact.
	*/
	SAFE = 0,

	/**
	* Allow all updates to force working directory to look like
	* the index, potentially losing data in the process.
	*/
	FORCE = 2,

	/** Allow checkout to recreate missing files */
	RECREATE_MISSING = 4,

	/** Allow checkout to make safe updates even if conflicts are found */
	ALLOW_CONFLICTS = 16,

	/** Remove untracked files not in index (that are not ignored) */
	REMOVE_UNTRACKED = 32,

	/** Remove ignored files not in index */
	REMOVE_IGNORED = 64,

	/** Only update existing files, don't create new ones */
	UPDATE_ONLY = 128,

	/**
	* Normally checkout updates index entries as it goes; this stops that.
	* Implies `GIT_CHECKOUT_DONT_WRITE_INDEX`.
	*/
	DONT_UPDATE_INDEX = 256,

	/** Don't refresh index/config/etc before doing checkout */
	NO_REFRESH = 512,

	/** Allow checkout to skip unmerged files */
	SKIP_UNMERGED = 1024,

	/** For unmerged files, checkout stage 2 from index */
	USE_OURS = 2048,

	/** For unmerged files, checkout stage 3 from index */
	USE_THEIRS = 4096,

	/** Treat pathspec as simple list of exact match file paths */
	DISABLE_PATHSPEC_MATCH = 8192,

	/** Ignore directories in use, they will be left empty */
	SKIP_LOCKED_DIRECTORIES = 262144,

	/** Don't overwrite ignored files that exist in the checkout target */
	DONT_OVERWRITE_IGNORED = 524288,

	/** Write normal merge files for conflicts */
	CONFLICT_STYLE_MERGE = 1048576,

	/** Include common ancestor data in diff3 format files for conflicts */
	CONFLICT_STYLE_DIFF3 = 2097152,

	/** Don't overwrite existing files or folders */
	DONT_REMOVE_EXISTING = 4194304,

	/** Normally checkout writes the index upon completion; this prevents that. */
	DONT_WRITE_INDEX = 8388608,

	/**
	* Perform a "dry run", reporting what _would_ be done but
	* without actually making changes in the working directory
	* or the index.
	*/
	DRY_RUN = 16777216,

	/** Include common ancestor data in zdiff3 format for conflicts */
	CONFLICT_STYLE_ZDIFF3 = 33554432,

	/**
	* Do not do a checkout and do not fire callbacks; this is primarily
	* useful only for internal functions that will perform the
	* checkout themselves but need to pass checkout options into
	* another function, for example, `git_clone`.
	*/
	NONE = 1073741824,

	/** Recursively checkout submodules with same options (NOT IMPLEMENTED) */
	UPDATE_SUBMODULES = 65536,

	/** Recursively checkout submodules if HEAD moved in super repo (NOT IMPLEMENTED) */
	UPDATE_SUBMODULES_IF_CHANGED = 131072,
}

/**
* Checkout notification flags
*
* Checkout will invoke an options notification callback (`notify_cb`) for
* certain cases - you pick which ones via `notify_flags`:
*
* Returning a non-zero value from this callback will cancel the checkout.
* The non-zero return value will be propagated back and returned by the
* git_checkout_... call.
*
* Notification callbacks are made prior to modifying any files on disk,
* so canceling on any notification will still happen prior to any files
* being modified.
*
* @flags
*/
git_checkout_notify_t :: enum c.uint {
	NONE      = 0,

	/**
	* Invokes checkout on conflicting paths.
	*/
	CONFLICT = 1,

	/**
	* Notifies about "dirty" files, i.e. those that do not need an update
	* but no longer match the baseline.  Core git displays these files when
	* checkout runs, but won't stop the checkout.
	*/
	DIRTY = 2,

	/**
	* Sends notification for any file changed.
	*/
	UPDATED = 4,

	/**
	* Notifies about untracked files.
	*/
	UNTRACKED = 8,

	/**
	* Notifies about ignored files.
	*/
	IGNORED = 16,

	/**
	* Notifies about ignored files.
	*/
	ALL = 65535,
}

/** Checkout performance-reporting structure */
git_checkout_perfdata :: struct {}

/**
* Checkout notification callback function.
*
* @param why the notification reason
* @param path the path to the file being checked out
* @param baseline the baseline's diff file information
* @param target the checkout target diff file information
* @param workdir the working directory diff file information
* @param payload the user-supplied callback payload
* @return 0 on success, or an error code
*/
git_checkout_notify_cb :: proc "c" (git_checkout_notify_t, cstring, ^git_diff_file, ^git_diff_file, ^git_diff_file, rawptr) -> c.int

/**
* Checkout progress notification function.
*
* @param path the path to the file being checked out
* @param completed_steps number of checkout steps completed
* @param total_steps number of total steps in the checkout process
* @param payload the user-supplied callback payload
*/
git_checkout_progress_cb :: proc "c" (cstring, c.int, c.int, rawptr)

/**
* Checkout performance data reporting function.
*
* @param perfdata the performance data for the checkout
* @param payload the user-supplied callback payload
*/
git_checkout_perfdata_cb :: proc "c" (^git_checkout_perfdata, rawptr)

/**
* Checkout options structure
*
* Initialize with `GIT_CHECKOUT_OPTIONS_INIT`. Alternatively, you can
* use `git_checkout_options_init`.
*
* @options[version] GIT_CHECKOUT_OPTIONS_VERSION
* @options[init_macro] GIT_CHECKOUT_OPTIONS_INIT
* @options[init_function] git_checkout_options_init
*/
git_checkout_options :: struct {
	version:           c.uint,  /**< The version */
	checkout_strategy: c.uint,  /**< default will be a safe checkout */
	disable_filters:   c.int,   /**< don't apply filters like CRLF conversion */
	dir_mode:          c.uint,  /**< default is 0755 */
	file_mode:         c.uint,  /**< default is 0644 or 0755 as dictated by blob */
	file_open_flags:   c.int,   /**< default is O_CREAT | O_TRUNC | O_WRONLY */

	/**
	* Checkout notification flags specify what operations the notify
	* callback is invoked for.
	*
	* @type[flags] git_checkout_notify_t
	*/
	notify_flags: c.uint,

	/**
	* Optional callback to get notifications on specific file states.
	* @see git_checkout_notify_t
	*/
	notify_cb: git_checkout_notify_cb,

	/** Payload passed to notify_cb */
	notify_payload: rawptr,

	/** Optional callback to notify the consumer of checkout progress. */
	progress_cb: git_checkout_progress_cb,

	/** Payload passed to progress_cb */
	progress_payload: rawptr,

	/**
	* A list of wildmatch patterns or paths.
	*
	* By default, all paths are processed. If you pass an array of wildmatch
	* patterns, those will be used to filter which paths should be taken into
	* account.
	*
	* Use GIT_CHECKOUT_DISABLE_PATHSPEC_MATCH to treat as a simple list.
	*/
	paths: git_strarray,

	/**
	* The expected content of the working directory; defaults to HEAD.
	*
	* If the working directory does not match this baseline information,
	* that will produce a checkout conflict.
	*/
	baseline: ^git_tree,

	/**
	* Like `baseline` above, though expressed as an index.  This
	* option overrides `baseline`.
	*/
	baseline_index: ^git_index,
	target_directory:  cstring, /**< alternative checkout path to workdir */
	ancestor_label:    cstring, /**< the name of the common ancestor side of conflicts */
	our_label:         cstring, /**< the name of the "our" side of conflicts */
	their_label:       cstring, /**< the name of the "their" side of conflicts */

	/** Optional callback to notify the consumer of performance data. */
	perfdata_cb: git_checkout_perfdata_cb,

	/** Payload passed to perfdata_cb */
	perfdata_payload: rawptr,
}

/** Current version for the `git_checkout_options` structure */
GIT_CHECKOUT_OPTIONS_VERSION :: 1

/** Static constructor for `git_checkout_options` */
GIT_CHECKOUT_OPTIONS_INIT :: {GIT_CHECKOUT_OPTIONS_VERSION}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Initialize git_checkout_options structure
	*
	* Initializes a `git_checkout_options` with default values. Equivalent to creating
	* an instance with GIT_CHECKOUT_OPTIONS_INIT.
	*
	* @param opts The `git_checkout_options` struct to initialize.
	* @param version The struct version; pass `GIT_CHECKOUT_OPTIONS_VERSION`.
	* @return Zero on success; -1 on failure.
	*/
	git_checkout_options_init :: proc(opts: ^git_checkout_options, version: c.uint) -> c.int ---

	/**
	* Updates files in the index and the working tree to match the content of
	* the commit pointed at by HEAD.
	*
	* Note that this is _not_ the correct mechanism used to switch branches;
	* do not change your `HEAD` and then call this method, that would leave
	* you with checkout conflicts since your working directory would then
	* appear to be dirty.  Instead, checkout the target of the branch and
	* then update `HEAD` using `git_repository_set_head` to point to the
	* branch you checked out.
	*
	* @param repo repository to check out (must be non-bare)
	* @param opts specifies checkout options (may be NULL)
	* @return 0 on success, GIT_EUNBORNBRANCH if HEAD points to a non
	*         existing branch, non-zero value returned by `notify_cb`, or
	*         other error code < 0 (use git_error_last for error details)
	*/
	git_checkout_head :: proc(repo: ^git_repository, opts: ^git_checkout_options) -> c.int ---

	/**
	* Updates files in the working tree to match the content of the index.
	*
	* @param repo repository into which to check out (must be non-bare)
	* @param index index to be checked out (or NULL to use repository index)
	* @param opts specifies checkout options (may be NULL)
	* @return 0 on success, non-zero return value from `notify_cb`, or error
	*         code < 0 (use git_error_last for error details)
	*/
	git_checkout_index :: proc(repo: ^git_repository, index: ^git_index, opts: ^git_checkout_options) -> c.int ---

	/**
	* Updates files in the index and working tree to match the content of the
	* tree pointed at by the treeish.
	*
	* @param repo repository to check out (must be non-bare)
	* @param treeish a commit, tag or tree which content will be used to update
	* the working directory (or NULL to use HEAD)
	* @param opts specifies checkout options (may be NULL)
	* @return 0 on success, non-zero return value from `notify_cb`, or error
	*         code < 0 (use git_error_last for error details)
	*/
	git_checkout_tree :: proc(repo: ^git_repository, treeish: ^git_object, opts: ^git_checkout_options) -> c.int ---
}
