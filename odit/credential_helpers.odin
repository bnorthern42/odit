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




// INCLUDE_git_credential_helpers_h__ :: 

/**
* Payload for git_credential_userpass_plaintext.
*/
git_credential_userpass_payload :: struct {
	username: cstring,
	password: cstring,
}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Stock callback usable as a git_credential_acquire_cb.  This calls
	* git_cred_userpass_plaintext_new unless the protocol has not specified
	* `GIT_CREDENTIAL_USERPASS_PLAINTEXT` as an allowed type.
	*
	* @param out The newly created credential object.
	* @param url The resource for which we are demanding a credential.
	* @param user_from_url The username that was embedded in a "user\@host"
	*                          remote url, or NULL if not included.
	* @param allowed_types A bitmask stating which credential types are OK to return.
	* @param payload The payload provided when specifying this callback.  (This is
	*        interpreted as a `git_credential_userpass_payload*`.)
	* @return 0 or an error code.
	*/
	git_credential_userpass :: proc(out: ^^git_credential, url: cstring, user_from_url: cstring, allowed_types: c.uint, payload: rawptr) -> c.int ---
}
