/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_net_h__ :: 

/** Default git protocol port number */
GIT_DEFAULT_PORT :: "9418"

/**
* Direction of the connection.
*
* We need this because we need to know whether we should call
* git-upload-pack or git-receive-pack on the remote end when get_refs
* gets called.
*/
git_direction :: enum c.uint {
	FETCH,
	PUSH,
}

/**
* Description of a reference advertised by a remote server, given out
* on `ls` calls.
*/
git_remote_head :: struct {
	local: c.int, /* available locally */
	oid:   git_oid,
	loid:  git_oid,
	name:  cstring,

	/**
	* If the server send a symref mapping for this ref, this will
	* point to the target.
	*/
	symref_target: cstring,
}

