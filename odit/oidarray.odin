/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_oidarray_h__ :: 

/** Array of object ids */
git_oidarray :: struct {
	ids:   ^git_oid,
	count: c.int,
}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Free the object IDs contained in an oid_array.  This method should
	* be called on `git_oidarray` objects that were provided by the
	* library.  Not doing so will result in a memory leak.
	*
	* This does not free the `git_oidarray` itself, since the library will
	* never allocate that object directly itself.
	*
	* @param array git_oidarray from which to free oid data
	*/
	git_oidarray_dispose :: proc(array: ^git_oidarray) ---
}
