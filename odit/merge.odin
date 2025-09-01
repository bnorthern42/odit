/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_merge_h__ :: 

/**
* The file inputs to `git_merge_file`.  Callers should populate the
* `git_merge_file_input` structure with descriptions of the files in
* each side of the conflict for use in producing the merge file.
*/
git_merge_file_input :: struct {}

/** Current version for the `git_merge_file_input_options` structure */
GIT_MERGE_FILE_INPUT_VERSION :: 1

/** Static constructor for `git_merge_file_input_options` */
GIT_MERGE_FILE_INPUT_INIT :: {GIT_MERGE_FILE_INPUT_VERSION}

/**
* Flags for `git_merge` options.  A combination of these flags can be
* passed in via the `flags` value in the `git_merge_options`.
*/
git_merge_flag_t :: enum c.uint {
	/**
	* Detect renames that occur between the common ancestor and the "ours"
	* side or the common ancestor and the "theirs" side.  This will enable
	* the ability to merge between a modified and renamed file.
	*/
	FIND_RENAMES = 1,

	/**
	* If a conflict occurs, exit immediately instead of attempting to
	* continue resolving conflicts.  The merge operation will fail with
	* GIT_EMERGECONFLICT and no index will be returned.
	*/
	FAIL_ON_CONFLICT = 2,

	/**
	* Do not write the REUC extension on the generated index
	*/
	SKIP_REUC = 4,

	/**
	* If the commits being merged have multiple merge bases, do not build
	* a recursive merge base (by merging the multiple merge bases),
	* instead simply use the first base.  This flag provides a similar
	* merge base to `git-merge-resolve`.
	*/
	NO_RECURSIVE = 8,

	/**
	* Treat this merge as if it is to produce the virtual base
	* of a recursive merge.  This will ensure that there are
	* no conflicts, any conflicting regions will keep conflict
	* markers in the merge result.
	*/
	VIRTUAL_BASE = 16,
}

/**
* Merge file favor options for `git_merge_options` instruct the file-level
* merging functionality how to deal with conflicting regions of the files.
*/
git_merge_file_favor_t :: enum c.uint {
	/**
	* When a region of a file is changed in both branches, a conflict
	* will be recorded in the index so that `git_checkout` can produce
	* a merge file with conflict markers in the working directory.
	* This is the default.
	*/
	NORMAL,

	/**
	* When a region of a file is changed in both branches, the file
	* created in the index will contain the "ours" side of any conflicting
	* region.  The index will not record a conflict.
	*/
	OURS,

	/**
	* When a region of a file is changed in both branches, the file
	* created in the index will contain the "theirs" side of any conflicting
	* region.  The index will not record a conflict.
	*/
	THEIRS,

	/**
	* When a region of a file is changed in both branches, the file
	* created in the index will contain each unique line from each side,
	* which has the result of combining both files.  The index will not
	* record a conflict.
	*/
	UNION,
}

/**
* File merging flags
*/
git_merge_file_flag_t :: enum c.uint {
	/** Defaults */
	DEFAULT = 0,

	/** Create standard conflicted merge files */
	STYLE_MERGE = 1,

	/** Create diff3-style files */
	STYLE_DIFF3 = 2,

	/** Condense non-alphanumeric regions for simplified diff file */
	SIMPLIFY_ALNUM = 4,

	/** Ignore all whitespace */
	IGNORE_WHITESPACE = 8,

	/** Ignore changes in amount of whitespace */
	IGNORE_WHITESPACE_CHANGE = 16,

	/** Ignore whitespace at end of line */
	IGNORE_WHITESPACE_EOL = 32,

	/** Use the "patience diff" algorithm */
	DIFF_PATIENCE = 64,

	/** Take extra time to find minimal diff */
	DIFF_MINIMAL = 128,

	/** Create zdiff3 ("zealous diff3")-style files */
	STYLE_ZDIFF3 = 256,

	/**
	* Do not produce file conflicts when common regions have
	* changed; keep the conflict markers in the file and accept
	* that as the merge result.
	*/
	ACCEPT_CONFLICTS = 512,
}

