/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_strarray_h__ :: 

/** Array of strings */
git_strarray :: struct {
	strings: [^]cstring,
	count:   c.int,
}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Free the strings contained in a string array.  This method should
	* be called on `git_strarray` objects that were provided by the
	* library.  Not doing so, will result in a memory leak.
	*
	* This does not free the `git_strarray` itself, since the library will
	* never allocate that object directly itself.
	*
	* @param array The git_strarray that contains strings to free
	*/
	git_strarray_dispose :: proc(array: ^git_strarray) ---
}
