/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_annotated_commit_h__ :: 

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Creates a `git_annotated_commit` from the given reference.
	* The resulting git_annotated_commit must be freed with
	* `git_annotated_commit_free`.
	*
	* @param[out] out pointer to store the git_annotated_commit result in
	* @param repo repository that contains the given reference
	* @param ref reference to use to lookup the git_annotated_commit
	* @return 0 on success or error code
	*/
	git_annotated_commit_from_ref :: proc(out: ^^git_annotated_commit, repo: ^git_repository, ref: ^git_reference) -> c.int ---

	/**
	* Creates a `git_annotated_commit` from the given fetch head data.
	* The resulting git_annotated_commit must be freed with
	* `git_annotated_commit_free`.
	*
	* @param[out] out pointer to store the git_annotated_commit result in
	* @param repo repository that contains the given commit
	* @param branch_name name of the (remote) branch
	* @param remote_url url of the remote
	* @param id the commit object id of the remote branch
	* @return 0 on success or error code
	*/
	git_annotated_commit_from_fetchhead :: proc(out: ^^git_annotated_commit, repo: ^git_repository, branch_name: cstring, remote_url: cstring, id: ^git_oid) -> c.int ---

	/**
	* Creates a `git_annotated_commit` from the given commit id.
	* The resulting git_annotated_commit must be freed with
	* `git_annotated_commit_free`.
	*
	* An annotated commit contains information about how it was
	* looked up, which may be useful for functions like merge or
	* rebase to provide context to the operation.  For example,
	* conflict files will include the name of the source or target
	* branches being merged.  It is therefore preferable to use the
	* most specific function (eg `git_annotated_commit_from_ref`)
	* instead of this one when that data is known.
	*
	* @param[out] out pointer to store the git_annotated_commit result in
	* @param repo repository that contains the given commit
	* @param id the commit object id to lookup
	* @return 0 on success or error code
	*/
	git_annotated_commit_lookup :: proc(out: ^^git_annotated_commit, repo: ^git_repository, id: ^git_oid) -> c.int ---

	/**
	* Creates a `git_annotated_commit` from a revision string.
	*
	* See `man gitrevisions`, or
	* http://git-scm.com/docs/git-rev-parse.html#_specifying_revisions for
	* information on the syntax accepted.
	*
	* @param[out] out pointer to store the git_annotated_commit result in
	* @param repo repository that contains the given commit
	* @param revspec the extended sha syntax string to use to lookup the commit
	* @return 0 on success or error code
	*/
	git_annotated_commit_from_revspec :: proc(out: ^^git_annotated_commit, repo: ^git_repository, revspec: cstring) -> c.int ---

	/**
	* Gets the commit ID that the given `git_annotated_commit` refers to.
	*
	* @param commit the given annotated commit
	* @return commit id
	*/
	git_annotated_commit_id :: proc(commit: ^git_annotated_commit) -> ^git_oid ---

	/**
	* Get the refname that the given `git_annotated_commit` refers to.
	*
	* @param commit the given annotated commit
	* @return ref name.
	*/
	git_annotated_commit_ref :: proc(commit: ^git_annotated_commit) -> cstring ---

	/**
	* Frees a `git_annotated_commit`.
	*
	* @param commit annotated commit to free
	*/
	git_annotated_commit_free :: proc(commit: ^git_annotated_commit) ---
}
