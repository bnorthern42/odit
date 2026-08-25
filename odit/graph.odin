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




// INCLUDE_git_graph_h__ :: 

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Count the number of unique commits between two commit objects
	*
	* There is no need for branches containing the commits to have any
	* upstream relationship, but it helps to think of one as a branch and
	* the other as its upstream, the `ahead` and `behind` values will be
	* what git would report for the branches.
	*
	* @param ahead number of unique from commits in `upstream`
	* @param behind number of unique from commits in `local`
	* @param repo the repository where the commits exist
	* @param local the commit for local
	* @param upstream the commit for upstream
	* @return 0 or an error code.
	*/
	git_graph_ahead_behind :: proc(ahead: ^c.int, behind: ^c.int, repo: ^git_repository, local: ^git_oid, upstream: ^git_oid) -> c.int ---

	/**
	* Determine if a commit is the descendant of another commit.
	*
	* Note that a commit is not considered a descendant of itself, in contrast
	* to `git merge-base --is-ancestor`.
	*
	* @param repo the repository where the commits exist
	* @param commit a previously loaded commit
	* @param ancestor a potential ancestor commit
	* @return 1 if the given commit is a descendant of the potential ancestor,
	* 0 if not, error code otherwise.
	*/
	git_graph_descendant_of :: proc(repo: ^git_repository, commit: ^git_oid, ancestor: ^git_oid) -> c.int ---

	/**
	* Determine if a commit is reachable from any of a list of commits by
	* following parent edges.
	*
	* @param repo the repository where the commits exist
	* @param commit a previously loaded commit
	* @param descendant_array oids of the commits
	* @param length the number of commits in the provided `descendant_array`
	* @return 1 if the given commit is an ancestor of any of the given potential
	* descendants, 0 if not, error code otherwise.
	*/
	git_graph_reachable_from_any :: proc(repo: ^git_repository, commit: ^git_oid, descendant_array: []git_oid, length: c.int) -> c.int ---
}
