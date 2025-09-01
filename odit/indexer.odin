/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_indexer_h__ :: 

/**
* This structure is used to provide callers information about the
* progress of indexing a packfile, either directly or part of a
* fetch or clone that downloads a packfile.
*/
git_indexer_progress :: struct {
	/** number of objects in the packfile being indexed */
	total_objects: c.uint,

	/** received objects that have been hashed */
	indexed_objects: c.uint,

	/** received_objects: objects which have been downloaded */
	received_objects: c.uint,

	/**
	* locally-available objects that have been injected in order
	* to fix a thin pack
	*/
	local_objects: c.uint,

	/** number of deltas in the packfile being indexed */
	total_deltas: c.uint,

	/** received deltas that have been indexed */
	indexed_deltas: c.uint,

	/** size of the packfile received up to now */
	received_bytes: c.int,
}

/**
* Type for progress callbacks during indexing.  Return a value less
* than zero to cancel the indexing or download.
*
* @param stats Structure containing information about the state of the transfer
* @param payload Payload provided by caller
* @return 0 on success or an error code
*/
git_indexer_progress_cb :: proc "c" (^git_indexer_progress, rawptr) -> c.int

/**
* Options for indexer configuration
*/
git_indexer_options :: struct {
	version: c.uint,

	/** progress_cb function to call with progress information */
	progress_cb: git_indexer_progress_cb,

	/** progress_cb_payload payload for the progress callback */
	progress_cb_payload: rawptr,

	/** Do connectivity checks for the received pack */
	verify: c.uchar,
}

/** Current version for the `git_indexer_options` structure */
GIT_INDEXER_OPTIONS_VERSION :: 1

/** Static constructor for `git_indexer_options` */
GIT_INDEXER_OPTIONS_INIT :: {GIT_INDEXER_OPTIONS_VERSION}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Initializes a `git_indexer_options` with default values. Equivalent to
	* creating an instance with GIT_INDEXER_OPTIONS_INIT.
	*
	* @param opts the `git_indexer_options` struct to initialize.
	* @param version Version of struct; pass `GIT_INDEXER_OPTIONS_VERSION`
	* @return Zero on success; -1 on failure.
	*/
	git_indexer_options_init :: proc(opts: ^git_indexer_options, version: c.uint) -> c.int ---

	/**
	* Create a new indexer instance
	*
	* @param out where to store the indexer instance
	* @param path to the directory where the packfile should be stored
	* @param mode permissions to use creating packfile or 0 for defaults
	* @param odb object database from which to read base objects when
	* fixing thin packs. Pass NULL if no thin pack is expected (an error
	* will be returned if there are bases missing)
	* @param opts Optional structure containing additional options. See
	* `git_indexer_options` above.
	* @return 0 or an error code.
	*/
	git_indexer_new :: proc(out: ^^git_indexer, path: cstring, mode: c.uint, odb: ^git_odb, opts: ^git_indexer_options) -> c.int ---

	/**
	* Add data to the indexer
	*
	* @param idx the indexer
	* @param data the data to add
	* @param size the size of the data in bytes
	* @param stats stat storage
	* @return 0 or an error code.
	*/
	git_indexer_append :: proc(idx: ^git_indexer, data: rawptr, size: c.int, stats: ^git_indexer_progress) -> c.int ---

	/**
	* Finalize the pack and index
	*
	* Resolve any pending deltas and write out the index file
	*
	* @param idx the indexer
	* @param stats Stat storage.
	* @return 0 or an error code.
	*/
	git_indexer_commit :: proc(idx: ^git_indexer, stats: ^git_indexer_progress) -> c.int ---

	/**
	* Get the packfile's hash
	*
	* A packfile's name is derived from the sorted hashing of all object
	* names. This is only correct after the index has been finalized.
	*
	* @deprecated use git_indexer_name
	* @param idx the indexer instance
	* @return the packfile's hash
	*/
	git_indexer_hash :: proc(idx: ^git_indexer) -> ^git_oid ---

	/**
	* Get the unique name for the resulting packfile.
	*
	* The packfile's name is derived from the packfile's content.
	* This is only correct after the index has been finalized.
	*
	* @param idx the indexer instance
	* @return a NUL terminated string for the packfile name
	*/
	git_indexer_name :: proc(idx: ^git_indexer) -> cstring ---

	/**
	* Free the indexer and its resources
	*
	* @param idx the indexer to free
	*/
	git_indexer_free :: proc(idx: ^git_indexer) ---
}
