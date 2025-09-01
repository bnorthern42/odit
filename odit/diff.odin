/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_diff_h__ :: 

/**
* Flags for diff options.  A combination of these flags can be passed
* in via the `flags` value in the `git_diff_options`.
*/
git_diff_option_t :: enum c.uint {
	/** Normal diff, the default */
	NORMAL = 0,

	/** Reverse the sides of the diff */
	REVERSE = 1,

	/** Include ignored files in the diff */
	INCLUDE_IGNORED = 2,

	/** Even with GIT_DIFF_INCLUDE_IGNORED, an entire ignored directory
	*  will be marked with only a single entry in the diff; this flag
	*  adds all files under the directory as IGNORED entries, too.
	*/
	RECURSE_IGNORED_DIRS = 4,

	/** Include untracked files in the diff */
	INCLUDE_UNTRACKED = 8,

	/** Even with GIT_DIFF_INCLUDE_UNTRACKED, an entire untracked
	*  directory will be marked with only a single entry in the diff
	*  (a la what core Git does in `git status`); this flag adds *all*
	*  files under untracked directories as UNTRACKED entries, too.
	*/
	RECURSE_UNTRACKED_DIRS = 16,

	/** Include unmodified files in the diff */
	INCLUDE_UNMODIFIED = 32,

	/** Normally, a type change between files will be converted into a
	*  DELETED record for the old and an ADDED record for the new; this
	*  options enabled the generation of TYPECHANGE delta records.
	*/
	INCLUDE_TYPECHANGE = 64,

	/** Even with GIT_DIFF_INCLUDE_TYPECHANGE, blob->tree changes still
	*  generally show as a DELETED blob.  This flag tries to correctly
	*  label blob->tree transitions as TYPECHANGE records with new_file's
	*  mode set to tree.  Note: the tree SHA will not be available.
	*/
	INCLUDE_TYPECHANGE_TREES = 128,

	/** Ignore file mode changes */
	IGNORE_FILEMODE = 256,

	/** Treat all submodules as unmodified */
	IGNORE_SUBMODULES = 512,

	/** Use case insensitive filename comparisons */
	IGNORE_CASE = 1024,

	/** May be combined with `GIT_DIFF_IGNORE_CASE` to specify that a file
	*  that has changed case will be returned as an add/delete pair.
	*/
	INCLUDE_CASECHANGE = 2048,

	/** If the pathspec is set in the diff options, this flags indicates
	*  that the paths will be treated as literal paths instead of
	*  fnmatch patterns.  Each path in the list must either be a full
	*  path to a file or a directory.  (A trailing slash indicates that
	*  the path will _only_ match a directory).  If a directory is
	*  specified, all children will be included.
	*/
	DISABLE_PATHSPEC_MATCH = 4096,

	/** Disable updating of the `binary` flag in delta records.  This is
	*  useful when iterating over a diff if you don't need hunk and data
	*  callbacks and want to avoid having to load file completely.
	*/
	SKIP_BINARY_CHECK = 8192,

	/** When diff finds an untracked directory, to match the behavior of
	*  core Git, it scans the contents for IGNORED and UNTRACKED files.
	*  If *all* contents are IGNORED, then the directory is IGNORED; if
	*  any contents are not IGNORED, then the directory is UNTRACKED.
	*  This is extra work that may not matter in many cases.  This flag
	*  turns off that scan and immediately labels an untracked directory
	*  as UNTRACKED (changing the behavior to not match core Git).
	*/
	ENABLE_FAST_UNTRACKED_DIRS = 16384,

	/** When diff finds a file in the working directory with stat
	* information different from the index, but the OID ends up being the
	* same, write the correct stat information into the index.  Note:
	* without this flag, diff will always leave the index untouched.
	*/
	UPDATE_INDEX = 32768,

	/** Include unreadable files in the diff */
	INCLUDE_UNREADABLE = 65536,

	/** Include unreadable files in the diff */
	INCLUDE_UNREADABLE_AS_UNTRACKED = 131072,

	/** Use a heuristic that takes indentation and whitespace into account
	* which generally can produce better diffs when dealing with ambiguous
	* diff hunks.
	*/
	INDENT_HEURISTIC = 262144,

	/** Ignore blank lines */
	IGNORE_BLANK_LINES = 524288,

	/** Treat all files as text, disabling binary attributes & detection */
	FORCE_TEXT = 1048576,

	/** Treat all files as binary, disabling text diffs */
	FORCE_BINARY = 2097152,

	/** Ignore all whitespace */
	IGNORE_WHITESPACE = 4194304,

	/** Ignore changes in amount of whitespace */
	IGNORE_WHITESPACE_CHANGE = 8388608,

	/** Ignore whitespace at end of line */
	IGNORE_WHITESPACE_EOL = 16777216,

	/** When generating patch text, include the content of untracked
	*  files.  This automatically turns on GIT_DIFF_INCLUDE_UNTRACKED but
	*  it does not turn on GIT_DIFF_RECURSE_UNTRACKED_DIRS.  Add that
	*  flag if you want the content of every single UNTRACKED file.
	*/
	SHOW_UNTRACKED_CONTENT = 33554432,

	/** When generating output, include the names of unmodified files if
	*  they are included in the git_diff.  Normally these are skipped in
	*  the formats that list files (e.g. name-only, name-status, raw).
	*  Even with this, these will not be included in patch format.
	*/
	SHOW_UNMODIFIED = 67108864,

	/** Use the "patience diff" algorithm */
	PATIENCE = 268435456,

	/** Take extra time to find minimal diff */
	MINIMAL = 536870912,

	/** Include the necessary deflate / delta information so that `git-apply`
	*  can apply given diff information to binary files.
	*/
	SHOW_BINARY = 1073741824,
}

