/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit





// INCLUDE_git_transport_h__ :: 

/**
* Callback for messages received by the transport.
*
* Return a negative value to cancel the network operation.
*
* @param str The message from the transport
* @param len The length of the message
* @param payload Payload provided by the caller
* @return 0 on success or an error code
*/
git_transport_message_cb :: proc "c" (cstring, c.int, rawptr) -> c.int

/**
* Signature of a function which creates a transport.
*
* @param out the transport generate
* @param owner the owner for the transport
* @param param the param to the transport creation
* @return 0 on success or an error code
*/
git_transport_cb :: proc "c" (^^git_transport, ^git_remote, rawptr) -> c.int

