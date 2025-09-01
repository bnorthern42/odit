/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_message_h__ :: 

/**
* Represents a single git message trailer.
*/
git_message_trailer :: struct {
	key:   cstring,
	value: cstring,
}

/**
* Represents an array of git message trailers.
*
* Struct members under the private comment are private, subject to change
* and should not be used by callers.
*/
git_message_trailer_array :: struct {}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Clean up excess whitespace and make sure there is a trailing newline in the message.
	*
	* Optionally, it can remove lines which start with the comment character.
	*
	* @param out The user-allocated git_buf which will be filled with the
	*     cleaned up message.
	*
	* @param message The message to be prettified.
	*
	* @param strip_comments Non-zero to remove comment lines, 0 to leave them in.
	*
	* @param comment_char Comment character. Lines starting with this character
	* are considered to be comments and removed if `strip_comments` is non-zero.
	*
	* @return 0 or an error code.
	*/
	git_message_prettify :: proc(out: ^git_buf, message: cstring, strip_comments: c.int, comment_char: c.char) -> c.int ---

	/**
	* Parse trailers out of a message, filling the array pointed to by +arr+.
	*
	* Trailers are key/value pairs in the last paragraph of a message, not
	* including any patches or conflicts that may be present.
	*
	* @param arr A pre-allocated git_message_trailer_array struct to be filled in
	*            with any trailers found during parsing.
	* @param message The message to be parsed
	* @return 0 on success, or non-zero on error.
	*/
	git_message_trailers :: proc(arr: ^git_message_trailer_array, message: cstring) -> c.int ---

	/**
	* Clean's up any allocated memory in the git_message_trailer_array filled by
	* a call to git_message_trailers.
	*
	* @param arr The trailer to free.
	*/
	git_message_trailer_array_free :: proc(arr: ^git_message_trailer_array) ---
}
