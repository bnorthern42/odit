/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_note_h__ :: 

/**
* Callback for git_note_foreach.
*
* @param blob_id object id of the blob containing the message
* @param annotated_object_id the id of the object being annotated
* @param payload user-specified data to the foreach function
* @return 0 on success, or a negative number on failure
*/
git_note_foreach_cb :: proc "c" (^git_oid, ^git_oid, rawptr) -> c.int

/**
* note iterator
*/
git_note_iterator :: struct {}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Creates a new iterator for notes
	*
	* The iterator must be freed manually by the user.
	*
	* @param out pointer to the iterator
	* @param repo repository where to look up the note
	* @param notes_ref canonical name of the reference to use (optional); defaults to
	*                  "refs/notes/commits"
	*
	* @return 0 or an error code
	*/
	git_note_iterator_new :: proc(out: ^^git_note_iterator, repo: ^c.int, notes_ref: cstring) -> c.int ---

	/**
	* Creates a new iterator for notes from a commit
	*
	* The iterator must be freed manually by the user.
	*
	* @param out pointer to the iterator
	* @param notes_commit a pointer to the notes commit object
	*
	* @return 0 or an error code
	*/
	git_note_commit_iterator_new :: proc(out: ^^git_note_iterator, notes_commit: ^c.int) -> c.int ---

	/**
	* Frees an git_note_iterator
	*
	* @param it pointer to the iterator
	*/
	git_note_iterator_free :: proc(it: ^git_note_iterator) ---

	/**
	* Return the current item (note_id and annotated_id) and advance the iterator
	* internally to the next value
	*
	* @param note_id id of blob containing the message
	* @param annotated_id id of the git object being annotated
	* @param it pointer to the iterator
	*
	* @return 0 (no error), GIT_ITEROVER (iteration is done) or an error code
	*         (negative value)
	*/
	git_note_next :: proc(note_id: ^git_oid, annotated_id: ^git_oid, it: ^git_note_iterator) -> c.int ---

	/**
	* Read the note for an object
	*
	* The note must be freed manually by the user.
	*
	* @param out pointer to the read note; NULL in case of error
	* @param repo repository where to look up the note
	* @param notes_ref canonical name of the reference to use (optional); defaults to
	*                  "refs/notes/commits"
	* @param oid OID of the git object to read the note from
	*
	* @return 0 or an error code
	*/
	git_note_read :: proc(out: ^^c.int, repo: ^c.int, notes_ref: cstring, oid: ^git_oid) -> c.int ---

	/**
	* Read the note for an object from a note commit
	*
	* The note must be freed manually by the user.
	*
	* @param out pointer to the read note; NULL in case of error
	* @param repo repository where to look up the note
	* @param notes_commit a pointer to the notes commit object
	* @param oid OID of the git object to read the note from
	*
	* @return 0 or an error code
	*/
	git_note_commit_read :: proc(out: ^^c.int, repo: ^c.int, notes_commit: ^c.int, oid: ^git_oid) -> c.int ---

	/**
	* Get the note author
	*
	* @param note the note
	* @return the author
	*/
	git_note_author :: proc(note: ^c.int) -> ^c.int ---

	/**
	* Get the note committer
	*
	* @param note the note
	* @return the committer
	*/
	git_note_committer :: proc(note: ^c.int) -> ^c.int ---

	/**
	* Get the note message
	*
	* @param note the note
	* @return the note message
	*/
	git_note_message :: proc(note: ^c.int) -> cstring ---

	/**
	* Get the note object's id
	*
	* @param note the note
	* @return the note object's id
	*/
	git_note_id :: proc(note: ^c.int) -> ^git_oid ---

	/**
	* Add a note for an object
	*
	* @param out pointer to store the OID (optional); NULL in case of error
	* @param repo repository where to store the note
	* @param notes_ref canonical name of the reference to use (optional);
	*					defaults to "refs/notes/commits"
	* @param author signature of the notes commit author
	* @param committer signature of the notes commit committer
	* @param oid OID of the git object to decorate
	* @param note Content of the note to add for object oid
	* @param force Overwrite existing note
	*
	* @return 0 or an error code
	*/
	git_note_create :: proc(out: ^git_oid, repo: ^c.int, notes_ref: cstring, author: ^c.int, committer: ^c.int, oid: ^git_oid, note: cstring, force: c.int) -> c.int ---

	/**
	* Add a note for an object from a commit
	*
	* This function will create a notes commit for a given object,
	* the commit is a dangling commit, no reference is created.
	*
	* @param notes_commit_out pointer to store the commit (optional);
	*					NULL in case of error
	* @param notes_blob_out a point to the id of a note blob (optional)
	* @param repo repository where the note will live
	* @param parent Pointer to parent note
	*					or NULL if this shall start a new notes tree
	* @param author signature of the notes commit author
	* @param committer signature of the notes commit committer
	* @param oid OID of the git object to decorate
	* @param note Content of the note to add for object oid
	* @param allow_note_overwrite Overwrite existing note
	*
	* @return 0 or an error code
	*/
	git_note_commit_create :: proc(notes_commit_out: ^git_oid, notes_blob_out: ^git_oid, repo: ^c.int, parent: ^c.int, author: ^c.int, committer: ^c.int, oid: ^git_oid, note: cstring, allow_note_overwrite: c.int) -> c.int ---

	/**
	* Remove the note for an object
	*
	* @param repo repository where the note lives
	* @param notes_ref canonical name of the reference to use (optional);
	*					defaults to "refs/notes/commits"
	* @param author signature of the notes commit author
	* @param committer signature of the notes commit committer
	* @param oid OID of the git object to remove the note from
	*
	* @return 0 or an error code
	*/
	git_note_remove :: proc(repo: ^c.int, notes_ref: cstring, author: ^c.int, committer: ^c.int, oid: ^git_oid) -> c.int ---

	/**
	* Remove the note for an object
	*
	* @param notes_commit_out pointer to store the new notes commit (optional);
	*					NULL in case of error.
	*					When removing a note a new tree containing all notes
	*					sans the note to be removed is created and a new commit
	*					pointing to that tree is also created.
	*					In the case where the resulting tree is an empty tree
	*					a new commit pointing to this empty tree will be returned.
	* @param repo repository where the note lives
	* @param notes_commit a pointer to the notes commit object
	* @param author signature of the notes commit author
	* @param committer signature of the notes commit committer
	* @param oid OID of the git object to remove the note from
	*
	* @return 0 or an error code
	*/
	git_note_commit_remove :: proc(notes_commit_out: ^git_oid, repo: ^c.int, notes_commit: ^c.int, author: ^c.int, committer: ^c.int, oid: ^git_oid) -> c.int ---

	/**
	* Free a git_note object
	*
	* @param note git_note object
	*/
	git_note_free :: proc(note: ^c.int) ---

	/**
	* Get the default notes reference for a repository
	*
	* @param out buffer in which to store the name of the default notes reference
	* @param repo The Git repository
	*
	* @return 0 or an error code
	*/
	git_note_default_ref :: proc(out: ^c.int, repo: ^c.int) -> c.int ---

	/**
	* Loop over all the notes within a specified namespace
	* and issue a callback for each one.
	*
	* @param repo Repository where to find the notes.
	*
	* @param notes_ref Reference to read from (optional); defaults to
	*        "refs/notes/commits".
	*
	* @param note_cb Callback to invoke per found annotation.  Return non-zero
	*        to stop looping.
	*
	* @param payload Extra parameter to callback function.
	*
	* @return 0 on success, non-zero callback return value, or error code
	*/
	git_note_foreach :: proc(repo: ^c.int, notes_ref: cstring, note_cb: git_note_foreach_cb, payload: rawptr) -> c.int ---
}
