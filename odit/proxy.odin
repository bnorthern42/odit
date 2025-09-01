/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_proxy_h__ :: 

/**
* The type of proxy to use.
*/
git_proxy_t :: enum c.uint {
	/**
	* Do not attempt to connect through a proxy
	*
	* If built against libcurl, it itself may attempt to connect
	* to a proxy if the environment variables specify it.
	*/
	NONE,

	/**
	* Try to auto-detect the proxy from the git configuration.
	*/
	AUTO,

	/**
	* Connect via the URL given in the options
	*/
	SPECIFIED,
}

/**
* Options for connecting through a proxy
*
* Note that not all types may be supported, depending on the platform
* and compilation options.
*/
git_proxy_options :: struct {
	version: c.uint,

	/**
	* The type of proxy to use, by URL, auto-detect.
	*/
	type: git_proxy_t,

	/**
	* The URL of the proxy.
	*/
	url: cstring,

	/**
	* This will be called if the remote host requires
	* authentication in order to connect to it.
	*
	* Returning GIT_PASSTHROUGH will make libgit2 behave as
	* though this field isn't set.
	*/
	credentials: git_credential_acquire_cb,

	/**
	* If cert verification fails, this will be called to let the
	* user make the final decision of whether to allow the
	* connection to proceed. Returns 0 to allow the connection
	* or a negative value to indicate an error.
	*/
	certificate_check: git_transport_certificate_check_cb,

	/**
	* Payload to be provided to the credentials and certificate
	* check callbacks.
	*/
	payload: rawptr,
}

/** Current version for the `git_proxy_options` structure */
GIT_PROXY_OPTIONS_VERSION :: 1

/** Static constructor for `git_proxy_options` */
GIT_PROXY_OPTIONS_INIT :: {GIT_PROXY_OPTIONS_VERSION}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Initialize git_proxy_options structure
	*
	* Initializes a `git_proxy_options` with default values. Equivalent to
	* creating an instance with `GIT_PROXY_OPTIONS_INIT`.
	*
	* @param opts The `git_proxy_options` struct to initialize.
	* @param version The struct version; pass `GIT_PROXY_OPTIONS_VERSION`.
	* @return Zero on success; -1 on failure.
	*/
	git_proxy_options_init :: proc(opts: ^git_proxy_options, version: c.uint) -> c.int ---
}