/** Default size for conflict markers */
GIT_MERGE_CONFLICT_MARKER_SIZE :: 7

/**
* Options for merging a file
*/
git_merge_file_options :: struct {
	version: c.uint,

	/**
	* Label for the ancestor file side of the conflict which will be prepended
	* to labels in diff3-format merge files.
	*/
	ancestor_label: cstring,

	/**
	* Label for our file side of the conflict which will be prepended
	* to labels in merge files.
	*/
	our_label: cstring,

	/**
	* Label for their file side of the conflict which will be prepended
	* to labels in merge files.
	*/
	their_label: cstring,

	/** The file to favor in region conflicts. */
	favor: git_merge_file_favor_t,

	/** see `git_merge_file_flag_t` above */
	flags: u32,

	/** The size of conflict markers (eg, "<<<<<<<").  Default is
	* GIT_MERGE_CONFLICT_MARKER_SIZE. */
	marker_size: c.ushort,
}

/** Current version for the `git_merge_file_options` structure */
GIT_MERGE_FILE_OPTIONS_VERSION :: 1

/** Static constructor for `git_merge_file_options` */
GIT_MERGE_FILE_OPTIONS_INIT :: {GIT_MERGE_FILE_OPTIONS_VERSION}

/**
* Information about file-level merging
*/
git_merge_file_result :: struct {}

/**
* Merging options
*/
git_merge_options :: struct {
	version: c.uint,

	/** See `git_merge_flag_t` above */
	flags: u32,

	/**
	* Similarity to consider a file renamed (default 50).  If
	* `GIT_MERGE_FIND_RENAMES` is enabled, added files will be compared
	* with deleted files to determine their similarity.  Files that are
	* more similar than the rename threshold (percentage-wise) will be
	* treated as a rename.
	*/
	rename_threshold: c.uint,

	/**
	* Maximum similarity sources to examine for renames (default 200).
	* If the number of rename candidates (add / delete pairs) is greater
	* than this value, inexact rename detection is aborted.
	*
	* This setting overrides the `merge.renameLimit` configuration value.
	*/
	target_limit: c.uint,

	/** Pluggable similarity metric; pass NULL to use internal metric */
	metric: ^git_diff_similarity_metric,

	/**
	* Maximum number of times to merge common ancestors to build a
	* virtual merge base when faced with criss-cross merges.  When this
	* limit is reached, the next ancestor will simply be used instead of
	* attempting to merge it.  The default is unlimited.
	*/
	recursion_limit: c.uint,

	/**
	* Default merge driver to be used when both sides of a merge have
	* changed.  The default is the `text` driver.
	*/
	default_driver: cstring,

	/**
	* Flags for handling conflicting content, to be used with the standard
	* (`text`) merge driver.
	*/
	file_favor: git_merge_file_favor_t,

	/** see `git_merge_file_flag_t` above */
	file_flags: u32,
}

/** Current version for the `git_merge_options` structure */
GIT_MERGE_OPTIONS_VERSION :: 1

/** Static constructor for `git_merge_options` */
GIT_MERGE_OPTIONS_INIT :: {GIT_MERGE_OPTIONS_VERSION, GIT_MERGE_FIND_RENAMES}

/**
* The results of `git_merge_analysis` indicate the merge opportunities.
*/
git_merge_analysis_t :: enum c.uint {
	/** No merge is possible.  (Unused.) */
	NONE = 0,

	/**
	* A "normal" merge; both HEAD and the given merge input have diverged
	* from their common ancestor.  The divergent commits must be merged.
	*/
	NORMAL = 1,

	/**
	* All given merge inputs are reachable from HEAD, meaning the
	* repository is up-to-date and no merge needs to be performed.
	*/
	UP_TO_DATE = 2,

	/**
	* The given merge input is a fast-forward from HEAD and no merge
	* needs to be performed.  Instead, the client can check out the
	* given merge input.
	*/
	FASTFORWARD = 4,

	/**
	* The HEAD of the current repository is "unborn" and does not point to
	* a valid commit.  No merge can be performed, but the caller may wish
	* to simply set HEAD to the target commit(s).
	*/
	UNBORN = 8,
}