/**
* Flags for the delta object and the file objects on each side.
*
* These flags are used for both the `flags` value of the `git_diff_delta`
* and the flags for the `git_diff_file` objects representing the old and
* new sides of the delta.  Values outside of this public range should be
* considered reserved for internal or future use.
*/
git_diff_flag_t :: enum c.uint {
	BINARY     = 1,  /**< file(s) treated as binary data */
	NOT_BINARY = 2,  /**< file(s) treated as text data */
	VALID_ID   = 4,  /**< `id` value is known correct */
	EXISTS     = 8,  /**< file exists at this side of the delta */
	VALID_SIZE = 16, /**< file size value is known correct */
}

/**
* What type of change is described by a git_diff_delta?
*
* `GIT_DELTA_RENAMED` and `GIT_DELTA_COPIED` will only show up if you run
* `git_diff_find_similar()` on the diff object.
*
* `GIT_DELTA_TYPECHANGE` only shows up given `GIT_DIFF_INCLUDE_TYPECHANGE`
* in the option flags (otherwise type changes will be split into ADDED /
* DELETED pairs).
*/
git_delta_t :: enum c.uint {
	UNMODIFIED, /**< no changes */
	ADDED,      /**< entry does not exist in old version */
	DELETED,    /**< entry does not exist in new version */
	MODIFIED,   /**< entry content changed between old and new */
	RENAMED,    /**< entry was renamed between old and new */
	COPIED,     /**< entry was copied from another old entry */
	IGNORED,    /**< entry is ignored item in workdir */
	UNTRACKED,  /**< entry is untracked item in workdir */
	TYPECHANGE, /**< type of entry changed between old and new */
	UNREADABLE, /**< entry is unreadable */
	CONFLICTED, /**< entry in the index is conflicted */
}

/**
* Description of one side of a delta.
*
* Although this is called a "file", it could represent a file, a symbolic
* link, a submodule commit id, or even a tree (although that only if you
* are tracking type changes or ignored/untracked directories).
*/
git_diff_file :: struct {
	/**
	* The `git_oid` of the item.  If the entry represents an
	* absent side of a diff (e.g. the `old_file` of a `GIT_DELTA_ADDED` delta),
	* then the oid will be zeroes.
	*/
	id: git_oid,

	/**
	* The NUL-terminated path to the entry relative to the working
	* directory of the repository.
	*/
	path: cstring,

	/**
	* The size of the entry in bytes.
	*/
	size: git_object_size_t,

	/**
	* A combination of the `git_diff_flag_t` types
	*/
	flags: u32,

	/**
	* Roughly, the stat() `st_mode` value for the item.  This will
	* be restricted to one of the `git_filemode_t` values.
	*/
	mode: u16,

	/**
	* Represents the known length of the `id` field, when
	* converted to a hex string.  It is generally `GIT_OID_SHA1_HEXSIZE`, unless this
	* delta was created from reading a patch file, in which case it may be
	* abbreviated to something reasonable, like 7 characters.
	*/
	id_abbrev: u16,
}

/**
* Description of changes to one entry.
*
* A `delta` is a file pair with an old and new revision.  The old version
* may be absent if the file was just created and the new version may be
* absent if the file was deleted.  A diff is mostly just a list of deltas.
*
* When iterating over a diff, this will be passed to most callbacks and
* you can use the contents to understand exactly what has changed.
*
* The `old_file` represents the "from" side of the diff and the `new_file`
* represents to "to" side of the diff.  What those means depend on the
* function that was used to generate the diff and will be documented below.
* You can also use the `GIT_DIFF_REVERSE` flag to flip it around.
*
* Although the two sides of the delta are named "old_file" and "new_file",
* they actually may correspond to entries that represent a file, a symbolic
* link, a submodule commit id, or even a tree (if you are tracking type
* changes or ignored/untracked directories).
*
* Under some circumstances, in the name of efficiency, not all fields will
* be filled in, but we generally try to fill in as much as possible.  One
* example is that the "flags" field may not have either the `BINARY` or the
* `NOT_BINARY` flag set to avoid examining file contents if you do not pass
* in hunk and/or line callbacks to the diff foreach iteration function.  It
* will just use the git attributes for those files.
*
* The similarity score is zero unless you call `git_diff_find_similar()`
* which does a similarity analysis of files in the diff.  Use that
* function to do rename and copy detection, and to split heavily modified
* files in add/delete pairs.  After that call, deltas with a status of
* GIT_DELTA_RENAMED or GIT_DELTA_COPIED will have a similarity score
* between 0 and 100 indicating how similar the old and new sides are.
*
* If you ask `git_diff_find_similar` to find heavily modified files to
* break, but to not *actually* break the records, then GIT_DELTA_MODIFIED
* records may have a non-zero similarity score if the self-similarity is
* below the split threshold.  To display this value like core Git, invert
* the score (a la `printf("M%03d", 100 - delta->similarity)`).
*/
git_diff_delta :: struct {
	status:     git_delta_t,
	flags:      u32, /**< git_diff_flag_t values */
	similarity: u16, /**< for RENAMED and COPIED, value 0-100 */
	nfiles:     u16, /**< number of files in this delta */
	old_file:   git_diff_file,
	new_file:   git_diff_file,
}

/**
* Diff notification callback function.
*
* The callback will be called for each file, just before the `git_diff_delta`
* gets inserted into the diff.
*
* When the callback:
* - returns < 0, the diff process will be aborted.
* - returns > 0, the delta will not be inserted into the diff, but the
*		diff process continues.
* - returns 0, the delta is inserted into the diff, and the diff process
*		continues.
*
* @param diff_so_far the diff structure as it currently exists
* @param delta_to_add the delta that is to be added
* @param matched_pathspec the pathspec
* @param payload the user-specified callback payload
* @return 0 on success, 1 to skip this delta, or an error code
*/
git_diff_notify_cb :: proc "c" (^git_diff, ^git_diff_delta, cstring, rawptr) -> c.int

