/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_cert_h__ :: 

/**
* Type of host certificate structure that is passed to the check callback
*/
git_cert_t :: enum c.uint {
	/**
	* No information about the certificate is available. This may
	* happen when using curl.
	*/
	NONE,

	/**
	* The `data` argument to the callback will be a pointer to
	* the DER-encoded data.
	*/
	X509,

	/**
	* The `data` argument to the callback will be a pointer to a
	* `git_cert_hostkey` structure.
	*/
	HOSTKEY_LIBSSH2,

	/**
	* The `data` argument to the callback will be a pointer to a
	* `git_strarray` with `name:content` strings containing
	* information about the certificate. This is used when using
	* curl.
	*/
	STRARRAY,
}

/**
* Parent type for `git_cert_hostkey` and `git_cert_x509`.
*/
git_cert :: struct {
	/**
	* Type of certificate. A `GIT_CERT_` value.
	*/
	cert_type: git_cert_t,
}

/**
* Callback for the user's custom certificate checks.
*
* @param cert The host certificate
* @param valid Whether the libgit2 checks (OpenSSL or WinHTTP) think
* this certificate is valid
* @param host Hostname of the host libgit2 connected to
* @param payload Payload provided by the caller
* @return 0 to proceed with the connection, < 0 to fail the connection
*         or > 0 to indicate that the callback refused to act and that
*         the existing validity determination should be honored
*/
git_transport_certificate_check_cb :: proc "c" (^git_cert, c.int, cstring, rawptr) -> c.int

/**
* Type of SSH host fingerprint
*/
git_cert_ssh_t :: enum c.uint {
	/** MD5 is available */
	MD5 = 1,

	/** SHA-1 is available */
	SHA1 = 2,

	/** SHA-256 is available */
	SHA256 = 4,

	/** Raw hostkey is available */
	RAW = 8,
}

git_cert_ssh_raw_type_t :: enum c.uint {
	/** The raw key is of an unknown type. */
	UNKNOWN,

	/** The raw key is an RSA key. */
	RSA,

	/** The raw key is a DSS key. */
	DSS,

	/** The raw key is a ECDSA 256 key. */
	KEY_ECDSA_256,

	/** The raw key is a ECDSA 384 key. */
	KEY_ECDSA_384,

	/** The raw key is a ECDSA 521 key. */
	KEY_ECDSA_521,

	/** The raw key is a ED25519 key. */
	KEY_ED25519,
}

/**
* Hostkey information taken from libssh2
*/
git_cert_hostkey :: struct {}

/**
* X.509 certificate information
*/
git_cert_x509 :: struct {}

