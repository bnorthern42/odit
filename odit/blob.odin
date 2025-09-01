/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_blob_h__ :: 

/**
* Flags to control the functionality of `git_blob_filter`.
*
* @flags
*/
git_blob_filter_flag_t :: enum c.uint {
	/** When set, filters will not be applied to binary files. */
	CHECK_FOR_BINARY = 1,

	/**
	* When set, filters will not load configuration from the
	* system-wide `gitattributes` in `/etc` (or system equivalent).
	*/
	NO_SYSTEM_ATTRIBUTES = 2,

	/**
	* When set, filters will be loaded from a `.gitattributes` file
	* in the HEAD commit.
	*/
	ATTRIBUTES_FROM_HEAD = 4,

	/**
	* When set, filters will be loaded from a `.gitattributes` file
	* in the specified commit.
	*/
	ATTRIBUTES_FROM_COMMIT = 8,
}

/**
* The options used when applying filter options to a file.
*
* Initialize with `GIT_BLOB_FILTER_OPTIONS_INIT`. Alternatively, you can
* use `git_blob_filter_options_init`.
*
* @options[version] GIT_BLOB_FILTER_OPTIONS_VERSION
* @options[init_macro] GIT_BLOB_FILTER_OPTIONS_INIT
* @options[init_function] git_blob_filter_options_init
*/
git_blob_filter_options :: struct {
	/** Version number of the options structure. */
	version: c.int,

	/**
	* Flags to control the filtering process, see `git_blob_filter_flag_t` above.
	*
	* @type[flags] git_blob_filter_flag_t
	*/
	flags: u32,

	/**
	* This value is unused and reserved for API compatibility.
	*
	* @deprecated this value should not be set
	*/
	commit_id: ^git_oid,

	/**
	* The commit to load attributes from, when
	* `GIT_BLOB_FILTER_ATTRIBUTES_FROM_COMMIT` is specified.
	*/
	attr_commit_id: git_oid,
}

/**
 * The current version number for the `git_blob_filter_options` structure ABI.
 */
GIT_BLOB_FILTER_OPTIONS_VERSION :: 1

/**
 * The default values for `git_blob_filter_options`.
 */
