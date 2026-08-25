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




// INCLUDE_git_refdb_h__ :: 

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Create a new reference database with no backends.
	*
	* Before the Ref DB can be used for read/writing, a custom database
	* backend must be manually set using `git_refdb_set_backend()`
	*
	* @param out location to store the database pointer, if opened.
	*			Set to NULL if the open failed.
	* @param repo the repository
	* @return 0 or an error code
	*/
	git_refdb_new :: proc(out: ^^git_refdb, repo: ^git_repository) -> c.int ---

	/**
	* Create a new reference database and automatically add
	* the default backends:
	*
	*  - git_refdb_dir: read and write loose and packed refs
	*      from disk, assuming the repository dir as the folder
	*
	* @param out location to store the database pointer, if opened.
	*			Set to NULL if the open failed.
	* @param repo the repository
	* @return 0 or an error code
	*/
	git_refdb_open :: proc(out: ^^git_refdb, repo: ^git_repository) -> c.int ---

	/**
	* Suggests that the given refdb compress or optimize its references.
	* This mechanism is implementation specific.  For on-disk reference
	* databases, for example, this may pack all loose references.
	*
	* @param refdb The reference database to optimize.
	* @return 0 or an error code.
	*/
	git_refdb_compress :: proc(refdb: ^git_refdb) -> c.int ---

	/**
	* Close an open reference database.
	*
	* @param refdb reference database pointer or NULL
	*/
	git_refdb_free :: proc(refdb: ^git_refdb) ---
}
