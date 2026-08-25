/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c

when ODIN_OS == .Windows {
	foreign import lib {
		"git2.lib",
		"system:ws2_32",
		"system:crypt32",
		"system:rpcrt4",
		"system:ole32",
		"system:advapi32",
		"system:shell32",
		"system:user32",
	}
} else when ODIN_OS == .Darwin {
	foreign import lib {
		"../libs/build/libgit2.a",
		"system:z",
		"system:iconv",
		"system:Security",
		"system:CoreFoundation",
		"system:pthread",
	}
} else {
	foreign import lib {
		"../libs/build/libgit2.a",
		"system:z",
		"system:ssl",
		"system:crypto",
		"system:pthread",
	}
}




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
git_email_create_options :: struct {
	version:        c.uint,
	flags:          u32,
	diff_opts:      git_diff_options,
	diff_find_opts: git_diff_find_options,
	subject_prefix: cstring,
	start_number:   c.size_t,
	reroll_number:  c.size_t,
}

GIT_EMAIL_CREATE_OPTIONS_INIT :: git_email_create_options{
	version        = GIT_EMAIL_CREATE_OPTIONS_VERSION,
	diff_opts      = {version = GIT_DIFF_OPTIONS_VERSION, ignore_submodules = .UNSPECIFIED, context_lines = 3},
	diff_find_opts = {version = GIT_DIFF_FIND_OPTIONS_VERSION},
}

/** Current version for the `git_email_create_options` structure */
GIT_EMAIL_CREATE_OPTIONS_VERSION :: 1

/** Static constructor for `git_email_create_options`
 *
 * By default, our options include rename detection and binary
 * diffs to match `git format-patch`.
 */
// GIT_EMAIL_CREATE_OPTIONS_INIT :: \
// {GIT_EMAIL_CREATE_OPTIONS_VERSION, GIT_EMAIL_CREATE_DEFAULT, {GIT_DIFF_OPTIONS_VERSION, GIT_DIFF_SHOW_BINARY, GIT_SUBMODULE_IGNORE_UNSPECIFIED, {NULL, 0}, NULL, NULL, NULL, 3}, GIT_DIFF_FIND_OPTIONS_INIT\
// }

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
