/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_rebase_h__ :: 

/**
* Rebase options
*
* Use to tell the rebase machinery how to operate.
*/
git_rebase_options :: struct {}

/**
* Type of rebase operation in-progress after calling `git_rebase_next`.
*/
git_rebase_operation_t :: enum c.uint {
	/**
	* The given commit is to be cherry-picked.  The client should commit
	* the changes and continue if there are no conflicts.
	*/
	PICK,

	/**
	* The given commit is to be cherry-picked, but the client should prompt
	* the user to provide an updated commit message.
	*/
	REWORD,

	/**
	* The given commit is to be cherry-picked, but the client should stop
	* to allow the user to edit the changes before committing them.
	*/
	EDIT,

	/**
	* The given commit is to be squashed into the previous commit.  The
	* commit message will be merged with the previous message.
	*/
	SQUASH,

	/**
	* The given commit is to be squashed into the previous commit.  The
	* commit message from this commit will be discarded.
	*/
	FIXUP,

	/**
	* No commit will be cherry-picked.  The client should run the given
	* command and (if successful) continue.
	*/
	EXEC,
}

/** Current version for the `git_rebase_options` structure */
GIT_REBASE_OPTIONS_VERSION :: 1

/** Static constructor for `git_rebase_options` */
GIT_REBASE_OPTIONS_INIT :: {GIT_REBASE_OPTIONS_VERSION, 0, 0, NULL, GIT_MERGE_OPTIONS_INIT, GIT_CHECKOUT_OPTIONS_INIT, NULL, NULL}

/** Indicates that a rebase operation is not (yet) in progress. */
GIT_REBASE_NO_OPERATION :: SIZE_MAX

