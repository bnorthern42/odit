/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_tree_h__ :: 

/**
* Callback for git_treebuilder_filter
*
* The return value is treated as a boolean, with zero indicating that the
* entry should be left alone and any non-zero value meaning that the
* entry should be removed from the treebuilder list (i.e. filtered out).
*
* @param entry the tree entry for the callback to examine
* @param payload the payload from the caller
* @return 0 to do nothing, non-zero to remove the entry
*/
git_treebuilder_filter_cb :: proc "c" (^git_tree_entry, rawptr) -> c.int

/**
* Callback for the tree traversal method.
*
* @param root the current (relative) root to the entry
* @param entry the tree entry
* @param payload the caller-provided callback payload
* @return a positive value to skip the entry, a negative value to stop the walk
*/
git_treewalk_cb :: proc "c" (cstring, ^git_tree_entry, rawptr) -> c.int

/** Tree traversal modes */
git_treewalk_mode :: enum c.uint {
	RE,  /* Pre-order */
	OST, /* Post-order */
}

/**
* The kind of update to perform
*/
git_tree_update_t :: enum c.uint {
	/** Update or insert an entry at the specified path */
	UPSERT,

	/** Remove an entry from the specified path */
	REMOVE,
}

/**
* An action to perform during the update of a tree
*/
git_tree_update :: struct {
	/** Update action. If it's an removal, only the path is looked at */
	action: git_tree_update_t,

	/** The entry's id */
	id: git_oid,

	/** The filemode/kind of object */
	filemode: git_filemode_t,

	/** The full path from the root tree */
	path: cstring,
}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Lookup a tree object from the repository.
	*
	* @param[out] out Pointer to the looked up tree
	* @param repo The repo to use when locating the tree.
	* @param id Identity of the tree to locate.
	* @return 0 or an error code
	*/
	git_tree_lookup :: proc(out: ^^git_tree, repo: ^git_repository, id: ^git_oid) -> c.int ---

	/**
	* Lookup a tree object from the repository,
	* given a prefix of its identifier (short id).
	*
	* @see git_object_lookup_prefix
	*
	* @param out pointer to the looked up tree
	* @param repo the repo to use when locating the tree.
	* @param id identity of the tree to locate.
	* @param len the length of the short identifier
	* @return 0 or an error code
	*/
	git_tree_lookup_prefix :: proc(out: ^^git_tree, repo: ^git_repository, id: ^git_oid, len: c.int) -> c.int ---

	/**
	* Close an open tree
	*
	* You can no longer use the git_tree pointer after this call.
	*
	* IMPORTANT: You MUST call this method when you stop using a tree to
	* release memory. Failure to do so will cause a memory leak.
	*
	* @param tree The tree to close
	*/
	git_tree_free :: proc(tree: ^git_tree) ---

	/**
	* Get the id of a tree.
	*
	* @param tree a previously loaded tree.
	* @return object identity for the tree.
	*/
	git_tree_id :: proc(tree: ^git_tree) -> ^git_oid ---

	/**
	* Get the repository that contains the tree.
	*
	* @param tree A previously loaded tree.
	* @return Repository that contains this tree.
	*/
	git_tree_owner :: proc(tree: ^git_tree) -> ^git_repository ---

	/**
	* Get the number of entries listed in a tree
	*
	* @param tree a previously loaded tree.
	* @return the number of entries in the tree
	*/
	git_tree_entrycount :: proc(tree: ^git_tree) -> c.int ---

	/**
	* Lookup a tree entry by its filename
	*
	* This returns a git_tree_entry that is owned by the git_tree.  You don't
	* have to free it, but you must not use it after the git_tree is released.
	*
	* @param tree a previously loaded tree.
	* @param filename the filename of the desired entry
	* @return the tree entry; NULL if not found
	*/
	git_tree_entry_byname :: proc(tree: ^git_tree, filename: cstring) -> ^git_tree_entry ---

	/**
	* Lookup a tree entry by its position in the tree
	*
	* This returns a git_tree_entry that is owned by the git_tree.  You don't
	* have to free it, but you must not use it after the git_tree is released.
	*
	* @param tree a previously loaded tree.
	* @param idx the position in the entry list
	* @return the tree entry; NULL if not found
	*/
	git_tree_entry_byindex :: proc(tree: ^git_tree, idx: c.int) -> ^git_tree_entry ---

	/**
	* Lookup a tree entry by SHA value.
	*
	* This returns a git_tree_entry that is owned by the git_tree.  You don't
	* have to free it, but you must not use it after the git_tree is released.
	*
	* Warning: this must examine every entry in the tree, so it is not fast.
	*
	* @param tree a previously loaded tree.
	* @param id the sha being looked for
	* @return the tree entry; NULL if not found
	*/
	git_tree_entry_byid :: proc(tree: ^git_tree, id: ^git_oid) -> ^git_tree_entry ---

	/**
	* Retrieve a tree entry contained in a tree or in any of its subtrees,
	* given its relative path.
	*
	* Unlike the other lookup functions, the returned tree entry is owned by
	* the user and must be freed explicitly with `git_tree_entry_free()`.
	*
	* @param out Pointer where to store the tree entry
	* @param root Previously loaded tree which is the root of the relative path
	* @param path Path to the contained entry
	* @return 0 on success; GIT_ENOTFOUND if the path does not exist
	*/
	git_tree_entry_bypath :: proc(out: ^^git_tree_entry, root: ^git_tree, path: cstring) -> c.int ---

	/**
	* Duplicate a tree entry
	*
	* Create a copy of a tree entry. The returned copy is owned by the user,
	* and must be freed explicitly with `git_tree_entry_free()`.
	*
	* @param dest pointer where to store the copy
	* @param source tree entry to duplicate
	* @return 0 or an error code
	*/
	git_tree_entry_dup :: proc(dest: ^^git_tree_entry, source: ^git_tree_entry) -> c.int ---

	/**
	* Free a user-owned tree entry
	*
	* IMPORTANT: This function is only needed for tree entries owned by the
	* user, such as the ones returned by `git_tree_entry_dup()` or
	* `git_tree_entry_bypath()`.
	*
	* @param entry The entry to free
	*/
	git_tree_entry_free :: proc(entry: ^git_tree_entry) ---

	/**
	* Get the filename of a tree entry
	*
	* @param entry a tree entry
	* @return the name of the file
	*/
	git_tree_entry_name :: proc(entry: ^git_tree_entry) -> cstring ---

	/**
	* Get the id of the object pointed by the entry
	*
	* @param entry a tree entry
	* @return the oid of the object
	*/
	git_tree_entry_id :: proc(entry: ^git_tree_entry) -> ^git_oid ---

	/**
	* Get the type of the object pointed by the entry
	*
	* @param entry a tree entry
	* @return the type of the pointed object
	*/
	git_tree_entry_type :: proc(entry: ^git_tree_entry) -> git_object_t ---

	/**
	* Get the UNIX file attributes of a tree entry
	*
	* @param entry a tree entry
	* @return filemode as an integer
	*/
	git_tree_entry_filemode :: proc(entry: ^git_tree_entry) -> git_filemode_t ---

	/**
	* Get the raw UNIX file attributes of a tree entry
	*
	* This function does not perform any normalization and is only useful
	* if you need to be able to recreate the original tree object.
	*
	* @param entry a tree entry
	* @return filemode as an integer
	*/
	git_tree_entry_filemode_raw :: proc(entry: ^git_tree_entry) -> git_filemode_t ---

	/**
	* Compare two tree entries
	*
	* @param e1 first tree entry
	* @param e2 second tree entry
	* @return <0 if e1 is before e2, 0 if e1 == e2, >0 if e1 is after e2
	*/
	git_tree_entry_cmp :: proc(e1: ^git_tree_entry, e2: ^git_tree_entry) -> c.int ---

	/**
	* Convert a tree entry to the git_object it points to.
	*
	* You must call `git_object_free()` on the object when you are done with it.
	*
	* @param object_out pointer to the converted object
	* @param repo repository where to lookup the pointed object
	* @param entry a tree entry
	* @return 0 or an error code
	*/
	git_tree_entry_to_object :: proc(object_out: ^^git_object, repo: ^git_repository, entry: ^git_tree_entry) -> c.int ---

	/**
	* Create a new tree builder.
	*
	* The tree builder can be used to create or modify trees in memory and
	* write them as tree objects to the database.
	*
	* If the `source` parameter is not NULL, the tree builder will be
	* initialized with the entries of the given tree.
	*
	* If the `source` parameter is NULL, the tree builder will start with no
	* entries and will have to be filled manually.
	*
	* @param out Pointer where to store the tree builder
	* @param repo Repository in which to store the object
	* @param source Source tree to initialize the builder (optional)
	* @return 0 on success; error code otherwise
	*/
	git_treebuilder_new :: proc(out: ^^git_treebuilder, repo: ^git_repository, source: ^git_tree) -> c.int ---

	/**
	* Clear all the entries in the builder
	*
	* @param bld Builder to clear
	* @return 0 on success; error code otherwise
	*/
	git_treebuilder_clear :: proc(bld: ^git_treebuilder) -> c.int ---

	/**
	* Get the number of entries listed in a treebuilder
	*
	* @param bld a previously loaded treebuilder.
	* @return the number of entries in the treebuilder
	*/
	git_treebuilder_entrycount :: proc(bld: ^git_treebuilder) -> c.int ---

	/**
	* Free a tree builder
	*
	* This will clear all the entries and free to builder.
	* Failing to free the builder after you're done using it
	* will result in a memory leak
	*
	* @param bld Builder to free
	*/
	git_treebuilder_free :: proc(bld: ^git_treebuilder) ---

	/**
	* Get an entry from the builder from its filename
	*
	* The returned entry is owned by the builder and should
	* not be freed manually.
	*
	* @param bld Tree builder
	* @param filename Name of the entry
	* @return pointer to the entry; NULL if not found
	*/
	git_treebuilder_get :: proc(bld: ^git_treebuilder, filename: cstring) -> ^git_tree_entry ---

	/**
	* Add or update an entry to the builder
	*
	* Insert a new entry for `filename` in the builder with the
	* given attributes.
	*
	* If an entry named `filename` already exists, its attributes
	* will be updated with the given ones.
	*
	* The optional pointer `out` can be used to retrieve a pointer to the
	* newly created/updated entry.  Pass NULL if you do not need it. The
	* pointer may not be valid past the next operation in this
	* builder. Duplicate the entry if you want to keep it.
	*
	* By default the entry that you are inserting will be checked for
	* validity; that it exists in the object database and is of the
	* correct type.  If you do not want this behavior, set the
	* `GIT_OPT_ENABLE_STRICT_OBJECT_CREATION` library option to false.
	*
	* @param out Pointer to store the entry (optional)
	* @param bld Tree builder
	* @param filename Filename of the entry
	* @param id SHA1 oid of the entry
	* @param filemode Folder attributes of the entry. This parameter must
	*			be valued with one of the following entries: 0040000, 0100644,
	*			0100755, 0120000 or 0160000.
	* @return 0 or an error code
	*/
	git_treebuilder_insert :: proc(out: ^^git_tree_entry, bld: ^git_treebuilder, filename: cstring, id: ^git_oid, filemode: git_filemode_t) -> c.int ---

	/**
	* Remove an entry from the builder by its filename
	*
	* @param bld Tree builder
	* @param filename Filename of the entry to remove
	* @return 0 or an error code
	*/
	git_treebuilder_remove :: proc(bld: ^git_treebuilder, filename: cstring) -> c.int ---

	/**
	* Selectively remove entries in the tree
	*
	* The `filter` callback will be called for each entry in the tree with a
	* pointer to the entry and the provided `payload`; if the callback returns
	* non-zero, the entry will be filtered (removed from the builder).
	*
	* @param bld Tree builder
	* @param filter Callback to filter entries
	* @param payload Extra data to pass to filter callback
	* @return 0 on success, non-zero callback return value, or error code
	*/
	git_treebuilder_filter :: proc(bld: ^git_treebuilder, filter: git_treebuilder_filter_cb, payload: rawptr) -> c.int ---

	/**
	* Write the contents of the tree builder as a tree object
	*
	* The tree builder will be written to the given `repo`, and its
	* identifying SHA1 hash will be stored in the `id` pointer.
	*
	* @param id Pointer to store the OID of the newly written tree
	* @param bld Tree builder to write
	* @return 0 or an error code
	*/
	git_treebuilder_write :: proc(id: ^git_oid, bld: ^git_treebuilder) -> c.int ---

	/**
	* Traverse the entries in a tree and its subtrees in post or pre order.
	*
	* The entries will be traversed in the specified order, children subtrees
	* will be automatically loaded as required, and the `callback` will be
	* called once per entry with the current (relative) root for the entry and
	* the entry data itself.
	*
	* If the callback returns a positive value, the passed entry will be
	* skipped on the traversal (in pre mode). A negative value stops the walk.
	*
	* @param tree The tree to walk
	* @param mode Traversal mode (pre or post-order)
	* @param callback Function to call on each tree entry
	* @param payload Opaque pointer to be passed on each callback
	* @return 0 or an error code
	*/
	git_tree_walk :: proc(tree: ^git_tree, mode: git_treewalk_mode, callback: git_treewalk_cb, payload: rawptr) -> c.int ---

	/**
	* Create an in-memory copy of a tree. The copy must be explicitly
	* free'd or it will leak.
	*
	* @param out Pointer to store the copy of the tree
	* @param source Original tree to copy
	* @return 0
	*/
	git_tree_dup :: proc(out: ^^git_tree, source: ^git_tree) -> c.int ---

	/**
	* Create a tree based on another one with the specified modifications
	*
	* Given the `baseline` perform the changes described in the list of
	* `updates` and create a new tree.
	*
	* This function is optimized for common file/directory addition, removal and
	* replacement in trees. It is much more efficient than reading the tree into a
	* `git_index` and modifying that, but in exchange it is not as flexible.
	*
	* Deleting and adding the same entry is undefined behaviour, changing
	* a tree to a blob or viceversa is not supported.
	*
	* @param out id of the new tree
	* @param repo the repository in which to create the tree, must be the
	* same as for `baseline`
	* @param baseline the tree to base these changes on
	* @param nupdates the number of elements in the update list
	* @param updates the list of updates to perform
	* @return 0 or an error code
	*/
	git_tree_create_updated :: proc(out: ^git_oid, repo: ^git_repository, baseline: ^git_tree, nupdates: c.int, updates: ^git_tree_update) -> c.int ---
}