/**
* Diff progress callback.
*
* Called before each file comparison.
*
* @param diff_so_far The diff being generated.
* @param old_path The path to the old file or NULL.
* @param new_path The path to the new file or NULL.
* @param payload the user-specified callback payload
* @return 0 or an error code
*/
git_diff_progress_cb :: proc "c" (^git_diff, cstring, cstring, rawptr) -> c.int

/**
* Structure describing options about how the diff should be executed.
*
* Setting all values of the structure to zero will yield the default
* values.  Similarly, passing NULL for the options structure will
* give the defaults.  The default values are marked below.
*
*/
git_diff_options :: struct {}

/** The current version of the diff options structure */
GIT_DIFF_OPTIONS_VERSION :: 1

/** Stack initializer for diff options.  Alternatively use
 * `git_diff_options_init` programmatic initialization.
 */
GIT_DIFF_OPTIONS_INIT :: {GIT_DIFF_OPTIONS_VERSION, 0, GIT_SUBMODULE_IGNORE_UNSPECIFIED, {NULL, 0}, NULL, NULL, NULL, 3}

/**
* When iterating over a diff, callback that will be made per file.
*
* @param delta A pointer to the delta data for the file
* @param progress Goes from 0 to 1 over the diff
* @param payload User-specified pointer from foreach function
* @return 0 or an error code
*/
git_diff_file_cb :: proc "c" (^git_diff_delta, f32, rawptr) -> c.int

/** Maximum size of the hunk header */
GIT_DIFF_HUNK_HEADER_SIZE :: 128

/**
* When producing a binary diff, the binary data returned will be
* either the deflated full ("literal") contents of the file, or
* the deflated binary delta between the two sides (whichever is
* smaller).
*/
git_diff_binary_t :: enum c.uint {
	/** There is no binary delta. */
	NONE,

	/** The binary data is the literal contents of the file. */
	LITERAL,

	/** The binary data is the delta from one side to the other. */
	DELTA,
}

/** The contents of one of the files in a binary diff. */
git_diff_binary_file :: struct {}

/**
* Structure describing the binary contents of a diff.
*
* A `binary` file / delta is a file (or pair) for which no text diffs
* should be generated. A diff can contain delta entries that are
* binary, but no diff content will be output for those files. There is
* a base heuristic for binary detection and you can further tune the
* behavior with git attributes or diff flags and option settings.
*/
git_diff_binary :: struct {}

/**
* When iterating over a diff, callback that will be made for
* binary content within the diff.
*
* @param delta the delta
* @param binary the binary content
* @param payload the user-specified callback payload
* @return 0 or an error code
*/
git_diff_binary_cb :: proc "c" (^git_diff_delta, ^git_diff_binary, rawptr) -> c.int

/**
* Structure describing a hunk of a diff.
*
* A `hunk` is a span of modified lines in a delta along with some stable
* surrounding context. You can configure the amount of context and other
* properties of how hunks are generated. Each hunk also comes with a
* header that described where it starts and ends in both the old and new
* versions in the delta.
*/
git_diff_hunk :: struct {}

/**
* When iterating over a diff, callback that will be made per hunk.
*
* @param delta the delta
* @param hunk the hunk
* @param payload the user-specified callback payload
* @return 0 or an error code
*/
git_diff_hunk_cb :: proc "c" (^git_diff_delta, ^git_diff_hunk, rawptr) -> c.int

/**
* Line origin constants.
*
* These values describe where a line came from and will be passed to
* the git_diff_line_cb when iterating over a diff.  There are some
* special origin constants at the end that are used for the text
* output callbacks to demarcate lines that are actually part of
* the file or hunk headers.
*/
git_diff_line_t :: enum c.uint {
	/* These values will be sent to `git_diff_line_cb` along with the line */
	CONTEXT = 32,

	/* These values will be sent to `git_diff_line_cb` along with the line */
	ADDITION = 43,

	/* These values will be sent to `git_diff_line_cb` along with the line */
	DELETION = 45,
	CONTEXT_EOFNL = 61, /**< Both files have no LF at end */
	ADD_EOFNL     = 62, /**< Old has no LF at end, new does */
	DEL_EOFNL     = 60, /**< Old has LF at end, new does not */

	/* The following values will only be sent to a `git_diff_line_cb` when
	* the content of a diff is being formatted through `git_diff_print`.
	*/
	FILE_HDR = 70,

	/* The following values will only be sent to a `git_diff_line_cb` when
	* the content of a diff is being formatted through `git_diff_print`.
	*/
	HUNK_HDR = 72,
	BINARY        = 66, /**< For "Binary files x and y differ" */
}

/**
* Structure describing a line (or data span) of a diff.
*
* A `line` is a range of characters inside a hunk.  It could be a context
* line (i.e. in both old and new versions), an added line (i.e. only in
* the new version), or a removed line (i.e. only in the old version).
* Unfortunately, we don't know anything about the encoding of data in the
* file being diffed, so we cannot tell you much about the line content.
* Line data will not be NUL-byte terminated, however, because it will be
* just a span of bytes inside the larger file.
*/
git_diff_line :: struct {}

/**
* When iterating over a diff, callback that will be made per text diff
* line. In this context, the provided range will be NULL.
*
* When printing a diff, callback that will be made to output each line
* of text.  This uses some extra GIT_DIFF_LINE_... constants for output
* of lines of file and hunk headers.
*
* @param delta the delta that contains the line
* @param hunk the hunk that contains the line
* @param line the line in the diff
* @param payload the user-specified callback payload
* @return 0 or an error code
*/
git_diff_line_cb :: proc "c" (^git_diff_delta, ^git_diff_hunk, ^git_diff_line, rawptr) -> c.int