GIT_BLOB_FILTER_OPTIONS_INIT :: {GIT_BLOB_FILTER_OPTIONS_VERSION, GIT_BLOB_FILTER_CHECK_FOR_BINARY}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Lookup a blob object from a repository.
	*
	* @param[out] blob pointer to the looked up blob
	* @param repo the repo to use when locating the blob.
	* @param id identity of the blob to locate.
	* @return 0 or an error code
	*/
	git_blob_lookup :: proc(blob: ^^git_blob, repo: ^git_repository, id: ^git_oid) -> c.int ---

	/**
	* Lookup a blob object from a repository,
	* given a prefix of its identifier (short id).
	*
	* @see git_object_lookup_prefix
	*
	* @param[out] blob pointer to the looked up blob
	* @param repo the repo to use when locating the blob.
	* @param id identity of the blob to locate.
	* @param len the length of the short identifier
	* @return 0 or an error code
	*/
	git_blob_lookup_prefix :: proc(blob: ^^git_blob, repo: ^git_repository, id: ^git_oid, len: c.int) -> c.int ---

	/**
	* Close an open blob
	*
	* This is a wrapper around git_object_free()
	*
	* IMPORTANT:
	* It *is* necessary to call this method when you stop
	* using a blob. Failure to do so will cause a memory leak.
	*
	* @param blob the blob to close
	*/
	git_blob_free :: proc(blob: ^git_blob) ---

	/**
	* Get the id of a blob.
	*
	* @param blob a previously loaded blob.
	* @return SHA1 hash for this blob.
	*/
	git_blob_id :: proc(blob: ^git_blob) -> ^git_oid ---

	/**
	* Get the repository that contains the blob.
	*
	* @param blob A previously loaded blob.
	* @return Repository that contains this blob.
	*/
	git_blob_owner :: proc(blob: ^git_blob) -> ^git_repository ---

	/**
	* Get a read-only buffer with the raw content of a blob.
	*
	* A pointer to the raw content of a blob is returned;
	* this pointer is owned internally by the object and shall
	* not be free'd. The pointer may be invalidated at a later
	* time.
	*
	* @param blob pointer to the blob
	* @return @type `unsigned char *` the pointer, or NULL on error
	*/
	git_blob_rawcontent :: proc(blob: ^git_blob) -> rawptr ---

	/**
	* Get the size in bytes of the contents of a blob
	*
	* @param blob pointer to the blob
	* @return size in bytes
	*/
	git_blob_rawsize :: proc(blob: ^git_blob) -> git_object_size_t ---

	/**
	* Initialize git_blob_filter_options structure
	*
	* Initializes a `git_blob_filter_options` with default values. Equivalent
	* to creating an instance with `GIT_BLOB_FILTER_OPTIONS_INIT`.
	*
	* @param opts The `git_blob_filter_options` struct to initialize.
	* @param version The struct version; pass GIT_BLOB_FILTER_OPTIONS_VERSION
	* @return Zero on success; -1 on failure.
	*/
	git_blob_filter_options_init :: proc(opts: ^git_blob_filter_options, version: c.uint) -> c.int ---

	/**
	* Get a buffer with the filtered content of a blob.
	*
	* This applies filters as if the blob was being checked out to the
	* working directory under the specified filename.  This may apply
	* CRLF filtering or other types of changes depending on the file
	* attributes set for the blob and the content detected in it.
	*
	* The output is written into a `git_buf` which the caller must dispose
	* when done (via `git_buf_dispose`).
	*
	* If no filters need to be applied, then the `out` buffer will just
	* be populated with a pointer to the raw content of the blob.  In
	* that case, be careful to *not* free the blob until done with the
	* buffer or copy it into memory you own.
	*
	* @param out The git_buf to be filled in
	* @param blob Pointer to the blob
	* @param as_path Path used for file attribute lookups, etc.
	* @param opts Options to use for filtering the blob
	* @return @type[enum] git_error_code 0 on success or an error code
	*/
	git_blob_filter :: proc(out: ^git_buf, blob: ^git_blob, as_path: cstring, opts: ^git_blob_filter_options) -> c.int ---

	/**
	* Read a file from the working folder of a repository and write it
	* to the object database.
	*
	* @param[out] id return the id of the written blob
	* @param repo repository where the blob will be written.
	*	this repository cannot be bare
	* @param relative_path file from which the blob will be created,
	*	relative to the repository's working dir
	* @return 0 or an error code
	*/
	git_blob_create_from_workdir :: proc(id: ^git_oid, repo: ^git_repository, relative_path: cstring) -> c.int ---

	/**
	* Read a file from the filesystem (not necessarily inside the
	* working folder of the repository) and write it to the object
	* database.
	*
	* @param[out] id return the id of the written blob
	* @param repo repository where the blob will be written.
	*	this repository can be bare or not
	* @param path file from which the blob will be created
	* @return 0 or an error code
	*/
	git_blob_create_from_disk :: proc(id: ^git_oid, repo: ^git_repository, path: cstring) -> c.int ---

	/**
	* Create a stream to write a new blob into the object database.
	*
	* This function may need to buffer the data on disk and will in
	* general not be the right choice if you know the size of the data
	* to write. If you have data in memory, use
	* `git_blob_create_from_buffer()`. If you do not, but know the size of
	* the contents (and don't want/need to perform filtering), use
	* `git_odb_open_wstream()`.
	*
	* Don't close this stream yourself but pass it to
	* `git_blob_create_from_stream_commit()` to commit the write to the
	* object db and get the object id.
	*
	* If the `hintpath` parameter is filled, it will be used to determine
	* what git filters should be applied to the object before it is written
	* to the object database.
	*
	* @param[out] out the stream into which to write
	* @param repo Repository where the blob will be written.
	*        This repository can be bare or not.
	* @param hintpath If not NULL, will be used to select data filters
	*        to apply onto the content of the blob to be created.
	* @return 0 or error code
	*/
	git_blob_create_from_stream :: proc(out: ^^git_writestream, repo: ^git_repository, hintpath: cstring) -> c.int ---

	/**
	* Close the stream and finalize writing the blob to the object database.
	*
	* The stream will be closed and freed.
	*
	* @param[out] out the id of the new blob
	* @param stream the stream to close
	* @return 0 or an error code
	*/
	git_blob_create_from_stream_commit :: proc(out: ^git_oid, stream: ^git_writestream) -> c.int ---

	/**
	* Write an in-memory buffer to the object database as a blob.
	*
	* @param[out] id return the id of the written blob
	* @param repo repository where the blob will be written
	* @param buffer data to be written into the blob
	* @param len length of the data
	* @return 0 or an error code
	*/
	git_blob_create_from_buffer :: proc(id: ^git_oid, repo: ^git_repository, buffer: rawptr, len: c.int) -> c.int ---

	/**
	* Determine if the blob content is most likely binary or not.
	*
	* The heuristic used to guess if a file is binary is taken from core git:
	* Searching for NUL bytes and looking for a reasonable ratio of printable
	* to non-printable characters among the first 8000 bytes.
	*
	* @param blob The blob which content should be analyzed
	* @return @type bool 1 if the content of the blob is detected
	* as binary; 0 otherwise.
	*/
	git_blob_is_binary :: proc(blob: ^git_blob) -> c.int ---

	/**
	* Determine if the given content is most certainly binary or not;
	* this is the same mechanism used by `git_blob_is_binary` but only
	* looking at raw data.
	*
	* @param data The blob data which content should be analyzed
	* @param len The length of the data
	* @return 1 if the content of the blob is detected
	* as binary; 0 otherwise.
	*/
	git_blob_data_is_binary :: proc(data: cstring, len: c.int) -> c.int ---

	/**
	* Create an in-memory copy of a blob. The copy must be explicitly
	* free'd or it will leak.
	*
	* @param[out] out Pointer to store the copy of the object
	* @param source Original object to copy
	* @return 0.
	*/
	git_blob_dup :: proc(out: ^^git_blob, source: ^git_blob) -> c.int ---
}