/**
* The user's stated preference for merges.
*/
git_merge_preference_t :: enum c.uint {
	/**
	* No configuration was found that suggests a preferred behavior for
	* merge.
	*/
	NONE,

	/**
	* There is a `merge.ff=false` configuration setting, suggesting that
	* the user does not want to allow a fast-forward merge.
	*/
	NO_FASTFORWARD,

	/**
	* There is a `merge.ff=only` configuration setting, suggesting that
	* the user only wants fast-forward merges.
	*/
	FASTFORWARD_ONLY,
}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Initializes a `git_merge_file_input` with default values. Equivalent to
	* creating an instance with GIT_MERGE_FILE_INPUT_INIT.
	*
	* @param opts the `git_merge_file_input` instance to initialize.
	* @param version the version of the struct; you should pass
	*        `GIT_MERGE_FILE_INPUT_VERSION` here.
	* @return Zero on success; -1 on failure.
	*/
	git_merge_file_input_init :: proc(opts: ^git_merge_file_input, version: c.uint) -> c.int ---

	/**
	* Initialize git_merge_file_options structure
	*
	* Initializes a `git_merge_file_options` with default values. Equivalent to
	* creating an instance with `GIT_MERGE_FILE_OPTIONS_INIT`.
	*
	* @param opts The `git_merge_file_options` struct to initialize.
	* @param version The struct version; pass `GIT_MERGE_FILE_OPTIONS_VERSION`.
	* @return Zero on success; -1 on failure.
	*/
	git_merge_file_options_init :: proc(opts: ^git_merge_file_options, version: c.uint) -> c.int ---

	/**
	* Initialize git_merge_options structure
	*
	* Initializes a `git_merge_options` with default values. Equivalent to
	* creating an instance with `GIT_MERGE_OPTIONS_INIT`.
	*
	* @param opts The `git_merge_options` struct to initialize.
	* @param version The struct version; pass `GIT_MERGE_OPTIONS_VERSION`.
	* @return Zero on success; -1 on failure.
	*/
	git_merge_options_init :: proc(opts: ^git_merge_options, version: c.uint) -> c.int ---

	/**
	* Analyzes the given branch(es) and determines the opportunities for
	* merging them into the HEAD of the repository.
	*
	* @param analysis_out analysis enumeration that the result is written into
	* @param preference_out One of the `git_merge_preference_t` flag.
	* @param repo the repository to merge
	* @param their_heads the heads to merge into
	* @param their_heads_len the number of heads to merge
	* @return 0 on success or error code
	*/
	git_merge_analysis :: proc(analysis_out: ^git_merge_analysis_t, preference_out: ^git_merge_preference_t, repo: ^git_repository, their_heads: ^^git_annotated_commit, their_heads_len: c.int) -> c.int ---

	/**
	* Analyzes the given branch(es) and determines the opportunities for
	* merging them into a reference.
	*
	* @param analysis_out analysis enumeration that the result is written into
	* @param preference_out One of the `git_merge_preference_t` flag.
	* @param repo the repository to merge
	* @param our_ref the reference to perform the analysis from
	* @param their_heads the heads to merge into
	* @param their_heads_len the number of heads to merge
	* @return 0 on success or error code
	*/
	git_merge_analysis_for_ref :: proc(analysis_out: ^git_merge_analysis_t, preference_out: ^git_merge_preference_t, repo: ^git_repository, our_ref: ^git_reference, their_heads: ^^git_annotated_commit, their_heads_len: c.int) -> c.int ---

	/**
	* Find a merge base between two commits
	*
	* @param out the OID of a merge base between 'one' and 'two'
	* @param repo the repository where the commits exist
	* @param one one of the commits
	* @param two the other commit
	* @return 0 on success, GIT_ENOTFOUND if not found or error code
	*/
	git_merge_base :: proc(out: ^git_oid, repo: ^git_repository, one: ^git_oid, two: ^git_oid) -> c.int ---

	/**
	* Find merge bases between two commits
	*
	* @param out array in which to store the resulting ids
	* @param repo the repository where the commits exist
	* @param one one of the commits
	* @param two the other commit
	* @return 0 on success, GIT_ENOTFOUND if not found or error code
	*/
	git_merge_bases :: proc(out: ^git_oidarray, repo: ^git_repository, one: ^git_oid, two: ^git_oid) -> c.int ---

	/**
	* Find a merge base given a list of commits
	*
	* @param out the OID of a merge base considering all the commits
	* @param repo the repository where the commits exist
	* @param length The number of commits in the provided `input_array`
	* @param input_array oids of the commits
	* @return Zero on success; GIT_ENOTFOUND or -1 on failure.
	*/
	git_merge_base_many :: proc(out: ^git_oid, repo: ^git_repository, length: c.int, input_array: []git_oid) -> c.int ---

	/**
	* Find all merge bases given a list of commits
	*
	* This behaves similar to [`git merge-base`](https://git-scm.com/docs/git-merge-base#_discussion).
	*
	* Given three commits `a`, `b`, and `c`, `merge_base_many`
	* will compute a hypothetical commit `m`, which is a merge between `b`
	* and `c`.
	
	* For example, with the following topology:
	* ```text
	*        o---o---o---o---C
	*       /
	*      /   o---o---o---B
	*     /   /
	* ---2---1---o---o---o---A
	* ```
	*
	* the result of `merge_base_many` given `a`, `b`, and `c` is 1. This is
	* because the equivalent topology with the imaginary merge commit `m`
	* between `b` and `c` is:
	* ```text
	*        o---o---o---o---o
	*       /                 \
	*      /   o---o---o---o---M
	*     /   /
	* ---2---1---o---o---o---A
	* ```
	*
	* and the result of `merge_base_many` given `a` and `m` is 1.
	*
	* If you're looking to recieve the common ancestor between all the
	* given commits, use `merge_base_octopus`.
	*
	* @param out array in which to store the resulting ids
	* @param repo the repository where the commits exist
	* @param length The number of commits in the provided `input_array`
	* @param input_array oids of the commits
	* @return Zero on success; GIT_ENOTFOUND or -1 on failure.
	*/
	git_merge_bases_many :: proc(out: ^git_oidarray, repo: ^git_repository, length: c.int, input_array: []git_oid) -> c.int ---

	/**
	* Find a merge base in preparation for an octopus merge
	*
	* @param out the OID of a merge base considering all the commits
	* @param repo the repository where the commits exist
	* @param length The number of commits in the provided `input_array`
	* @param input_array oids of the commits
	* @return Zero on success; GIT_ENOTFOUND or -1 on failure.
	*/
	git_merge_base_octopus :: proc(out: ^git_oid, repo: ^git_repository, length: c.int, input_array: []git_oid) -> c.int ---

	/**
	* Merge two files as they exist in the in-memory data structures, using
	* the given common ancestor as the baseline, producing a
	* `git_merge_file_result` that reflects the merge result.  The
	* `git_merge_file_result` must be freed with `git_merge_file_result_free`.
	*
	* Note that this function does not reference a repository and any
	* configuration must be passed as `git_merge_file_options`.
	*
	* @param out The git_merge_file_result to be filled in
	* @param ancestor The contents of the ancestor file
	* @param ours The contents of the file in "our" side
	* @param theirs The contents of the file in "their" side
	* @param opts The merge file options or `NULL` for defaults
	* @return 0 on success or error code
	*/
	git_merge_file :: proc(out: ^git_merge_file_result, ancestor: ^git_merge_file_input, ours: ^git_merge_file_input, theirs: ^git_merge_file_input, opts: ^git_merge_file_options) -> c.int ---

	/**
	* Merge two files as they exist in the index, using the given common
	* ancestor as the baseline, producing a `git_merge_file_result` that
	* reflects the merge result.  The `git_merge_file_result` must be freed with
	* `git_merge_file_result_free`.
	*
	* @param out The git_merge_file_result to be filled in
	* @param repo The repository
	* @param ancestor The index entry for the ancestor file (stage level 1)
	* @param ours The index entry for our file (stage level 2)
	* @param theirs The index entry for their file (stage level 3)
	* @param opts The merge file options or NULL
	* @return 0 on success or error code
	*/
	git_merge_file_from_index :: proc(out: ^git_merge_file_result, repo: ^git_repository, ancestor: ^git_index_entry, ours: ^git_index_entry, theirs: ^git_index_entry, opts: ^git_merge_file_options) -> c.int ---

	/**
	* Frees a `git_merge_file_result`.
	*
	* @param result The result to free or `NULL`
	*/
	git_merge_file_result_free :: proc(result: ^git_merge_file_result) ---

	/**
	* Merge two trees, producing a `git_index` that reflects the result of
	* the merge.  The index may be written as-is to the working directory
	* or checked out.  If the index is to be converted to a tree, the caller
	* should resolve any conflicts that arose as part of the merge.
	*
	* The returned index must be freed explicitly with `git_index_free`.
	*
	* @param out pointer to store the index result in
	* @param repo repository that contains the given trees
	* @param ancestor_tree the common ancestor between the trees (or null if none)
	* @param our_tree the tree that reflects the destination tree
	* @param their_tree the tree to merge in to `our_tree`
	* @param opts the merge tree options (or null for defaults)
	* @return 0 on success or error code
	*/
	git_merge_trees :: proc(out: ^^git_index, repo: ^git_repository, ancestor_tree: ^git_tree, our_tree: ^git_tree, their_tree: ^git_tree, opts: ^git_merge_options) -> c.int ---

	/**
	* Merge two commits, producing a `git_index` that reflects the result of
	* the merge.  The index may be written as-is to the working directory
	* or checked out.  If the index is to be converted to a tree, the caller
	* should resolve any conflicts that arose as part of the merge.
	*
	* The returned index must be freed explicitly with `git_index_free`.
	*
	* @param out pointer to store the index result in
	* @param repo repository that contains the given trees
	* @param our_commit the commit that reflects the destination tree
	* @param their_commit the commit to merge in to `our_commit`
	* @param opts the merge tree options (or null for defaults)
	* @return 0 on success or error code
	*/
	git_merge_commits :: proc(out: ^^git_index, repo: ^git_repository, our_commit: ^git_commit, their_commit: ^git_commit, opts: ^git_merge_options) -> c.int ---

	/**
	* Merges the given commit(s) into HEAD, writing the results into the working
	* directory.  Any changes are staged for commit and any conflicts are written
	* to the index.  Callers should inspect the repository's index after this
	* completes, resolve any conflicts and prepare a commit.
	*
	* For compatibility with git, the repository is put into a merging
	* state. Once the commit is done (or if the user wishes to abort),
	* you should clear this state by calling
	* `git_repository_state_cleanup()`.
	*
	* @param repo the repository to merge
	* @param their_heads the heads to merge into
	* @param their_heads_len the number of heads to merge
	* @param merge_opts merge options
	* @param checkout_opts checkout options
	* @return 0 on success or error code
	*/
	git_merge :: proc(repo: ^git_repository, their_heads: ^^git_annotated_commit, their_heads_len: c.int, merge_opts: ^git_merge_options, checkout_opts: ^git_checkout_options) -> c.int ---
}
