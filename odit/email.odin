/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_email_h__ :: 

/**
* Formatting options for diff e-mail generation
*/
git_email_create_flags_t :: enum c.uint {
	/** Normal patch, the default */
	DEFAULT = 0,

	/** Do not include patch numbers in the subject prefix. */
	OMIT_NUMBERS = 1,

	/**
	* Include numbers in the subject prefix even when the
	* patch is for a single commit (1/1).
	*/
	ALWAYS_NUMBER = 2,

	/** Do not perform rename or similarity detection. */
	NO_RENAMES = 4,
}

/**
* Options for controlling the formatting of the generated e-mail.
*/
git_email_create_options :: struct {}

/** Current version for the `git_email_create_options` structure */
GIT_EMAIL_CREATE_OPTIONS_VERSION :: 1

/** Static constructor for `git_email_create_options`
 *
 * By default, our options include rename detection and binary
 * diffs to match `git format-patch`.
 */
// GIT_EMAIL_CREATE_OPTIONS_INIT :: \
{GIT_EMAIL_CREATE_OPTIONS_VERSION, GIT_EMAIL_CREATE_DEFAULT, {GIT_DIFF_OPTIONS_VERSION, GIT_DIFF_SHOW_BINARY, GIT_SUBMODULE_IGNORE_UNSPECIFIED, {NULL, 0}, NULL, NULL, NULL, 3}, GIT_DIFF_FIND_OPTIONS_INIT\
}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Create a diff for a commit in mbox format for sending via email.
	* The commit must not be a merge commit.
	*
	* @param out buffer to store the e-mail patch in
	* @param commit commit to create a patch for
	* @param opts email creation options
	* @return 0 or an error code
	*/
	git_email_create_from_commit :: proc(out: ^git_buf, commit: ^git_commit, opts: ^git_email_create_options) -> c.int ---
}
