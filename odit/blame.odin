/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_blame_h__ :: 

/**
* Flags for indicating option behavior for git_blame APIs.
*/
git_blame_flag_t :: enum c.uint {
	/** Normal blame, the default */
	NORMAL = 0,

	/**
	* Track lines that have moved within a file (like `git blame -M`).
	*
	* This is not yet implemented and reserved for future use.
	*/
	TRACK_COPIES_SAME_FILE = 1,

	/**
	* Track lines that have moved across files in the same commit
	* (like `git blame -C`).
	*
	* This is not yet implemented and reserved for future use.
	*/
	TRACK_COPIES_SAME_COMMIT_MOVES = 2,

	/**
	* Track lines that have been copied from another file that exists
	* in the same commit (like `git blame -CC`).  Implies SAME_FILE.
	*
	* This is not yet implemented and reserved for future use.
	*/
	TRACK_COPIES_SAME_COMMIT_COPIES = 4,

	/**
	* Track lines that have been copied from another file that exists in
	* *any* commit (like `git blame -CCC`).  Implies SAME_COMMIT_COPIES.
	*
	* This is not yet implemented and reserved for future use.
	*/
	TRACK_COPIES_ANY_COMMIT_COPIES = 8,

	/**
	* Restrict the search of commits to those reachable following only
	* the first parents.
	*/
	FIRST_PARENT = 16,

	/**
	* Use mailmap file to map author and committer names and email
	* addresses to canonical real names and email addresses. The
	* mailmap will be read from the working directory, or HEAD in a
	* bare repository.
	*/
	USE_MAILMAP = 32,

	/** Ignore whitespace differences */
	IGNORE_WHITESPACE = 64,
}

/**
* Blame options structure
*
* Initialize with `GIT_BLAME_OPTIONS_INIT`. Alternatively, you can
* use `git_blame_options_init`.
*
*/
git_blame_options :: struct {
	version: c.uint,

	/** A combination of `git_blame_flag_t` */
	flags: c.uint,

	/**
	* The lower bound on the number of alphanumeric characters that
	* must be detected as moving/copying within a file for it to
	* associate those lines with the parent commit. The default value
	* is 20.
	*
	* This value only takes effect if any of the `GIT_BLAME_TRACK_COPIES_*`
	* flags are specified.
	*/
	min_match_characters: u16,

	/** The id of the newest commit to consider. The default is HEAD. */
	newest_commit: git_oid,

	/**
	* The id of the oldest commit to consider.
	* The default is the first commit encountered with a NULL parent.
	*/
	oldest_commit: git_oid,

	/**
	* The first line in the file to blame.
	* The default is 1 (line numbers start with 1).
	*/
	min_line: c.int,

	/**
	* The last line in the file to blame.
	* The default is the last line of the file.
	*/
	max_line: c.int,
}

/** Current version for the `git_blame_options` structure */
GIT_BLAME_OPTIONS_VERSION :: 1

/** Static constructor for `git_blame_options` */
GIT_BLAME_OPTIONS_INIT :: {GIT_BLAME_OPTIONS_VERSION}

/**
* Structure that represents a blame hunk.
*/
git_blame_hunk :: struct {
	/**
	* The number of lines in this hunk.
	*/
	lines_in_hunk: c.int,

	/**
	* The OID of the commit where this line was last changed.
	*/
	final_commit_id: git_oid,

	/**
	* The 1-based line number where this hunk begins, in the final version
	* of the file.
	*/
	final_start_line_number: c.int,

	/**
	* The author of `final_commit_id`. If `GIT_BLAME_USE_MAILMAP` has been
	* specified, it will contain the canonical real name and email address.
	*/
	final_signature: ^c.int,

	/**
	* The committer of `final_commit_id`. If `GIT_BLAME_USE_MAILMAP` has
	* been specified, it will contain the canonical real name and email
	* address.
	*/
	final_committer: ^c.int,

	/**
	* The OID of the commit where this hunk was found.
	* This will usually be the same as `final_commit_id`, except when
	* `GIT_BLAME_TRACK_COPIES_ANY_COMMIT_COPIES` has been specified.
	*/
	orig_commit_id: git_oid,

	/**
	* The path to the file where this hunk originated, as of the commit
	* specified by `orig_commit_id`.
	*/
	orig_path: cstring,

	/**
	* The 1-based line number where this hunk begins in the file named by
	* `orig_path` in the commit specified by `orig_commit_id`.
	*/
	orig_start_line_number: c.int,

	/**
	* The author of `orig_commit_id`. If `GIT_BLAME_USE_MAILMAP` has been
	* specified, it will contain the canonical real name and email address.
	*/
	orig_signature: ^c.int,

	/**
	* The committer of `orig_commit_id`. If `GIT_BLAME_USE_MAILMAP` has
	* been specified, it will contain the canonical real name and email
	* address.
	*/
	orig_committer: ^c.int,

	/*
	* The summary of the commit.
	*/
	summary: cstring,

	/**
	* The 1 iff the hunk has been tracked to a boundary commit (the root,
	* or the commit specified in git_blame_options.oldest_commit)
	*/
	boundary: c.char,
}

