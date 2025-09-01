/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_signature_h__ :: 

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Create a new action signature.
	*
	* Call `git_signature_free()` to free the data.
	*
	* Note: angle brackets ('<' and '>') characters are not allowed
	* to be used in either the `name` or the `email` parameter.
	*
	* @param out new signature, in case of error NULL
	* @param name name of the person
	* @param email email of the person
	* @param time time (in seconds from epoch) when the action happened
	* @param offset timezone offset (in minutes) for the time
	* @return 0 or an error code
	*/
	git_signature_new :: proc(out: ^^git_signature, name: cstring, email: cstring, time: git_time_t, offset: c.int) -> c.int ---

	/**
	* Create a new action signature with a timestamp of 'now'.
	*
	* Call `git_signature_free()` to free the data.
	*
	* @param out new signature, in case of error NULL
	* @param name name of the person
	* @param email email of the person
	* @return 0 or an error code
	*/
	git_signature_now :: proc(out: ^^git_signature, name: cstring, email: cstring) -> c.int ---

	/**
	* Create a new author and/or committer signatures with default
	* information based on the configuration and environment variables.
	*
	* If `author_out` is set, it will be populated with the author
	* information. The `GIT_AUTHOR_NAME` and `GIT_AUTHOR_EMAIL`
	* environment variables will be honored, and `user.name` and
	* `user.email` configuration options will be honored if the
	* environment variables are unset. For timestamps, `GIT_AUTHOR_DATE`
	* will be used, otherwise the current time will be used.
	*
	* If `committer_out` is set, it will be populated with the
	* committer information. The `GIT_COMMITTER_NAME` and
	* `GIT_COMMITTER_EMAIL` environment variables will be honored,
	* and `user.name` and `user.email` configuration options will
	* be honored if the environment variables are unset. For timestamps,
	* `GIT_COMMITTER_DATE` will be used, otherwise the current time will
	* be used.
	*
	* If neither `GIT_AUTHOR_DATE` nor `GIT_COMMITTER_DATE` are set,
	* both timestamps will be set to the same time.
	*
	* It will return `GIT_ENOTFOUND` if either the `user.name` or
	* `user.email` are not set and there is no fallback from an environment
	* variable. One of `author_out` or `committer_out` must be set.
	*
	* @param author_out pointer to set the author signature, or NULL
	* @param committer_out pointer to set the committer signature, or NULL
	* @param repo repository pointer
	* @return 0 on success, GIT_ENOTFOUND if config is missing, or error code
	*/
	git_signature_default_from_env :: proc(author_out: ^^git_signature, committer_out: ^^git_signature, repo: ^git_repository) -> c.int ---

	/**
	* Create a new action signature with default user and now timestamp.
	*
	* This looks up the user.name and user.email from the configuration and
	* uses the current time as the timestamp, and creates a new signature
	* based on that information.  It will return GIT_ENOTFOUND if either the
	* user.name or user.email are not set.
	*
	* Note that these do not examine environment variables, only the
	* configuration files. Use `git_signature_default_from_env` to
	* consider the environment variables.
	*
	* @param out new signature
	* @param repo repository pointer
	* @return 0 on success, GIT_ENOTFOUND if config is missing, or error code
	*/
	git_signature_default :: proc(out: ^^git_signature, repo: ^git_repository) -> c.int ---

	/**
	* Create a new signature by parsing the given buffer, which is
	* expected to be in the format "Real Name <email> timestamp tzoffset",
	* where `timestamp` is the number of seconds since the Unix epoch and
	* `tzoffset` is the timezone offset in `hhmm` format (note the lack
	* of a colon separator).
	*
	* @param out new signature
	* @param buf signature string
	* @return 0 on success, GIT_EINVALID if the signature is not parseable, or an error code
	*/
	git_signature_from_buffer :: proc(out: ^^git_signature, buf: cstring) -> c.int ---

	/**
	* Create a copy of an existing signature.  All internal strings are also
	* duplicated.
	*
	* Call `git_signature_free()` to free the data.
	*
	* @param dest pointer where to store the copy
	* @param sig signature to duplicate
	* @return 0 or an error code
	*/
	git_signature_dup :: proc(dest: ^^git_signature, sig: ^git_signature) -> c.int ---

	/**
	* Free an existing signature.
	*
	* Because the signature is not an opaque structure, it is legal to free it
	* manually, but be sure to free the "name" and "email" strings in addition
	* to the structure itself.
	*
	* @param sig signature to free
	*/
	git_signature_free :: proc(sig: ^git_signature) ---
}
