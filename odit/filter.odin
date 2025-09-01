/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_filter_h__ :: 

/**
* Filters are applied in one of two directions: smudging - which is
* exporting a file from the Git object database to the working directory,
* and cleaning - which is importing a file from the working directory to
* the Git object database.  These values control which direction of
* change is being applied.
*/
git_filter_mode_t :: enum c.uint {
	TO_WORKTREE = 0,
	SMUDGE      = 0,
	TO_ODB      = 1,
	CLEAN       = 1,
}

/**
* Filter option flags.
*/
git_filter_flag_t :: enum c.uint {
	DEFAULT                = 0,

	/** Don't error for `safecrlf` violations, allow them to continue. */
	ALLOW_UNSAFE = 1,

	/** Don't load `/etc/gitattributes` (or the system equivalent) */
	NO_SYSTEM_ATTRIBUTES = 2,

	/** Load attributes from `.gitattributes` in the root of HEAD */
	ATTRIBUTES_FROM_HEAD = 4,

	/**
	* Load attributes from `.gitattributes` in a given commit.
	* This can only be specified in a `git_filter_options`.
	*/
	ATTRIBUTES_FROM_COMMIT = 8,
}

/**
* Filtering options
*/
git_filter_options :: struct {
	version:   c.uint,

	/** See `git_filter_flag_t` above */
	flags: u32,
	commit_id: ^git_oid,

	/**
	* The commit to load attributes from, when
	* `GIT_FILTER_ATTRIBUTES_FROM_COMMIT` is specified.
	*/
	attr_commit_id: git_oid,
}

/** Current version for the `git_filter_options` structure */
GIT_FILTER_OPTIONS_VERSION :: 1

/** Static constructor for `git_filter_options` */
GIT_FILTER_OPTIONS_INIT :: {GIT_FILTER_OPTIONS_VERSION}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Load the filter list for a given path.
	*
	* This will return 0 (success) but set the output git_filter_list to NULL
	* if no filters are requested for the given file.
	*
	* @param filters Output newly created git_filter_list (or NULL)
	* @param repo Repository object that contains `path`
	* @param blob The blob to which the filter will be applied (if known)
	* @param path Relative path of the file to be filtered
	* @param mode Filtering direction (WT->ODB or ODB->WT)
	* @param flags Combination of `git_filter_flag_t` flags
	* @return 0 on success (which could still return NULL if no filters are
	*         needed for the requested file), <0 on error
	*/
	git_filter_list_load :: proc(filters: ^^git_filter_list, repo: ^git_repository, blob: ^git_blob, path: cstring, mode: git_filter_mode_t, flags: u32) -> c.int ---

	/**
	* Load the filter list for a given path.
	*
	* This will return 0 (success) but set the output git_filter_list to NULL
	* if no filters are requested for the given file.
	*
	* @param filters Output newly created git_filter_list (or NULL)
	* @param repo Repository object that contains `path`
	* @param blob The blob to which the filter will be applied (if known)
	* @param path Relative path of the file to be filtered
	* @param mode Filtering direction (WT->ODB or ODB->WT)
	* @param opts The `git_filter_options` to use when loading filters
	* @return 0 on success (which could still return NULL if no filters are
	*         needed for the requested file), <0 on error
	*/
	git_filter_list_load_ext :: proc(filters: ^^git_filter_list, repo: ^git_repository, blob: ^git_blob, path: cstring, mode: git_filter_mode_t, opts: ^git_filter_options) -> c.int ---

	/**
	* Query the filter list to see if a given filter (by name) will run.
	* The built-in filters "crlf" and "ident" can be queried, otherwise this
	* is the name of the filter specified by the filter attribute.
	*
	* This will return 0 if the given filter is not in the list, or 1 if
	* the filter will be applied.
	*
	* @param filters A loaded git_filter_list (or NULL)
	* @param name The name of the filter to query
	* @return 1 if the filter is in the list, 0 otherwise
	*/
	git_filter_list_contains :: proc(filters: ^git_filter_list, name: cstring) -> c.int ---

	/**
	* Apply filter list to a data buffer.
	*
	* @param out Buffer to store the result of the filtering
	* @param filters A loaded git_filter_list (or NULL)
	* @param in Buffer containing the data to filter
	* @param in_len The length of the input buffer
	* @return 0 on success, an error code otherwise
	*/
	git_filter_list_apply_to_buffer :: proc(out: ^git_buf, filters: ^git_filter_list, _in: cstring, in_len: c.int) -> c.int ---

	/**
	* Apply a filter list to the contents of a file on disk
	*
	* @param out buffer into which to store the filtered file
	* @param filters the list of filters to apply
	* @param repo the repository in which to perform the filtering
	* @param path the path of the file to filter, a relative path will be
	* taken as relative to the workdir
	* @return 0 or an error code.
	*/
	git_filter_list_apply_to_file :: proc(out: ^git_buf, filters: ^git_filter_list, repo: ^git_repository, path: cstring) -> c.int ---

	/**
	* Apply a filter list to the contents of a blob
	*
	* @param out buffer into which to store the filtered file
	* @param filters the list of filters to apply
	* @param blob the blob to filter
	* @return 0 or an error code.
	*/
	git_filter_list_apply_to_blob :: proc(out: ^git_buf, filters: ^git_filter_list, blob: ^git_blob) -> c.int ---

	/**
	* Apply a filter list to an arbitrary buffer as a stream
	*
	* @param filters the list of filters to apply
	* @param buffer the buffer to filter
	* @param len the size of the buffer
	* @param target the stream into which the data will be written
	* @return 0 or an error code.
	*/
	git_filter_list_stream_buffer :: proc(filters: ^git_filter_list, buffer: cstring, len: c.int, target: ^git_writestream) -> c.int ---

	/**
	* Apply a filter list to a file as a stream
	*
	* @param filters the list of filters to apply
	* @param repo the repository in which to perform the filtering
	* @param path the path of the file to filter, a relative path will be
	* taken as relative to the workdir
	* @param target the stream into which the data will be written
	* @return 0 or an error code.
	*/
	git_filter_list_stream_file :: proc(filters: ^git_filter_list, repo: ^git_repository, path: cstring, target: ^git_writestream) -> c.int ---

	/**
	* Apply a filter list to a blob as a stream
	*
	* @param filters the list of filters to apply
	* @param blob the blob to filter
	* @param target the stream into which the data will be written
	* @return 0 or an error code.
	*/
	git_filter_list_stream_blob :: proc(filters: ^git_filter_list, blob: ^git_blob, target: ^git_writestream) -> c.int ---

	/**
	* Free a git_filter_list
	*
	* @param filters A git_filter_list created by `git_filter_list_load`
	*/
	git_filter_list_free :: proc(filters: ^git_filter_list) ---
}
