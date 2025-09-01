/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_credential_h__ :: 

/**
* Supported credential types
*
* This represents the various types of authentication methods supported by
* the library.
*/
git_credential_t :: enum c.uint {
	/**
	* A vanilla user/password request
	* @see git_credential_userpass_plaintext_new
	*/
	USERPASS_PLAINTEXT = 1,

	/**
	* An SSH key-based authentication request
	* @see git_credential_ssh_key_new
	*/
	SSH_KEY = 2,

	/**
	* An SSH key-based authentication request, with a custom signature
	* @see git_credential_ssh_custom_new
	*/
	SSH_CUSTOM = 4,

	/**
	* An NTLM/Negotiate-based authentication request.
	* @see git_credential_default
	*/
	DEFAULT = 8,

	/**
	* An SSH interactive authentication request
	* @see git_credential_ssh_interactive_new
	*/
	SSH_INTERACTIVE = 16,

	/**
	* Username-only authentication request
	*
	* Used as a pre-authentication step if the underlying transport
	* (eg. SSH, with no username in its URL) does not know which username
	* to use.
	*
	* @see git_credential_username_new
	*/
	USERNAME = 32,

	/**
	* An SSH key-based authentication request
	*
	* Allows credentials to be read from memory instead of files.
	* Note that because of differences in crypto backend support, it might
	* not be functional.
	*
	* @see git_credential_ssh_key_memory_new
	*/
	SSH_MEMORY = 64,
}

/** A key for NTLM/Kerberos "default" credentials */
git_credential_default :: struct {}

/**
* Credential acquisition callback.
*
* This callback is usually involved any time another system might need
* authentication. As such, you are expected to provide a valid
* git_credential object back, depending on allowed_types (a
* git_credential_t bitmask).
*
* Note that most authentication details are your responsibility - this
* callback will be called until the authentication succeeds, or you report
* an error. As such, it's easy to get in a loop if you fail to stop providing
* the same incorrect credentials.
*
* @param[out] out The newly created credential object.
* @param url The resource for which we are demanding a credential.
* @param username_from_url The username that was embedded in a "user\@host"
*                          remote url, or NULL if not included.
* @param allowed_types A bitmask stating which credential types are OK to return.
* @param payload The payload provided when specifying this callback.
* @return 0 for success, < 0 to indicate an error, > 0 to indicate
*       no credential was acquired
*/
git_credential_acquire_cb :: proc "c" (^^git_credential, cstring, cstring, c.uint, rawptr) -> c.int

/**
* Callback for interactive SSH credentials.
*
* @param name the name
* @param name_len the length of the name
* @param instruction the authentication instruction
* @param instruction_len the length of the instruction
* @param num_prompts the number of prompts
* @param prompts the prompts
* @param responses the responses
* @param abstract the abstract
*/
git_credential_ssh_interactive_cb :: proc "c" (cstring, c.int, cstring, c.int, c.int, ^LIBSSH2_USERAUTH_KBDINT_PROMPT, ^LIBSSH2_USERAUTH_KBDINT_RESPONSE, ^rawptr)