/**
* Flags to control the behavior of diff rename/copy detection.
*/
git_diff_find_t :: enum c.uint {
	/** Obey `diff.renames`. Overridden by any other GIT_DIFF_FIND_... flag. */
	FIND_BY_CONFIG = 0,

	/** Look for renames? (`--find-renames`) */
	FIND_RENAMES = 1,

	/** Consider old side of MODIFIED for renames? (`--break-rewrites=N`) */
	FIND_RENAMES_FROM_REWRITES = 2,

	/** Look for copies? (a la `--find-copies`). */
	FIND_COPIES = 4,

	/** Consider UNMODIFIED as copy sources? (`--find-copies-harder`).
	*
	* For this to work correctly, use GIT_DIFF_INCLUDE_UNMODIFIED when
	* the initial `git_diff` is being generated.
	*/
	FIND_COPIES_FROM_UNMODIFIED = 8,

	/** Mark significant rewrites for split (`--break-rewrites=/M`) */
	FIND_REWRITES = 16,

	/** Actually split large rewrites into delete/add pairs */
	BREAK_REWRITES = 32,

	/** Mark rewrites for split and break into delete/add pairs */
	FIND_AND_BREAK_REWRITES = 48,

	/** Find renames/copies for UNTRACKED items in working directory.
	*
	* For this to work correctly, use GIT_DIFF_INCLUDE_UNTRACKED when the
	* initial `git_diff` is being generated (and obviously the diff must
	* be against the working directory for this to make sense).
	*/
	FIND_FOR_UNTRACKED = 64,

	/** Turn on all finding features. */
	FIND_ALL = 255,

	/** Measure similarity ignoring leading whitespace (default) */
	FIND_IGNORE_LEADING_WHITESPACE = 0,

	/** Measure similarity ignoring all whitespace */
	FIND_IGNORE_WHITESPACE = 4096,

	/** Measure similarity including all data */
	FIND_DONT_IGNORE_WHITESPACE = 8192,

	/** Measure similarity only by comparing SHAs (fast and cheap) */
	FIND_EXACT_MATCH_ONLY = 16384,

	/** Do not break rewrites unless they contribute to a rename.
	*
	* Normally, GIT_DIFF_FIND_AND_BREAK_REWRITES will measure the self-
	* similarity of modified files and split the ones that have changed a
	* lot into a DELETE / ADD pair.  Then the sides of that pair will be
	* considered candidates for rename and copy detection.
	*
	* If you add this flag in and the split pair is *not* used for an
	* actual rename or copy, then the modified record will be restored to
	* a regular MODIFIED record instead of being split.
	*/
	BREAK_REWRITES_FOR_RENAMES_ONLY = 32768,

	/** Remove any UNMODIFIED deltas after find_similar is done.
	*
	* Using GIT_DIFF_FIND_COPIES_FROM_UNMODIFIED to emulate the
	* --find-copies-harder behavior requires building a diff with the
	* GIT_DIFF_INCLUDE_UNMODIFIED flag.  If you do not want UNMODIFIED
	* records in the final result, pass this flag to have them removed.
	*/
	FIND_REMOVE_UNMODIFIED = 65536,
}

/**
* Pluggable similarity metric
*/
git_diff_similarity_metric :: struct {
	file_signature:   proc "c" (^rawptr, ^git_diff_file, cstring, rawptr) -> c.int,
	buffer_signature: proc "c" (^rawptr, ^git_diff_file, cstring, c.int, rawptr) -> c.int,
	free_signature:   proc "c" (rawptr, rawptr),
	similarity:       proc "c" (^c.int, rawptr, rawptr, rawptr) -> c.int,
	payload:          rawptr,
}

/**
* Control behavior of rename and copy detection
*
* These options mostly mimic parameters that can be passed to git-diff.
*/
git_diff_find_options :: struct {}

/** Current version for the `git_diff_find_options` structure */
GIT_DIFF_FIND_OPTIONS_VERSION :: 1

/** Static constructor for `git_diff_find_options` */
GIT_DIFF_FIND_OPTIONS_INIT :: {GIT_DIFF_FIND_OPTIONS_VERSION}

/**
* Possible output formats for diff data
*/
git_diff_format_t :: enum c.uint {
	PATCH        = 1, /**< full git diff */
	PATCH_HEADER = 2, /**< just the file headers of patch */
	RAW          = 3, /**< like git diff --raw */
	NAME_ONLY    = 4, /**< like git diff --name-only */
	NAME_STATUS  = 5, /**< like git diff --name-status */
	PATCH_ID     = 6, /**< git diff as used by git patch-id */
}

/**
* Options for parsing a diff / patch file.
*/
git_diff_parse_options :: struct {
	version: c.uint,

	/** Object ID type used in the patch file. */
	oid_type: git_oid_t,
}

/** The current version of the diff parse options structure */
GIT_DIFF_PARSE_OPTIONS_VERSION :: 1

/** Stack initializer for diff parse options.  Alternatively use
 * `git_diff_parse_options_init` programmatic initialization.
 */
GIT_DIFF_PARSE_OPTIONS_INIT :: {GIT_DIFF_PARSE_OPTIONS_VERSION}

/**
* Formatting options for diff stats
*/
git_diff_stats_format_t :: enum c.uint {
	/** No stats*/
	NONE = 0,

	/** Full statistics, equivalent of `--stat` */
	FULL = 1,

	/** Short statistics, equivalent of `--shortstat` */
	SHORT = 2,

	/** Number statistics, equivalent of `--numstat` */
	NUMBER = 4,

	/** Extended header information such as creations, renames and mode changes, equivalent of `--summary` */
	INCLUDE_SUMMARY = 8,
}

