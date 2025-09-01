/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_types_h__ :: 

/*
* Note: Can't use off_t since if a client program includes <sys/types.h>
* before us (directly or indirectly), they'll get 32 bit off_t in their client
* app, even though /we/ define _FILE_OFFSET_BITS=64.
*/
git_off_t :: i64

git_time_t :: i64 /**< time in seconds from epoch */

/** The maximum size of an object */
git_object_size_t :: u64

/** Basic type (loose or packed) of any Git object. */
git_object_t :: enum c.int {
	ANY     = -2, /**< Object can be any of the following */
	INVALID = -1, /**< Object is invalid. */
	COMMIT  = 1,  /**< A commit object. */
	TREE    = 2,  /**< A tree (directory listing) object. */
	BLOB    = 3,  /**< A file revision object. */
	TAG     = 4,  /**< An annotated tag object. */
}

/** Time in a signature */
git_time :: struct {
	time:   git_time_t, /**< time in seconds from epoch */
	offset: c.int,      /**< timezone offset, in minutes */
	sign:   c.char,     /**< indicator for questionable '-0000' offsets in signature */
}

/** An action signature (e.g. for committers, taggers, etc) */
git_signature :: struct {
	name:  cstring,  /**< full name of the author */
	email: cstring,  /**< email of the author */
	_when: git_time, /**< time when the action happened */
}

/** Basic type of any Git reference. */
git_reference_t :: enum c.uint {
	INVALID,  /**< Invalid reference */
	DIRECT,   /**< A reference that points at an object id */
	SYMBOLIC, /**< A reference that points at another reference */
	ALL,
}

/** Basic type of any Git branch. */
git_branch_t :: enum c.uint {
	LOCAL  = 1,
	REMOTE = 2,
	ALL    = 3,
}

/** Valid modes for index and tree entries. */
git_filemode_t :: enum c.uint {
	UNREADABLE      = 0,
	TREE            = 16384,
	BLOB            = 33188,
	BLOB_EXECUTABLE = 33261,
	LINK            = 40960,
	COMMIT          = 57344,
}

/**
* Submodule update values
*
* These values represent settings for the `submodule.$name.update`
* configuration value which says how to handle `git submodule update` for
* this submodule.  The value is usually set in the ".gitmodules" file and
* copied to ".git/config" when the submodule is initialized.
*
* You can override this setting on a per-submodule basis with
* `git_submodule_set_update()` and write the changed value to disk using
* `git_submodule_save()`.  If you have overwritten the value, you can
* revert it by passing `GIT_SUBMODULE_UPDATE_RESET` to the set function.
*
* The values are:
*
* - GIT_SUBMODULE_UPDATE_CHECKOUT: the default; when a submodule is
*   updated, checkout the new detached HEAD to the submodule directory.
* - GIT_SUBMODULE_UPDATE_REBASE: update by rebasing the current checked
*   out branch onto the commit from the superproject.
* - GIT_SUBMODULE_UPDATE_MERGE: update by merging the commit in the
*   superproject into the current checkout out branch of the submodule.
* - GIT_SUBMODULE_UPDATE_NONE: do not update this submodule even when
*   the commit in the superproject is updated.
* - GIT_SUBMODULE_UPDATE_DEFAULT: not used except as static initializer
*   when we don't want any particular update rule to be specified.
*/
git_submodule_update_t :: enum c.uint {
	CHECKOUT = 1,
	REBASE   = 2,
	MERGE    = 3,
	NONE     = 4,
	DEFAULT  = 0,
}

/**
* Submodule ignore values
*
* These values represent settings for the `submodule.$name.ignore`
* configuration value which says how deeply to look at the working
* directory when getting submodule status.
*
* You can override this value in memory on a per-submodule basis with
* `git_submodule_set_ignore()` and can write the changed value to disk
* with `git_submodule_save()`.  If you have overwritten the value, you
* can revert to the on disk value by using `GIT_SUBMODULE_IGNORE_RESET`.
*
* The values are:
*
* - GIT_SUBMODULE_IGNORE_UNSPECIFIED: use the submodule's configuration
* - GIT_SUBMODULE_IGNORE_NONE: don't ignore any change - i.e. even an
*   untracked file, will mark the submodule as dirty.  Ignored files are
*   still ignored, of course.
* - GIT_SUBMODULE_IGNORE_UNTRACKED: ignore untracked files; only changes
*   to tracked files, or the index or the HEAD commit will matter.
* - GIT_SUBMODULE_IGNORE_DIRTY: ignore changes in the working directory,
*   only considering changes if the HEAD of submodule has moved from the
*   value in the superproject.
* - GIT_SUBMODULE_IGNORE_ALL: never check if the submodule is dirty
* - GIT_SUBMODULE_IGNORE_DEFAULT: not used except as static initializer
*   when we don't want any particular ignore rule to be specified.
*/
git_submodule_ignore_t :: enum c.int {
	UNSPECIFIED = -1, /**< use the submodule's configuration */
	NONE        = 1,  /**< any change or untracked == dirty */
	UNTRACKED   = 2,  /**< dirty if tracked files change */
	DIRTY       = 3,  /**< only dirty if HEAD moved */
	ALL         = 4,  /**< never dirty */
}

/**
* Options for submodule recurse.
*
* Represent the value of `submodule.$name.fetchRecurseSubmodules`
*
* * GIT_SUBMODULE_RECURSE_NO    - do no recurse into submodules
* * GIT_SUBMODULE_RECURSE_YES   - recurse into submodules
* * GIT_SUBMODULE_RECURSE_ONDEMAND - recurse into submodules only when
*                                    commit not already in local clone
*/
git_submodule_recurse_t :: enum c.uint {
	NO,
	YES,
	ONDEMAND,
}

/** A type to write in a streaming fashion, for example, for filters. */
git_writestream :: struct {
	write: proc "c" (^git_writestream, cstring, c.int) -> c.int,
	close: proc "c" (^git_writestream) -> c.int,
	free:  proc "c" (^git_writestream),
}

