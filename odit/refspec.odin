/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_refspec_h__ :: 

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Parse a given refspec string
	*
	* @param refspec a pointer to hold the refspec handle
	* @param input the refspec string
	* @param is_fetch is this a refspec for a fetch
	* @return 0 if the refspec string could be parsed, -1 otherwise
	*/
	git_refspec_parse :: proc(refspec: ^^git_refspec, input: cstring, is_fetch: c.int) -> c.int ---

	/**
	* Free a refspec object which has been created by git_refspec_parse
	*
	* @param refspec the refspec object
	*/
	git_refspec_free :: proc(refspec: ^git_refspec) ---

	/**
	* Get the source specifier
	*
	* @param refspec the refspec
	* @return the refspec's source specifier
	*/
	git_refspec_src :: proc(refspec: ^git_refspec) -> cstring ---

	/**
	* Get the destination specifier
	*
	* @param refspec the refspec
	* @return the refspec's destination specifier
	*/
	git_refspec_dst :: proc(refspec: ^git_refspec) -> cstring ---

	/**
	* Get the refspec's string
	*
	* @param refspec the refspec
	* @return the refspec's original string
	*/
	git_refspec_string :: proc(refspec: ^git_refspec) -> cstring ---

	/**
	* Get the force update setting
	*
	* @param refspec the refspec
	* @return 1 if force update has been set, 0 otherwise
	*/
	git_refspec_force :: proc(refspec: ^git_refspec) -> c.int ---

	/**
	* Get the refspec's direction.
	*
	* @param spec refspec
	* @return GIT_DIRECTION_FETCH or GIT_DIRECTION_PUSH
	*/
	git_refspec_direction :: proc(spec: ^git_refspec) -> git_direction ---

	/**
	* Check if a refspec's source descriptor matches a negative reference
	*
	* @param refspec the refspec
	* @param refname the name of the reference to check
	* @return 1 if the refspec matches, 0 otherwise
	*/
	git_refspec_src_matches_negative :: proc(refspec: ^git_refspec, refname: cstring) -> c.int ---

	/**
	* Check if a refspec's source descriptor matches a reference
	*
	* @param refspec the refspec
	* @param refname the name of the reference to check
	* @return 1 if the refspec matches, 0 otherwise
	*/
	git_refspec_src_matches :: proc(refspec: ^git_refspec, refname: cstring) -> c.int ---

	/**
	* Check if a refspec's destination descriptor matches a reference
	*
	* @param refspec the refspec
	* @param refname the name of the reference to check
	* @return 1 if the refspec matches, 0 otherwise
	*/
	git_refspec_dst_matches :: proc(refspec: ^git_refspec, refname: cstring) -> c.int ---

	/**
	* Transform a reference to its target following the refspec's rules
	*
	* @param out where to store the target name
	* @param spec the refspec
	* @param name the name of the reference to transform
	* @return 0, GIT_EBUFS or another error
	*/
	git_refspec_transform :: proc(out: ^git_buf, spec: ^git_refspec, name: cstring) -> c.int ---

	/**
	* Transform a target reference to its source reference following the refspec's rules
	*
	* @param out where to store the source reference name
	* @param spec the refspec
	* @param name the name of the reference to transform
	* @return 0, GIT_EBUFS or another error
	*/
	git_refspec_rtransform :: proc(out: ^git_buf, spec: ^git_refspec, name: cstring) -> c.int ---
}
