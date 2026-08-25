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




// INCLUDE_git_buf_h__ :: 

/**
* A data buffer for exporting data from libgit2
*
* Sometimes libgit2 wants to return an allocated data buffer to the
* caller and have the caller take responsibility for freeing that memory.
* To make ownership clear in these cases, libgit2 uses  `git_buf` to
* return this data.  Callers should use `git_buf_dispose()` to release
* the memory when they are done.
*
* A `git_buf` contains a pointer to a NUL-terminated C string, and
* the length of the string (not including the NUL terminator).
*/
git_buf :: struct {
	ptr:      cstring,
	reserved: c.size_t,
	size:     c.size_t,
}

/**
 * Use to initialize a `git_buf` before passing it to a function that
 * will populate it.
 */
GIT_BUF_INIT :: git_buf{nil, 0, 0}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Free the memory referred to by the git_buf.
	*
	* Note that this does not free the `git_buf` itself, just the memory
	* pointed to by `buffer->ptr`.
	*
	* @param buffer The buffer to deallocate
	*/
	git_buf_dispose :: proc(buffer: ^git_buf) ---
}
