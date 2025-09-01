/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_transaction_h__ :: 

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Create a new transaction object
	*
	* This does not lock anything, but sets up the transaction object to
	* know from which repository to lock.
	*
	* @param out the resulting transaction
	* @param repo the repository in which to lock
	* @return 0 or an error code
	*/
	git_transaction_new :: proc(out: ^^git_transaction, repo: ^git_repository) -> c.int ---

	/**
	* Lock a reference
	*
	* Lock the specified reference. This is the first step to updating a
	* reference.
	*
	* @param tx the transaction
	* @param refname the reference to lock
	* @return 0 or an error message
	*/
	git_transaction_lock_ref :: proc(tx: ^git_transaction, refname: cstring) -> c.int ---

	/**
	* Set the target of a reference
	*
	* Set the target of the specified reference. This reference must be
	* locked.
	*
	* @param tx the transaction
	* @param refname reference to update
	* @param target target to set the reference to
	* @param sig signature to use in the reflog; pass NULL to read the identity from the config
	* @param msg message to use in the reflog
	* @return 0, GIT_ENOTFOUND if the reference is not among the locked ones, or an error code
	*/
	git_transaction_set_target :: proc(tx: ^git_transaction, refname: cstring, target: ^git_oid, sig: ^git_signature, msg: cstring) -> c.int ---

	/**
	* Set the target of a reference
	*
	* Set the target of the specified reference. This reference must be
	* locked.
	*
	* @param tx the transaction
	* @param refname reference to update
	* @param target target to set the reference to
	* @param sig signature to use in the reflog; pass NULL to read the identity from the config
	* @param msg message to use in the reflog
	* @return 0, GIT_ENOTFOUND if the reference is not among the locked ones, or an error code
	*/
	git_transaction_set_symbolic_target :: proc(tx: ^git_transaction, refname: cstring, target: cstring, sig: ^git_signature, msg: cstring) -> c.int ---

	/**
	* Set the reflog of a reference
	*
	* Set the specified reference's reflog. If this is combined with
	* setting the target, that update won't be written to the reflog.
	*
	* @param tx the transaction
	* @param refname the reference whose reflog to set
	* @param reflog the reflog as it should be written out
	* @return 0, GIT_ENOTFOUND if the reference is not among the locked ones, or an error code
	*/
	git_transaction_set_reflog :: proc(tx: ^git_transaction, refname: cstring, reflog: ^git_reflog) -> c.int ---

	/**
	* Remove a reference
	*
	* @param tx the transaction
	* @param refname the reference to remove
	* @return 0, GIT_ENOTFOUND if the reference is not among the locked ones, or an error code
	*/
	git_transaction_remove :: proc(tx: ^git_transaction, refname: cstring) -> c.int ---

	/**
	* Commit the changes from the transaction
	*
	* Perform the changes that have been queued. The updates will be made
	* one by one, and the first failure will stop the processing.
	*
	* @param tx the transaction
	* @return 0 or an error code
	*/
	git_transaction_commit :: proc(tx: ^git_transaction) -> c.int ---

	/**
	* Free the resources allocated by this transaction
	*
	* If any references remain locked, they will be unlocked without any
	* changes made to them.
	*
	* @param tx the transaction
	*/
	git_transaction_free :: proc(tx: ^git_transaction) ---
}