/**
* Patch ID options structure
*
* Initialize with `GIT_PATCHID_OPTIONS_INIT`. Alternatively, you can
* use `git_diff_patchid_options_init`.
*
*/
git_diff_patchid_options :: struct {
	version: c.uint,
}

/** Current version for the `git_diff_patchid_options` structure */
GIT_DIFF_PATCHID_OPTIONS_VERSION :: 1

/** Static constructor for `git_diff_patchid_options` */
GIT_DIFF_PATCHID_OPTIONS_INIT :: {GIT_DIFF_PATCHID_OPTIONS_VERSION}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Initialize git_diff_options structure
	*
	* Initializes a `git_diff_options` with default values. Equivalent to creating
	* an instance with GIT_DIFF_OPTIONS_INIT.
	*
	* @param opts The `git_diff_options` struct to initialize.
	* @param version The struct version; pass `GIT_DIFF_OPTIONS_VERSION`.
	* @return Zero on success; -1 on failure.
	*/
	git_diff_options_init :: proc(opts: ^git_diff_options, version: c.uint) -> c.int ---

	/**
	* Initialize git_diff_find_options structure
	*
	* Initializes a `git_diff_find_options` with default values. Equivalent to creating
	* an instance with GIT_DIFF_FIND_OPTIONS_INIT.
	*
	* @param opts The `git_diff_find_options` struct to initialize.
	* @param version The struct version; pass `GIT_DIFF_FIND_OPTIONS_VERSION`.
	* @return Zero on success; -1 on failure.
	*/
	git_diff_find_options_init :: proc(opts: ^git_diff_find_options, version: c.uint) -> c.int ---

	/**
	* Deallocate a diff.
	*
	* @param diff The previously created diff; cannot be used after free.
	*/
	git_diff_free :: proc(diff: ^git_diff) ---

	/**
	* Create a diff with the difference between two tree objects.
	*
	* This is equivalent to `git diff <old-tree> <new-tree>`
	*
	* The first tree will be used for the "old_file" side of the delta and the
	* second tree will be used for the "new_file" side of the delta.  You can
	* pass NULL to indicate an empty tree, although it is an error to pass
	* NULL for both the `old_tree` and `new_tree`.
	*
	* @param diff Output pointer to a git_diff pointer to be allocated.
	* @param repo The repository containing the trees.
	* @param old_tree A git_tree object to diff from, or NULL for empty tree.
	* @param new_tree A git_tree object to diff to, or NULL for empty tree.
	* @param opts Structure with options to influence diff or NULL for defaults.
	* @return 0 or an error code.
	*/
	git_diff_tree_to_tree :: proc(diff: ^^git_diff, repo: ^git_repository, old_tree: ^git_tree, new_tree: ^git_tree, opts: ^git_diff_options) -> c.int ---

	/**
	* Create a diff between a tree and repository index.
	*
	* This is equivalent to `git diff --cached <treeish>` or if you pass
	* the HEAD tree, then like `git diff --cached`.
	*
	* The tree you pass will be used for the "old_file" side of the delta, and
	* the index will be used for the "new_file" side of the delta.
	*
	* If you pass NULL for the index, then the existing index of the `repo`
	* will be used.  In this case, the index will be refreshed from disk
	* (if it has changed) before the diff is generated.
	*
	* @param diff Output pointer to a git_diff pointer to be allocated.
	* @param repo The repository containing the tree and index.
	* @param old_tree A git_tree object to diff from, or NULL for empty tree.
	* @param index The index to diff with; repo index used if NULL.
	* @param opts Structure with options to influence diff or NULL for defaults.
	* @return 0 or an error code.
	*/
	git_diff_tree_to_index :: proc(diff: ^^git_diff, repo: ^git_repository, old_tree: ^git_tree, index: ^git_index, opts: ^git_diff_options) -> c.int ---

	/**
	* Create a diff between the repository index and the workdir directory.
	*
	* This matches the `git diff` command.  See the note below on
	* `git_diff_tree_to_workdir` for a discussion of the difference between
	* `git diff` and `git diff HEAD` and how to emulate a `git diff <treeish>`
	* using libgit2.
	*
	* The index will be used for the "old_file" side of the delta, and the
	* working directory will be used for the "new_file" side of the delta.
	*
	* If you pass NULL for the index, then the existing index of the `repo`
	* will be used.  In this case, the index will be refreshed from disk
	* (if it has changed) before the diff is generated.
	*
	* @param diff Output pointer to a git_diff pointer to be allocated.
	* @param repo The repository.
	* @param index The index to diff from; repo index used if NULL.
	* @param opts Structure with options to influence diff or NULL for defaults.
	* @return 0 or an error code.
	*/
	git_diff_index_to_workdir :: proc(diff: ^^git_diff, repo: ^git_repository, index: ^git_index, opts: ^git_diff_options) -> c.int ---

	/**
	* Create a diff between a tree and the working directory.
	*
	* The tree you provide will be used for the "old_file" side of the delta,
	* and the working directory will be used for the "new_file" side.
	*
	* This is not the same as `git diff <treeish>` or `git diff-index
	* <treeish>`.  Those commands use information from the index, whereas this
	* function strictly returns the differences between the tree and the files
	* in the working directory, regardless of the state of the index.  Use
	* `git_diff_tree_to_workdir_with_index` to emulate those commands.
	*
	* To see difference between this and `git_diff_tree_to_workdir_with_index`,
	* consider the example of a staged file deletion where the file has then
	* been put back into the working dir and further modified.  The
	* tree-to-workdir diff for that file is 'modified', but `git diff` would
	* show status 'deleted' since there is a staged delete.
	*
	* @param diff A pointer to a git_diff pointer that will be allocated.
	* @param repo The repository containing the tree.
	* @param old_tree A git_tree object to diff from, or NULL for empty tree.
	* @param opts Structure with options to influence diff or NULL for defaults.
	* @return 0 or an error code.
	*/
	git_diff_tree_to_workdir :: proc(diff: ^^git_diff, repo: ^git_repository, old_tree: ^git_tree, opts: ^git_diff_options) -> c.int ---

	/**
	* Create a diff between a tree and the working directory using index data
	* to account for staged deletes, tracked files, etc.
	*
	* This emulates `git diff <tree>` by diffing the tree to the index and
	* the index to the working directory and blending the results into a
	* single diff that includes staged deleted, etc.
	*
	* @param diff A pointer to a git_diff pointer that will be allocated.
	* @param repo The repository containing the tree.
	* @param old_tree A git_tree object to diff from, or NULL for empty tree.
	* @param opts Structure with options to influence diff or NULL for defaults.
	* @return 0 or an error code.
	*/
	git_diff_tree_to_workdir_with_index :: proc(diff: ^^git_diff, repo: ^git_repository, old_tree: ^git_tree, opts: ^git_diff_options) -> c.int ---

	/**
	* Create a diff with the difference between two index objects.
	*
	* The first index will be used for the "old_file" side of the delta and the
	* second index will be used for the "new_file" side of the delta.
	*
	* @param diff Output pointer to a git_diff pointer to be allocated.
	* @param repo The repository containing the indexes.
	* @param old_index A git_index object to diff from.
	* @param new_index A git_index object to diff to.
	* @param opts Structure with options to influence diff or NULL for defaults.
	* @return 0 or an error code.
	*/
	git_diff_index_to_index :: proc(diff: ^^git_diff, repo: ^git_repository, old_index: ^git_index, new_index: ^git_index, opts: ^git_diff_options) -> c.int ---

	/**
	* Merge one diff into another.
	*
	* This merges items from the "from" list into the "onto" list.  The
	* resulting diff will have all items that appear in either list.
	* If an item appears in both lists, then it will be "merged" to appear
	* as if the old version was from the "onto" list and the new version
	* is from the "from" list (with the exception that if the item has a
	* pending DELETE in the middle, then it will show as deleted).
	*
	* @param onto Diff to merge into.
	* @param from Diff to merge.
	* @return 0 or an error code.
	*/
	git_diff_merge :: proc(onto: ^git_diff, from: ^git_diff) -> c.int ---

	/**
	* Transform a diff marking file renames, copies, etc.
	*
	* This modifies a diff in place, replacing old entries that look
	* like renames or copies with new entries reflecting those changes.
	* This also will, if requested, break modified files into add/remove
	* pairs if the amount of change is above a threshold.
	*
	* @param diff diff to run detection algorithms on
	* @param options Control how detection should be run, NULL for defaults
	* @return 0 on success, -1 on failure
	*/
	git_diff_find_similar :: proc(diff: ^git_diff, options: ^git_diff_find_options) -> c.int ---

	/**
	* Query how many diff records are there in a diff.
	*
	* @param diff A git_diff generated by one of the above functions
	* @return Count of number of deltas in the list
	*/
	git_diff_num_deltas :: proc(diff: ^git_diff) -> c.int ---

	/**
	* Query how many diff deltas are there in a diff filtered by type.
	*
	* This works just like `git_diff_num_deltas()` with an extra parameter
	* that is a `git_delta_t` and returns just the count of how many deltas
	* match that particular type.
	*
	* @param diff A git_diff generated by one of the above functions
	* @param type A git_delta_t value to filter the count
	* @return Count of number of deltas matching delta_t type
	*/
	git_diff_num_deltas_of_type :: proc(diff: ^git_diff, type: git_delta_t) -> c.int ---

	/**
	* Return the diff delta for an entry in the diff list.
	*
	* The `git_diff_delta` pointer points to internal data and you do not
	* have to release it when you are done with it.  It will go away when
	* the * `git_diff` (or any associated `git_patch`) goes away.
	*
	* Note that the flags on the delta related to whether it has binary
	* content or not may not be set if there are no attributes set for the
	* file and there has been no reason to load the file data at this point.
	* For now, if you need those flags to be up to date, your only option is
	* to either use `git_diff_foreach` or create a `git_patch`.
	*
	* @param diff Diff list object
	* @param idx Index into diff list
	* @return Pointer to git_diff_delta (or NULL if `idx` out of range)
	*/
	git_diff_get_delta :: proc(diff: ^git_diff, idx: c.int) -> ^git_diff_delta ---

	/**
	* Check if deltas are sorted case sensitively or insensitively.
	*
	* @param diff diff to check
	* @return 0 if case sensitive, 1 if case is ignored
	*/
	git_diff_is_sorted_icase :: proc(diff: ^git_diff) -> c.int ---

	/**
	* Loop over all deltas in a diff issuing callbacks.
	*
	* This will iterate through all of the files described in a diff.  You
	* should provide a file callback to learn about each file.
	*
	* The "hunk" and "line" callbacks are optional, and the text diff of the
	* files will only be calculated if they are not NULL.  Of course, these
	* callbacks will not be invoked for binary files on the diff or for
	* files whose only changed is a file mode change.
	*
	* Returning a non-zero value from any of the callbacks will terminate
	* the iteration and return the value to the user.
	*
	* @param diff A git_diff generated by one of the above functions.
	* @param file_cb Callback function to make per file in the diff.
	* @param binary_cb Optional callback to make for binary files.
	* @param hunk_cb Optional callback to make per hunk of text diff.  This
	*                callback is called to describe a range of lines in the
	*                diff.  It will not be issued for binary files.
	* @param line_cb Optional callback to make per line of diff text.  This
	*                same callback will be made for context lines, added, and
	*                removed lines, and even for a deleted trailing newline.
	* @param payload Reference pointer that will be passed to your callbacks.
	* @return 0 on success, non-zero callback return value, or error code
	*/
	git_diff_foreach :: proc(diff: ^git_diff, file_cb: git_diff_file_cb, binary_cb: git_diff_binary_cb, hunk_cb: git_diff_hunk_cb, line_cb: git_diff_line_cb, payload: rawptr) -> c.int ---

	/**
	* Look up the single character abbreviation for a delta status code.
	*
	* When you run `git diff --name-status` it uses single letter codes in
	* the output such as 'A' for added, 'D' for deleted, 'M' for modified,
	* etc.  This function converts a git_delta_t value into these letters for
	* your own purposes.  GIT_DELTA_UNTRACKED will return a space (i.e. ' ').
	*
	* @param status The git_delta_t value to look up
	* @return The single character label for that code
	*/
	git_diff_status_char :: proc(status: git_delta_t) -> c.char ---

	/**
	* Iterate over a diff generating formatted text output.
	*
	* Returning a non-zero value from the callbacks will terminate the
	* iteration and return the non-zero value to the caller.
	*
	* @param diff A git_diff generated by one of the above functions.
	* @param format A git_diff_format_t value to pick the text format.
	* @param print_cb Callback to make per line of diff text.
	* @param payload Reference pointer that will be passed to your callback.
	* @return 0 on success, non-zero callback return value, or error code
	*/
	git_diff_print :: proc(diff: ^git_diff, format: git_diff_format_t, print_cb: git_diff_line_cb, payload: rawptr) -> c.int ---

	/**
	* Produce the complete formatted text output from a diff into a
	* buffer.
	*
	* @param out A pointer to a user-allocated git_buf that will
	*            contain the diff text
	* @param diff A git_diff generated by one of the above functions.
	* @param format A git_diff_format_t value to pick the text format.
	* @return 0 on success or error code
	*/
	git_diff_to_buf :: proc(out: ^git_buf, diff: ^git_diff, format: git_diff_format_t) -> c.int ---

	/**
	* Directly run a diff on two blobs.
	*
	* Compared to a file, a blob lacks some contextual information. As such,
	* the `git_diff_file` given to the callback will have some fake data; i.e.
	* `mode` will be 0 and `path` will be NULL.
	*
	* NULL is allowed for either `old_blob` or `new_blob` and will be treated
	* as an empty blob, with the `oid` set to NULL in the `git_diff_file` data.
	* Passing NULL for both blobs is a noop; no callbacks will be made at all.
	*
	* We do run a binary content check on the blob content and if either blob
	* looks like binary data, the `git_diff_delta` binary attribute will be set
	* to 1 and no call to the hunk_cb nor line_cb will be made (unless you pass
	* `GIT_DIFF_FORCE_TEXT` of course).
	*
	* @param old_blob Blob for old side of diff, or NULL for empty blob
	* @param old_as_path Treat old blob as if it had this filename; can be NULL
	* @param new_blob Blob for new side of diff, or NULL for empty blob
	* @param new_as_path Treat new blob as if it had this filename; can be NULL
	* @param options Options for diff, or NULL for default options
	* @param file_cb Callback for "file"; made once if there is a diff; can be NULL
	* @param binary_cb Callback for binary files; can be NULL
	* @param hunk_cb Callback for each hunk in diff; can be NULL
	* @param line_cb Callback for each line in diff; can be NULL
	* @param payload Payload passed to each callback function
	* @return 0 on success, non-zero callback return value, or error code
	*/
	git_diff_blobs :: proc(old_blob: ^git_blob, old_as_path: cstring, new_blob: ^git_blob, new_as_path: cstring, options: ^git_diff_options, file_cb: git_diff_file_cb, binary_cb: git_diff_binary_cb, hunk_cb: git_diff_hunk_cb, line_cb: git_diff_line_cb, payload: rawptr) -> c.int ---

	/**
	* Directly run a diff between a blob and a buffer.
	*
	* As with `git_diff_blobs`, comparing a blob and buffer lacks some context,
	* so the `git_diff_file` parameters to the callbacks will be faked a la the
	* rules for `git_diff_blobs()`.
	*
	* Passing NULL for `old_blob` will be treated as an empty blob (i.e. the
	* `file_cb` will be invoked with GIT_DELTA_ADDED and the diff will be the
	* entire content of the buffer added).  Passing NULL to the buffer will do
	* the reverse, with GIT_DELTA_REMOVED and blob content removed.
	*
	* @param old_blob Blob for old side of diff, or NULL for empty blob
	* @param old_as_path Treat old blob as if it had this filename; can be NULL
	* @param buffer Raw data for new side of diff, or NULL for empty
	* @param buffer_len Length of raw data for new side of diff
	* @param buffer_as_path Treat buffer as if it had this filename; can be NULL
	* @param options Options for diff, or NULL for default options
	* @param file_cb Callback for "file"; made once if there is a diff; can be NULL
	* @param binary_cb Callback for binary files; can be NULL
	* @param hunk_cb Callback for each hunk in diff; can be NULL
	* @param line_cb Callback for each line in diff; can be NULL
	* @param payload Payload passed to each callback function
	* @return 0 on success, non-zero callback return value, or error code
	*/
	git_diff_blob_to_buffer :: proc(old_blob: ^git_blob, old_as_path: cstring, buffer: cstring, buffer_len: c.int, buffer_as_path: cstring, options: ^git_diff_options, file_cb: git_diff_file_cb, binary_cb: git_diff_binary_cb, hunk_cb: git_diff_hunk_cb, line_cb: git_diff_line_cb, payload: rawptr) -> c.int ---

	/**
	* Directly run a diff between two buffers.
	*
	* Even more than with `git_diff_blobs`, comparing two buffer lacks
	* context, so the `git_diff_file` parameters to the callbacks will be
	* faked a la the rules for `git_diff_blobs()`.
	*
	* @param old_buffer Raw data for old side of diff, or NULL for empty
	* @param old_len Length of the raw data for old side of the diff
	* @param old_as_path Treat old buffer as if it had this filename; can be NULL
	* @param new_buffer Raw data for new side of diff, or NULL for empty
	* @param new_len Length of raw data for new side of diff
	* @param new_as_path Treat buffer as if it had this filename; can be NULL
	* @param options Options for diff, or NULL for default options
	* @param file_cb Callback for "file"; made once if there is a diff; can be NULL
	* @param binary_cb Callback for binary files; can be NULL
	* @param hunk_cb Callback for each hunk in diff; can be NULL
	* @param line_cb Callback for each line in diff; can be NULL
	* @param payload Payload passed to each callback function
	* @return 0 on success, non-zero callback return value, or error code
	*/
	git_diff_buffers :: proc(old_buffer: rawptr, old_len: c.int, old_as_path: cstring, new_buffer: rawptr, new_len: c.int, new_as_path: cstring, options: ^git_diff_options, file_cb: git_diff_file_cb, binary_cb: git_diff_binary_cb, hunk_cb: git_diff_hunk_cb, line_cb: git_diff_line_cb, payload: rawptr) -> c.int ---

	/**
	* Read the contents of a git patch file into a `git_diff` object.
	*
	* The diff object produced is similar to the one that would be
	* produced if you actually produced it computationally by comparing
	* two trees, however there may be subtle differences.  For example,
	* a patch file likely contains abbreviated object IDs, so the
	* object IDs in a `git_diff_delta` produced by this function will
	* also be abbreviated.
	*
	* This function will only read patch files created by a git
	* implementation, it will not read unified diffs produced by
	* the `diff` program, nor any other types of patch files.
	*
	* @note This API only supports SHA1 patch files
	* @see git_diff_from_buffer_ext
	*
	* @param out A pointer to a git_diff pointer that will be allocated.
	* @param content The contents of a patch file
	* @param content_len The length of the patch file contents
	* @return 0 or an error code
	*/
	git_diff_from_buffer :: proc(out: ^^git_diff, content: cstring, content_len: c.int) -> c.int ---

	/**
	* Accumulate diff statistics for all patches.
	*
	* @param out Structure containing the diff statistics.
	* @param diff A git_diff generated by one of the above functions.
	* @return 0 on success; non-zero on error
	*/
	git_diff_get_stats :: proc(out: ^^git_diff_stats, diff: ^git_diff) -> c.int ---

	/**
	* Get the total number of files changed in a diff
	*
	* @param stats A `git_diff_stats` generated by one of the above functions.
	* @return total number of files changed in the diff
	*/
	git_diff_stats_files_changed :: proc(stats: ^git_diff_stats) -> c.int ---

	/**
	* Get the total number of insertions in a diff
	*
	* @param stats A `git_diff_stats` generated by one of the above functions.
	* @return total number of insertions in the diff
	*/
	git_diff_stats_insertions :: proc(stats: ^git_diff_stats) -> c.int ---

	/**
	* Get the total number of deletions in a diff
	*
	* @param stats A `git_diff_stats` generated by one of the above functions.
	* @return total number of deletions in the diff
	*/
	git_diff_stats_deletions :: proc(stats: ^git_diff_stats) -> c.int ---

	/**
	* Print diff statistics to a `git_buf`.
	*
	* @param out buffer to store the formatted diff statistics in.
	* @param stats A `git_diff_stats` generated by one of the above functions.
	* @param format Formatting option.
	* @param width Target width for output (only affects GIT_DIFF_STATS_FULL)
	* @return 0 on success; non-zero on error
	*/
	git_diff_stats_to_buf :: proc(out: ^git_buf, stats: ^git_diff_stats, format: git_diff_stats_format_t, width: c.int) -> c.int ---

	/**
	* Deallocate a `git_diff_stats`.
	*
	* @param stats The previously created statistics object;
	* cannot be used after free.
	*/
	git_diff_stats_free :: proc(stats: ^git_diff_stats) ---

	/**
	* Initialize git_diff_patchid_options structure
	*
	* Initializes a `git_diff_patchid_options` with default values. Equivalent to
	* creating an instance with `GIT_DIFF_PATCHID_OPTIONS_INIT`.
	*
	* @param opts The `git_diff_patchid_options` struct to initialize.
	* @param version The struct version; pass `GIT_DIFF_PATCHID_OPTIONS_VERSION`.
	* @return Zero on success; -1 on failure.
	*/
	git_diff_patchid_options_init :: proc(opts: ^git_diff_patchid_options, version: c.uint) -> c.int ---

	/**
	* Calculate the patch ID for the given patch.
	*
	* Calculate a stable patch ID for the given patch by summing the
	* hash of the file diffs, ignoring whitespace and line numbers.
	* This can be used to derive whether two diffs are the same with
	* a high probability.
	*
	* Currently, this function only calculates stable patch IDs, as
	* defined in git-patch-id(1), and should in fact generate the
	* same IDs as the upstream git project does.
	*
	* @param out Pointer where the calculated patch ID should be stored
	* @param diff The diff to calculate the ID for
	* @param opts Options for how to calculate the patch ID. This is
	*  intended for future changes, as currently no options are
	*  available.
	* @return 0 on success, an error code otherwise.
	*/
	git_diff_patchid :: proc(out: ^git_oid, diff: ^git_diff, opts: ^git_diff_patchid_options) -> c.int ---
}