/**
* Structure that represents a line in a blamed file.
*/
git_blame_line :: struct {
	ptr: cstring,
	len: c.int,
}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Initialize git_blame_options structure
	*
	* Initializes a `git_blame_options` with default values. Equivalent to creating
	* an instance with GIT_BLAME_OPTIONS_INIT.
	*
	* @param opts The `git_blame_options` struct to initialize.
	* @param version The struct version; pass `GIT_BLAME_OPTIONS_VERSION`.
	* @return Zero on success; -1 on failure.
	*/
	git_blame_options_init :: proc(opts: ^git_blame_options, version: c.uint) -> c.int ---

	/**
	* Gets the number of lines that exist in the blame structure.
	*
	* @param blame The blame structure to query.
	* @return The number of line.
	*/
	git_blame_linecount :: proc(blame: ^git_blame) -> c.int ---

	/**
	* Gets the number of hunks that exist in the blame structure.
	*
	* @param blame The blame structure to query.
	* @return The number of hunks.
	*/
	git_blame_hunkcount :: proc(blame: ^git_blame) -> c.int ---

	/**
	* Gets the blame hunk at the given index.
	*
	* @param blame the blame structure to query
	* @param index index of the hunk to retrieve
	* @return the hunk at the given index, or NULL on error
	*/
	git_blame_hunk_byindex :: proc(blame: ^git_blame, index: c.int) -> ^git_blame_hunk ---

	/**
	* Gets the hunk that relates to the given line number in the newest
	* commit.
	*
	* @param blame the blame structure to query
	* @param lineno the (1-based) line number to find a hunk for
	* @return the hunk that contains the given line, or NULL on error
	*/
	git_blame_hunk_byline :: proc(blame: ^git_blame, lineno: c.int) -> ^git_blame_hunk ---

	/**
	* Gets the information about the line in the blame.
	*
	* @param blame the blame structure to query
	* @param idx the (1-based) line number
	* @return the blamed line, or NULL on error
	*/
	git_blame_line_byindex :: proc(blame: ^git_blame, idx: c.int) -> ^git_blame_line ---

	/**
	* Gets the number of hunks that exist in the blame structure.
	*
	* @param blame The blame structure to query.
	* @return The number of hunks.
	*/
	git_blame_get_hunk_count :: proc(blame: ^git_blame) -> u32 ---

	/**
	* Gets the blame hunk at the given index.
	*
	* @param blame the blame structure to query
	* @param index index of the hunk to retrieve
	* @return the hunk at the given index, or NULL on error
	*/
	git_blame_get_hunk_byindex :: proc(blame: ^git_blame, index: u32) -> ^git_blame_hunk ---

	/**
	* Gets the hunk that relates to the given line number in the newest commit.
	*
	* @param blame the blame structure to query
	* @param lineno the (1-based) line number to find a hunk for
	* @return the hunk that contains the given line, or NULL on error
	*/
	git_blame_get_hunk_byline :: proc(blame: ^git_blame, lineno: c.int) -> ^git_blame_hunk ---

	/**
	* Get the blame for a single file in the repository.
	*
	* @param out pointer that will receive the blame object
	* @param repo repository whose history is to be walked
	* @param path path to file to consider
	* @param options options for the blame operation or NULL
	* @return 0 on success, or an error code
	*/
	git_blame_file :: proc(out: ^^git_blame, repo: ^c.int, path: cstring, options: ^git_blame_options) -> c.int ---

	/**
	* Get the blame for a single file in the repository, using the specified
	* buffer contents as the uncommitted changes of the file (the working
	* directory contents).
	*
	* @param out pointer that will receive the blame object
	* @param repo repository whose history is to be walked
	* @param path path to file to consider
	* @param contents the uncommitted changes
	* @param contents_len the length of the changes buffer
	* @param options options for the blame operation or NULL
	* @return 0 on success, or an error code
	*/
	git_blame_file_from_buffer :: proc(out: ^^git_blame, repo: ^c.int, path: cstring, contents: cstring, contents_len: c.int, options: ^git_blame_options) -> c.int ---

	/**
	* Get blame data for a file that has been modified in memory. The `blame`
	* parameter is a pre-calculated blame for the in-odb history of the file.
	* This means that once a file blame is completed (which can be expensive),
	* updating the buffer blame is very fast.
	*
	* Lines that differ between the buffer and the committed version are
	* marked as having a zero OID for their final_commit_id.
	*
	* @param out pointer that will receive the resulting blame data
	* @param base cached blame from the history of the file (usually the output
	*                  from git_blame_file)
	* @param buffer the (possibly) modified contents of the file
	* @param buffer_len number of valid bytes in the buffer
	* @return 0 on success, or an error code. (use git_error_last for information
	*         about the error)
	*/
	git_blame_buffer :: proc(out: ^^git_blame, base: ^git_blame, buffer: cstring, buffer_len: c.int) -> c.int ---

	/**
	* Free memory allocated by git_blame_file or git_blame_buffer.
	*
	* @param blame the blame structure to free
	*/
	git_blame_free :: proc(blame: ^git_blame) ---
}
