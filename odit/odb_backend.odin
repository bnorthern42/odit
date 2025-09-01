/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_odb_backend_h__ :: 

/** Options for configuring a packfile object backend. */
git_odb_backend_pack_options :: struct {
	version: c.uint, /**< version for the struct */

	/**
	* Type of object IDs to use for this object database, or
	* 0 for default (currently SHA1).
	*/
	oid_type: git_oid_t,
}

/** The current version of the diff options structure */
GIT_ODB_BACKEND_PACK_OPTIONS_VERSION :: 1

/**
 * Stack initializer for odb pack backend options.  Alternatively use
 * `git_odb_backend_pack_options_init` programmatic initialization.
 */
GIT_ODB_BACKEND_PACK_OPTIONS_INIT :: {GIT_ODB_BACKEND_PACK_OPTIONS_VERSION}

git_odb_backend_loose_flag_t :: enum c.uint {
	GIT_ODB_BACKEND_LOOSE_FSYNC = 1,
}

/** Options for configuring a loose object backend. */
git_odb_backend_loose_options :: struct {
	version: c.uint, /**< version for the struct */

	/** A combination of the `git_odb_backend_loose_flag_t` types. */
	flags: u32,

	/**
	* zlib compression level to use (0-9), where 1 is the fastest
	* at the expense of larger files, and 9 produces the best
	* compression at the expense of speed.  0 indicates that no
	* compression should be performed.  -1 is the default (currently
	* optimizing for speed).
	*/
	compression_level: c.int,

	/** Permissions to use creating a directory or 0 for defaults */
	dir_mode: c.uint,

	/** Permissions to use creating a file or 0 for defaults */
	file_mode: c.uint,

	/**
	* Type of object IDs to use for this object database, or
	* 0 for default (currently SHA1).
	*/
	oid_type: git_oid_t,
}

/** The current version of the diff options structure */
GIT_ODB_BACKEND_LOOSE_OPTIONS_VERSION :: 1

/**
 * Stack initializer for odb loose backend options.  Alternatively use
 * `git_odb_backend_loose_options_init` programmatic initialization.
 */
GIT_ODB_BACKEND_LOOSE_OPTIONS_INIT :: {GIT_ODB_BACKEND_LOOSE_OPTIONS_VERSION, 0, -1}

/** Streaming mode */
git_odb_stream_t :: enum c.uint {
	RDONLY = 2,
	WRONLY = 4,
	RW     = 6,
}

/**
* A stream to read/write from a backend.
*
* This represents a stream of data being written to or read from a
* backend. When writing, the frontend functions take care of
* calculating the object's id and all `finalize_write` needs to do is
* store the object with the id it is passed.
*/
git_odb_stream :: struct {
	backend:        ^git_odb_backend,
	mode:           c.uint,
	hash_ctx:       rawptr,
	declared_size:  git_object_size_t,
	received_bytes: git_object_size_t,

	/**
	* Write at most `len` bytes into `buffer` and advance the stream.
	*/
	read: proc "c" (^git_odb_stream, cstring, c.int) -> c.int,

	/**
	* Write `len` bytes from `buffer` into the stream.
	*/
	write: proc "c" (^git_odb_stream, cstring, c.int) -> c.int,

	/**
	* Store the contents of the stream as an object with the id
	* specified in `oid`.
	*
	* This method might not be invoked if:
	* - an error occurs earlier with the `write` callback,
	* - the object referred to by `oid` already exists in any backend, or
	* - the final number of received bytes differs from the size declared
	*   with `git_odb_open_wstream()`
	*/
	finalize_write: proc "c" (^git_odb_stream, ^git_oid) -> c.int,

	/**
	* Free the stream's memory.
	*
	* This method might be called without a call to `finalize_write` if
	* an error occurs or if the object is already present in the ODB.
	*/
	free: proc "c" (^git_odb_stream),
}

/** A stream to write a pack file to the ODB */
git_odb_writepack :: struct {
	backend: ^git_odb_backend,
	append:  proc "c" (^git_odb_writepack, rawptr, c.int, ^git_indexer_progress) -> c.int,
	commit:  proc "c" (^git_odb_writepack, ^git_indexer_progress) -> c.int,
	free:    proc "c" (^git_odb_writepack),
}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Create a backend for a directory containing packfiles.
	*
	* @param[out] out location to store the odb backend pointer
	* @param objects_dir the Git repository's objects directory
	* @return 0 or an error code
	*/
	git_odb_backend_pack :: proc(out: ^^git_odb_backend, objects_dir: cstring) -> c.int ---

	/**
	* Create a backend out of a single packfile
	*
	* This can be useful for inspecting the contents of a single
	* packfile.
	*
	* @param[out] out location to store the odb backend pointer
	* @param index_file path to the packfile's .idx file
	* @return 0 or an error code
	*/
	git_odb_backend_one_pack :: proc(out: ^^git_odb_backend, index_file: cstring) -> c.int ---

	/**
	* Create a backend for loose objects
	*
	* @param[out] out location to store the odb backend pointer
	* @param objects_dir the Git repository's objects directory
	* @param compression_level zlib compression level (0-9), or -1 for the default
	* @param do_fsync if non-zero, perform an fsync on write
	* @param dir_mode permission to use when creating directories, or 0 for default
	* @param file_mode permission to use when creating directories, or 0 for default
	* @return 0 or an error code
	*/
	git_odb_backend_loose :: proc(out: ^^git_odb_backend, objects_dir: cstring, compression_level: c.int, do_fsync: c.int, dir_mode: c.uint, file_mode: c.uint) -> c.int ---
}