/**
* A rebase operation
*
* Describes a single instruction/operation to be performed during the
* rebase.
*/
git_rebase_operation :: struct {
	/** The type of rebase operation. */
	type: git_rebase_operation_t,

	/**
	* The commit ID being cherry-picked.  This will be populated for
	* all operations except those of type `GIT_REBASE_OPERATION_EXEC`.
	*/
	id: git_oid,

	/**
	* The executable the user has requested be run.  This will only
	* be populated for operations of type `GIT_REBASE_OPERATION_EXEC`.
	*/
	exec: cstring,
}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Initialize git_rebase_options structure
	*
	* Initializes a `git_rebase_options` with default values. Equivalent to
	* creating an instance with `GIT_REBASE_OPTIONS_INIT`.
	*
	* @param opts The `git_rebase_options` struct to initialize.
	* @param version The struct version; pass `GIT_REBASE_OPTIONS_VERSION`.
	* @return Zero on success; -1 on failure.
	*/
	git_rebase_options_init :: proc(opts: ^git_rebase_options, version: c.uint) -> c.int ---

	/**
	* Initializes a rebase operation to rebase the changes in `branch`
	* relative to `upstream` onto another branch.  To begin the rebase
	* process, call `git_rebase_next`.  When you have finished with this
	* object, call `git_rebase_free`.
	*
	* @param out Pointer to store the rebase object
	* @param repo The repository to perform the rebase
	* @param branch The terminal commit to rebase, or NULL to rebase the
	*               current branch
	* @param upstream The commit to begin rebasing from, or NULL to rebase all
	*                 reachable commits
	* @param onto The branch to rebase onto, or NULL to rebase onto the given
	*             upstream
	* @param opts Options to specify how rebase is performed, or NULL
	* @return Zero on success; -1 on failure.
	*/
	git_rebase_init :: proc(out: ^^git_rebase, repo: ^git_repository, branch: ^git_annotated_commit, upstream: ^git_annotated_commit, onto: ^git_annotated_commit, opts: ^git_rebase_options) -> c.int ---

	/**
	* Opens an existing rebase that was previously started by either an
	* invocation of `git_rebase_init` or by another client.
	*
	* @param out Pointer to store the rebase object
	* @param repo The repository that has a rebase in-progress
	* @param opts Options to specify how rebase is performed
	* @return Zero on success; -1 on failure.
	*/
	git_rebase_open :: proc(out: ^^git_rebase, repo: ^git_repository, opts: ^git_rebase_options) -> c.int ---

	/**
	* Gets the original `HEAD` ref name for merge rebases.
	*
	* @param rebase The in-progress rebase.
	* @return The original `HEAD` ref name
	*/
	git_rebase_orig_head_name :: proc(rebase: ^git_rebase) -> cstring ---

	/**
	* Gets the original `HEAD` id for merge rebases.
	*
	* @param rebase The in-progress rebase.
	* @return The original `HEAD` id
	*/
	git_rebase_orig_head_id :: proc(rebase: ^git_rebase) -> ^git_oid ---

	/**
	* Gets the `onto` ref name for merge rebases.
	*
	* @param rebase The in-progress rebase.
	* @return The `onto` ref name
	*/
	git_rebase_onto_name :: proc(rebase: ^git_rebase) -> cstring ---

	/**
	* Gets the `onto` id for merge rebases.
	*
	* @param rebase The in-progress rebase.
	* @return The `onto` id
	*/
	git_rebase_onto_id :: proc(rebase: ^git_rebase) -> ^git_oid ---

	/**
	* Gets the count of rebase operations that are to be applied.
	*
	* @param rebase The in-progress rebase
	* @return The number of rebase operations in total
	*/
	git_rebase_operation_entrycount :: proc(rebase: ^git_rebase) -> c.int ---

	/**
	* Gets the index of the rebase operation that is currently being applied.
	* If the first operation has not yet been applied (because you have
	* called `init` but not yet `next`) then this returns
	* `GIT_REBASE_NO_OPERATION`.
	*
	* @param rebase The in-progress rebase
	* @return The index of the rebase operation currently being applied.
	*/
	git_rebase_operation_current :: proc(rebase: ^git_rebase) -> c.int ---

	/**
	* Gets the rebase operation specified by the given index.
	*
	* @param rebase The in-progress rebase
	* @param idx The index of the rebase operation to retrieve
	* @return The rebase operation or NULL if `idx` was out of bounds
	*/
	git_rebase_operation_byindex :: proc(rebase: ^git_rebase, idx: c.int) -> ^git_rebase_operation ---

	/**
	* Performs the next rebase operation and returns the information about it.
	* If the operation is one that applies a patch (which is any operation except
	* GIT_REBASE_OPERATION_EXEC) then the patch will be applied and the index and
	* working directory will be updated with the changes.  If there are conflicts,
	* you will need to address those before committing the changes.
	*
	* @param operation Pointer to store the rebase operation that is to be performed next
	* @param rebase The rebase in progress
	* @return Zero on success; -1 on failure.
	*/
	git_rebase_next :: proc(operation: ^^git_rebase_operation, rebase: ^git_rebase) -> c.int ---

	/**
	* Gets the index produced by the last operation, which is the result
	* of `git_rebase_next` and which will be committed by the next
	* invocation of `git_rebase_commit`.  This is useful for resolving
	* conflicts in an in-memory rebase before committing them.  You must
	* call `git_index_free` when you are finished with this.
	*
	* This is only applicable for in-memory rebases; for rebases within
	* a working directory, the changes were applied to the repository's
	* index.
	*
	* @param index The result index of the last operation.
	* @param rebase The in-progress rebase.
	* @return 0 or an error code
	*/
	git_rebase_inmemory_index :: proc(index: ^^git_index, rebase: ^git_rebase) -> c.int ---

	/**
	* Commits the current patch.  You must have resolved any conflicts that
	* were introduced during the patch application from the `git_rebase_next`
	* invocation.
	*
	* @param id Pointer in which to store the OID of the newly created commit
	* @param rebase The rebase that is in-progress
	* @param author The author of the updated commit, or NULL to keep the
	*        author from the original commit
	* @param committer The committer of the rebase
	* @param message_encoding The encoding for the message in the commit,
	*        represented with a standard encoding name.  If message is NULL,
	*        this should also be NULL, and the encoding from the original
	*        commit will be maintained.  If message is specified, this may be
	*        NULL to indicate that "UTF-8" is to be used.
	* @param message The message for this commit, or NULL to use the message
	*        from the original commit.
	* @return Zero on success, GIT_EUNMERGED if there are unmerged changes in
	*        the index, GIT_EAPPLIED if the current commit has already
	*        been applied to the upstream and there is nothing to commit,
	*        -1 on failure.
	*/
	git_rebase_commit :: proc(id: ^git_oid, rebase: ^git_rebase, author: ^git_signature, committer: ^git_signature, message_encoding: cstring, message: cstring) -> c.int ---

	/**
	* Aborts a rebase that is currently in progress, resetting the repository
	* and working directory to their state before rebase began.
	*
	* @param rebase The rebase that is in-progress
	* @return Zero on success; GIT_ENOTFOUND if a rebase is not in progress,
	*         -1 on other errors.
	*/
	git_rebase_abort :: proc(rebase: ^git_rebase) -> c.int ---

	/**
	* Finishes a rebase that is currently in progress once all patches have
	* been applied.
	*
	* @param rebase The rebase that is in-progress
	* @param signature The identity that is finishing the rebase (optional)
	* @return Zero on success; -1 on error
	*/
	git_rebase_finish :: proc(rebase: ^git_rebase, signature: ^git_signature) -> c.int ---

	/**
	* Frees the `git_rebase` object.
	*
	* @param rebase The rebase object
	*/
	git_rebase_free :: proc(rebase: ^git_rebase) ---
}
