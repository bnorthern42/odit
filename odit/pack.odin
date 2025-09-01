/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_pack_h__ :: 

/**
* Stages that are reported by the packbuilder progress callback.
*/
git_packbuilder_stage_t :: enum c.uint {
	ADDING_OBJECTS,
	DELTAFICATION,
}

/**
* Callback used to iterate over packed objects
*
* @see git_packbuilder_foreach
*
* @param buf A pointer to the object's data
* @param size The size of the underlying object
* @param payload Payload passed to git_packbuilder_foreach
* @return non-zero to terminate the iteration
*/
git_packbuilder_foreach_cb :: proc "c" (rawptr, c.int, rawptr) -> c.int

/**
* Packbuilder progress notification function.
*
* @param stage the stage of the packbuilder
* @param current the current object
* @param total the total number of objects
* @param payload the callback payload
* @return 0 on success or an error code
*/
git_packbuilder_progress :: proc "c" (c.int, u32, u32, rawptr) -> c.int

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Initialize a new packbuilder
	*
	* @param out The new packbuilder object
	* @param repo The repository
	*
	* @return 0 or an error code
	*/
	git_packbuilder_new :: proc(out: ^^git_packbuilder, repo: ^git_repository) -> c.int ---

	/**
	* Set number of threads to spawn
	*
	* By default, libgit2 won't spawn any threads at all;
	* when set to 0, libgit2 will autodetect the number of
	* CPUs.
	*
	* @param pb The packbuilder
	* @param n Number of threads to spawn
	* @return number of actual threads to be used
	*/
	git_packbuilder_set_threads :: proc(pb: ^git_packbuilder, n: c.uint) -> c.uint ---

	/**
	* Insert a single object
	*
	* For an optimal pack it's mandatory to insert objects in recency order,
	* commits followed by trees and blobs.
	*
	* @param pb The packbuilder
	* @param id The oid of the commit
	* @param name The name; might be NULL
	*
	* @return 0 or an error code
	*/
	git_packbuilder_insert :: proc(pb: ^git_packbuilder, id: ^git_oid, name: cstring) -> c.int ---

	/**
	* Insert a root tree object
	*
	* This will add the tree as well as all referenced trees and blobs.
	*
	* @param pb The packbuilder
	* @param id The oid of the root tree
	*
	* @return 0 or an error code
	*/
	git_packbuilder_insert_tree :: proc(pb: ^git_packbuilder, id: ^git_oid) -> c.int ---

	/**
	* Insert a commit object
	*
	* This will add a commit as well as the completed referenced tree.
	*
	* @param pb The packbuilder
	* @param id The oid of the commit
	*
	* @return 0 or an error code
	*/
	git_packbuilder_insert_commit :: proc(pb: ^git_packbuilder, id: ^git_oid) -> c.int ---

	/**
	* Insert objects as given by the walk
	*
	* Those commits and all objects they reference will be inserted into
	* the packbuilder.
	*
	* @param pb the packbuilder
	* @param walk the revwalk to use to fill the packbuilder
	*
	* @return 0 or an error code
	*/
	git_packbuilder_insert_walk :: proc(pb: ^git_packbuilder, walk: ^git_revwalk) -> c.int ---

	/**
	* Recursively insert an object and its referenced objects
	*
	* Insert the object as well as any object it references.
	*
	* @param pb the packbuilder
	* @param id the id of the root object to insert
	* @param name optional name for the object
	* @return 0 or an error code
	*/
	git_packbuilder_insert_recur :: proc(pb: ^git_packbuilder, id: ^git_oid, name: cstring) -> c.int ---

	/**
	* Write the contents of the packfile to an in-memory buffer
	*
	* The contents of the buffer will become a valid packfile, even though there
	* will be no attached index
	*
	* @param buf Buffer where to write the packfile
	* @param pb The packbuilder
	* @return 0 or an error code
	*/
	git_packbuilder_write_buf :: proc(buf: ^git_buf, pb: ^git_packbuilder) -> c.int ---

	/**
	* Write the new pack and corresponding index file to path.
	*
	* @param pb The packbuilder
	* @param path Path to the directory where the packfile and index should be stored, or NULL for default location
	* @param mode permissions to use creating a packfile or 0 for defaults
	* @param progress_cb function to call with progress information from the indexer (optional)
	* @param progress_cb_payload payload for the progress callback (optional)
	*
	* @return 0 or an error code
	*/
	git_packbuilder_write :: proc(pb: ^git_packbuilder, path: cstring, mode: c.uint, progress_cb: git_indexer_progress_cb, progress_cb_payload: rawptr) -> c.int ---

	/**
	* Get the packfile's hash
	*
	* A packfile's name is derived from the sorted hashing of all object
	* names. This is only correct after the packfile has been written.
	*
	* @deprecated use git_packbuilder_name
	* @param pb The packbuilder object
	* @return 0 or an error code
	*/
	git_packbuilder_hash :: proc(pb: ^git_packbuilder) -> ^git_oid ---

	/**
	* Get the unique name for the resulting packfile.
	*
	* The packfile's name is derived from the packfile's content.
	* This is only correct after the packfile has been written.
	*
	* @param pb the packbuilder instance
	* @return a NUL terminated string for the packfile name
	*/
	git_packbuilder_name :: proc(pb: ^git_packbuilder) -> cstring ---

	/**
	* Create the new pack and pass each object to the callback
	*
	* @param pb the packbuilder
	* @param cb the callback to call with each packed object's buffer
	* @param payload the callback's data
	* @return 0 or an error code
	*/
	git_packbuilder_foreach :: proc(pb: ^git_packbuilder, cb: git_packbuilder_foreach_cb, payload: rawptr) -> c.int ---

	/**
	* Get the total number of objects the packbuilder will write out
	*
	* @param pb the packbuilder
	* @return the number of objects in the packfile
	*/
	git_packbuilder_object_count :: proc(pb: ^git_packbuilder) -> c.int ---

	/**
	* Get the number of objects the packbuilder has already written out
	*
	* @param pb the packbuilder
	* @return the number of objects which have already been written
	*/
	git_packbuilder_written :: proc(pb: ^git_packbuilder) -> c.int ---

	/**
	* Set the callbacks for a packbuilder
	*
	* @param pb The packbuilder object
	* @param progress_cb Function to call with progress information during
	* pack building. Be aware that this is called inline with pack building
	* operations, so performance may be affected.
	* When progress_cb returns an error, the pack building process will be
	* aborted and the error will be returned from the invoked function.
	* `pb` must then be freed.
	* @param progress_cb_payload Payload for progress callback.
	* @return 0 or an error code
	*/
	git_packbuilder_set_callbacks :: proc(pb: ^git_packbuilder, progress_cb: git_packbuilder_progress, progress_cb_payload: rawptr) -> c.int ---

	/**
	* Free the packbuilder and all associated data
	*
	* @param pb The packbuilder
	*/
	git_packbuilder_free :: proc(pb: ^git_packbuilder) ---
}