/**
* Callback for credential signing.
*
* @param session the libssh2 session
* @param sig the signature
* @param sig_len the length of the signature
* @param data the data
* @param data_len the length of the data
* @param abstract the abstract
* @return 0 for success, < 0 to indicate an error, > 0 to indicate
*       no credential was acquired
*/
git_credential_sign_cb :: proc "c" (^LIBSSH2_SESSION, ^^c.uchar, ^c.int, ^c.uchar, c.int, ^rawptr) -> c.int

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Free a credential.
	*
	* This is only necessary if you own the object; that is, if you are a
	* transport.
	*
	* @param cred the object to free
	*/
	git_credential_free :: proc(cred: ^git_credential) ---

	/**
	* Check whether a credential object contains username information.
	*
	* @param cred object to check
	* @return 1 if the credential object has non-NULL username, 0 otherwise
	*/
	git_credential_has_username :: proc(cred: ^git_credential) -> c.int ---

	/**
	* Return the username associated with a credential object.
	*
	* @param cred object to check
	* @return the credential username, or NULL if not applicable
	*/
	git_credential_get_username :: proc(cred: ^git_credential) -> cstring ---

	/**
	* Create a new plain-text username and password credential object.
	* The supplied credential parameter will be internally duplicated.
	*
	* @param out The newly created credential object.
	* @param username The username of the credential.
	* @param password The password of the credential.
	* @return 0 for success or an error code for failure
	*/
	git_credential_userpass_plaintext_new :: proc(out: ^^git_credential, username: cstring, password: cstring) -> c.int ---

	/**
	* Create a "default" credential usable for Negotiate mechanisms like NTLM
	* or Kerberos authentication.
	*
	* @param out The newly created credential object.
	* @return 0 for success or an error code for failure
	*/
	git_credential_default_new :: proc(out: ^^git_credential) -> c.int ---

	/**
	* Create a credential to specify a username.
	*
	* This is used with ssh authentication to query for the username if
	* none is specified in the url.
	*
	* @param out The newly created credential object.
	* @param username The username to authenticate with
	* @return 0 for success or an error code for failure
	*/
	git_credential_username_new :: proc(out: ^^git_credential, username: cstring) -> c.int ---

	/**
	* Create a new passphrase-protected ssh key credential object.
	* The supplied credential parameter will be internally duplicated.
	*
	* @param out The newly created credential object.
	* @param username username to use to authenticate
	* @param publickey The path to the public key of the credential.
	* @param privatekey The path to the private key of the credential.
	* @param passphrase The passphrase of the credential.
	* @return 0 for success or an error code for failure
	*/
	git_credential_ssh_key_new :: proc(out: ^^git_credential, username: cstring, publickey: cstring, privatekey: cstring, passphrase: cstring) -> c.int ---

	/**
	* Create a new ssh key credential object reading the keys from memory.
	*
	* @param out The newly created credential object.
	* @param username username to use to authenticate.
	* @param publickey The public key of the credential.
	* @param privatekey The private key of the credential.
	* @param passphrase The passphrase of the credential.
	* @return 0 for success or an error code for failure
	*/
	git_credential_ssh_key_memory_new :: proc(out: ^^git_credential, username: cstring, publickey: cstring, privatekey: cstring, passphrase: cstring) -> c.int ---

	/**
	* Create a new ssh keyboard-interactive based credential object.
	* The supplied credential parameter will be internally duplicated.
	*
	* @param out The newly created credential object.
	* @param username Username to use to authenticate.
	* @param prompt_callback The callback method used for prompts.
	* @param payload Additional data to pass to the callback.
	* @return 0 for success or an error code for failure.
	*/
	git_credential_ssh_interactive_new :: proc(out: ^^git_credential, username: cstring, prompt_callback: git_credential_ssh_interactive_cb, payload: rawptr) -> c.int ---

	/**
	* Create a new ssh key credential object used for querying an ssh-agent.
	* The supplied credential parameter will be internally duplicated.
	*
	* @param out The newly created credential object.
	* @param username username to use to authenticate
	* @return 0 for success or an error code for failure
	*/
	git_credential_ssh_key_from_agent :: proc(out: ^^git_credential, username: cstring) -> c.int ---

	/**
	* Create an ssh key credential with a custom signing function.
	*
	* This lets you use your own function to sign the challenge.
	*
	* This function and its credential type is provided for completeness
	* and wraps `libssh2_userauth_publickey()`, which is undocumented.
	*
	* The supplied credential parameter will be internally duplicated.
	*
	* @param out The newly created credential object.
	* @param username username to use to authenticate
	* @param publickey The bytes of the public key.
	* @param publickey_len The length of the public key in bytes.
	* @param sign_callback The callback method to sign the data during the challenge.
	* @param payload Additional data to pass to the callback.
	* @return 0 for success or an error code for failure
	*/
	git_credential_ssh_custom_new :: proc(out: ^^git_credential, username: cstring, publickey: cstring, publickey_len: c.int, sign_callback: git_credential_sign_cb, payload: rawptr) -> c.int ---
}
