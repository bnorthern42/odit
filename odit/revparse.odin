/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_revparse_h__ :: 

/**
* Revparse flags.  These indicate the intended behavior of the spec passed to
* git_revparse.
*/
git_revspec_t :: enum c.uint {
	/** The spec targeted a single object. */
	SINGLE = 1,

	/** The spec targeted a range of commits. */
	RANGE = 2,

	/** The spec used the '...' operator, which invokes special semantics. */
	MERGE_BASE = 4,
}

/**
* Git Revision Spec: output of a `git_revparse` operation
*/
git_revspec :: struct {
	/** The left element of the revspec; must be freed by the user */
	from: ^git_object,

	/** The right element of the revspec; must be freed by the user */
	to: ^git_object,

	/** The intent of the revspec (i.e. `git_revspec_mode_t` flags) */
	flags: c.uint,
}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Find a single object, as specified by a revision string.
	*
	* See `man gitrevisions`, or
	* http://git-scm.com/docs/git-rev-parse.html#_specifying_revisions for
	* information on the syntax accepted.
	*
	* The returned object should be released with `git_object_free` when no
	* longer needed.
	*
	* @param out pointer to output object
	* @param repo the repository to search in
	* @param spec the textual specification for an object
	* @return 0 on success, GIT_ENOTFOUND, GIT_EAMBIGUOUS, GIT_EINVALIDSPEC or an error code
	*/
	git_revparse_single :: proc(out: ^^git_object, repo: ^git_repository, spec: cstring) -> c.int ---

	/**
	* Find a single object and intermediate reference by a revision string.
	*
	* See `man gitrevisions`, or
	* http://git-scm.com/docs/git-rev-parse.html#_specifying_revisions for
	* information on the syntax accepted.
	*
	* In some cases (`@{<-n>}` or `<branchname>@{upstream}`), the expression may
	* point to an intermediate reference. When such expressions are being passed
	* in, `reference_out` will be valued as well.
	*
	* The returned object should be released with `git_object_free` and the
	* returned reference with `git_reference_free` when no longer needed.
	*
	* @param object_out pointer to output object
	* @param reference_out pointer to output reference or NULL
	* @param repo the repository to search in
	* @param spec the textual specification for an object
	* @return 0 on success, GIT_ENOTFOUND, GIT_EAMBIGUOUS, GIT_EINVALIDSPEC
	* or an error code
	*/
	git_revparse_ext :: proc(object_out: ^^git_object, reference_out: ^^git_reference, repo: ^git_repository, spec: cstring) -> c.int ---

	/**
	* Parse a revision string for `from`, `to`, and intent.
	*
	* See `man gitrevisions` or
	* http://git-scm.com/docs/git-rev-parse.html#_specifying_revisions for
	* information on the syntax accepted.
	*
	* @param revspec Pointer to an user-allocated git_revspec struct where
	*	              the result of the rev-parse will be stored
	* @param repo the repository to search in
	* @param spec the rev-parse spec to parse
	* @return 0 on success, GIT_INVALIDSPEC, GIT_ENOTFOUND, GIT_EAMBIGUOUS or an error code
	*/
	git_revparse :: proc(revspec: ^git_revspec, repo: ^git_repository, spec: cstring) -> c.int ---
}
