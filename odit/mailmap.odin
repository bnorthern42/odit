/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_mailmap_h__ :: 

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Allocate a new mailmap object.
	*
	* This object is empty, so you'll have to add a mailmap file before you can do
	* anything with it. The mailmap must be freed with 'git_mailmap_free'.
	*
	* @param out pointer to store the new mailmap
	* @return 0 on success, or an error code
	*/
	git_mailmap_new :: proc(out: ^^git_mailmap) -> c.int ---

	/**
	* Free the mailmap and its associated memory.
	*
	* @param mm the mailmap to free
	*/
	git_mailmap_free :: proc(mm: ^git_mailmap) ---

	/**
	* Add a single entry to the given mailmap object. If the entry already exists,
	* it will be replaced with the new entry.
	*
	* @param mm mailmap to add the entry to
	* @param real_name the real name to use, or NULL
	* @param real_email the real email to use, or NULL
	* @param replace_name the name to replace, or NULL
	* @param replace_email the email to replace
	* @return 0 on success, or an error code
	*/
	git_mailmap_add_entry :: proc(mm: ^git_mailmap, real_name: cstring, real_email: cstring, replace_name: cstring, replace_email: cstring) -> c.int ---

	/**
	* Create a new mailmap instance containing a single mailmap file
	*
	* @param out pointer to store the new mailmap
	* @param buf buffer to parse the mailmap from
	* @param len the length of the input buffer
	* @return 0 on success, or an error code
	*/
	git_mailmap_from_buffer :: proc(out: ^^git_mailmap, buf: cstring, len: c.int) -> c.int ---

	/**
	* Create a new mailmap instance from a repository, loading mailmap files based
	* on the repository's configuration.
	*
	* Mailmaps are loaded in the following order:
	*  1. '.mailmap' in the root of the repository's working directory, if present.
	*  2. The blob object identified by the 'mailmap.blob' config entry, if set.
	* 	   [NOTE: 'mailmap.blob' defaults to 'HEAD:.mailmap' in bare repositories]
	*  3. The path in the 'mailmap.file' config entry, if set.
	*
	* @param out pointer to store the new mailmap
	* @param repo repository to load mailmap information from
	* @return 0 on success, or an error code
	*/
	git_mailmap_from_repository :: proc(out: ^^git_mailmap, repo: ^git_repository) -> c.int ---

	/**
	* Resolve a name and email to the corresponding real name and email.
	*
	* The lifetime of the strings are tied to `mm`, `name`, and `email` parameters.
	*
	* @param real_name pointer to store the real name
	* @param real_email pointer to store the real email
	* @param mm the mailmap to perform a lookup with (may be NULL)
	* @param name the name to look up
	* @param email the email to look up
	* @return 0 on success, or an error code
	*/
	git_mailmap_resolve :: proc(real_name: [^]cstring, real_email: [^]cstring, mm: ^git_mailmap, name: cstring, email: cstring) -> c.int ---

	/**
	* Resolve a signature to use real names and emails with a mailmap.
	*
	* Call `git_signature_free()` to free the data.
	*
	* @param out new signature
	* @param mm mailmap to resolve with
	* @param sig signature to resolve
	* @return 0 or an error code
	*/
	git_mailmap_resolve_signature :: proc(out: ^^git_signature, mm: ^git_mailmap, sig: ^git_signature) -> c.int ---
}
