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




// INCLUDE_git_global_h__ :: 

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Init the global state
	*
	* This function must be called before any other libgit2 function in
	* order to set up global state and threading.
	*
	* This function may be called multiple times - it will return the number
	* of times the initialization has been called (including this one) that have
	* not subsequently been shutdown.
	*
	* @return the number of initializations of the library, or an error code.
	*/
	git_libgit2_init :: proc() -> c.int ---

	/**
	* Shutdown the global state
	*
	* Clean up the global state and threading context after calling it as
	* many times as `git_libgit2_init()` was called - it will return the
	* number of remainining initializations that have not been shutdown
	* (after this one).
	*
	* @return the number of remaining initializations of the library, or an
	* error code.
	*/
	git_libgit2_shutdown :: proc() -> c.int ---
}
