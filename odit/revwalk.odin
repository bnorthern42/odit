/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_revwalk_h__ :: 

/**
* Flags to specify the sorting which a revwalk should perform.
*/
git_sort_t :: enum c.uint {
	/**
	* Sort the output with the same default method from `git`: reverse
	* chronological order. This is the default sorting for new walkers.
	*/
	NONE = 0,

	/**
	* Sort the repository contents in topological order (no parents before
	* all of its children are shown); this sorting mode can be combined
	* with time sorting to produce `git`'s `--date-order``.
	*/
	TOPOLOGICAL = 1,

	/**
	* Sort the repository contents by commit time;
	* this sorting mode can be combined with
	* topological sorting.
	*/
	TIME = 2,

	/**
	* Iterate through the repository contents in reverse
	* order; this sorting mode can be combined with
	* any of the above.
	*/
	REVERSE = 4,
}

/**
* This is a callback function that user can provide to hide a
* commit and its parents. If the callback function returns non-zero value,
* then this commit and its parents will be hidden.
*
* @param commit_id oid of Commit
* @param payload User-specified pointer to data to be passed as data payload
* @return non-zero to hide the commmit and it parent.
*/
git_revwalk_hide_cb :: proc "c" (^git_oid, rawptr) -> c.int

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Allocate a new revision walker to iterate through a repo.
	*
	* This revision walker uses a custom memory pool and an internal
	* commit cache, so it is relatively expensive to allocate.
	*
	* For maximum performance, this revision walker should be
	* reused for different walks.
	*
	* This revision walker is *not* thread safe: it may only be
	* used to walk a repository on a single thread; however,
	* it is possible to have several revision walkers in
	* several different threads walking the same repository.
	*
	* @param out pointer to the new revision walker
	* @param repo the repo to walk through
	* @return 0 or an error code
	*/
	git_revwalk_new :: proc(out: ^^git_revwalk, repo: ^git_repository) -> c.int ---

	/**
	* Reset the revision walker for reuse.
	*
	* This will clear all the pushed and hidden commits, and
	* leave the walker in a blank state (just like at
	* creation) ready to receive new commit pushes and
	* start a new walk.
	*
	* The revision walk is automatically reset when a walk
	* is over.
	*
	* @param walker handle to reset.
	* @return 0 or an error code
	*/
	git_revwalk_reset :: proc(walker: ^git_revwalk) -> c.int ---

	/**
	* Add a new root for the traversal
	*
	* The pushed commit will be marked as one of the roots from which to
	* start the walk. This commit may not be walked if it or a child is
	* hidden.
	*
	* At least one commit must be pushed onto the walker before a walk
	* can be started.
	*
	* The given id must belong to a committish on the walked
	* repository.
	*
	* @param walk the walker being used for the traversal.
	* @param id the oid of the commit to start from.
	* @return 0 or an error code
	*/
	git_revwalk_push :: proc(walk: ^git_revwalk, id: ^git_oid) -> c.int ---

	/**
	* Push matching references
	*
	* The OIDs pointed to by the references that match the given glob
	* pattern will be pushed to the revision walker.
	*
	* A leading 'refs/' is implied if not present as well as a trailing
	* '/\*' if the glob lacks '?', '\*' or '['.
	*
	* Any references matching this glob which do not point to a
	* committish will be ignored.
	*
	* @param walk the walker being used for the traversal
	* @param glob the glob pattern references should match
	* @return 0 or an error code
	*/
	git_revwalk_push_glob :: proc(walk: ^git_revwalk, glob: cstring) -> c.int ---

	/**
	* Push the repository's HEAD
	*
	* @param walk the walker being used for the traversal
	* @return 0 or an error code
	*/
	git_revwalk_push_head :: proc(walk: ^git_revwalk) -> c.int ---

	/**
	* Mark a commit (and its ancestors) uninteresting for the output.
	*
	* The given id must belong to a committish on the walked
	* repository.
	*
	* The resolved commit and all its parents will be hidden from the
	* output on the revision walk.
	*
	* @param walk the walker being used for the traversal.
	* @param commit_id the oid of commit that will be ignored during the traversal
	* @return 0 or an error code
	*/
	git_revwalk_hide :: proc(walk: ^git_revwalk, commit_id: ^git_oid) -> c.int ---

	/**
	* Hide matching references.
	*
	* The OIDs pointed to by the references that match the given glob
	* pattern and their ancestors will be hidden from the output on the
	* revision walk.
	*
	* A leading 'refs/' is implied if not present as well as a trailing
	* '/\*' if the glob lacks '?', '\*' or '['.
	*
	* Any references matching this glob which do not point to a
	* committish will be ignored.
	*
	* @param walk the walker being used for the traversal
	* @param glob the glob pattern references should match
	* @return 0 or an error code
	*/
	git_revwalk_hide_glob :: proc(walk: ^git_revwalk, glob: cstring) -> c.int ---

	/**
	* Hide the repository's HEAD
	*
	* @param walk the walker being used for the traversal
	* @return 0 or an error code
	*/
	git_revwalk_hide_head :: proc(walk: ^git_revwalk) -> c.int ---

	/**
	* Push the OID pointed to by a reference
	*
	* The reference must point to a committish.
	*
	* @param walk the walker being used for the traversal
	* @param refname the reference to push
	* @return 0 or an error code
	*/
	git_revwalk_push_ref :: proc(walk: ^git_revwalk, refname: cstring) -> c.int ---

	/**
	* Hide the OID pointed to by a reference
	*
	* The reference must point to a committish.
	*
	* @param walk the walker being used for the traversal
	* @param refname the reference to hide
	* @return 0 or an error code
	*/
	git_revwalk_hide_ref :: proc(walk: ^git_revwalk, refname: cstring) -> c.int ---

	/**
	* Get the next commit from the revision walk.
	*
	* The initial call to this method is *not* blocking when
	* iterating through a repo with a time-sorting mode.
	*
	* Iterating with Topological or inverted modes makes the initial
	* call blocking to preprocess the commit list, but this block should be
	* mostly unnoticeable on most repositories (topological preprocessing
	* times at 0.3s on the git.git repo).
	*
	* The revision walker is reset when the walk is over.
	*
	* @param out Pointer where to store the oid of the next commit
	* @param walk the walker to pop the commit from.
	* @return 0 if the next commit was found;
	*	GIT_ITEROVER if there are no commits left to iterate
	*/
	git_revwalk_next :: proc(out: ^git_oid, walk: ^git_revwalk) -> c.int ---

	/**
	* Change the sorting mode when iterating through the
	* repository's contents.
	*
	* Changing the sorting mode resets the walker.
	*
	* @param walk the walker being used for the traversal.
	* @param sort_mode combination of GIT_SORT_XXX flags
	* @return 0 or an error code
	*/
	git_revwalk_sorting :: proc(walk: ^git_revwalk, sort_mode: c.uint) -> c.int ---

	/**
	* Push and hide the respective endpoints of the given range.
	*
	* The range should be of the form
	*   <commit>..<commit>
	* where each <commit> is in the form accepted by 'git_revparse_single'.
	* The left-hand commit will be hidden and the right-hand commit pushed.
	*
	* @param walk the walker being used for the traversal
	* @param range the range
	* @return 0 or an error code
	*
	*/
	git_revwalk_push_range :: proc(walk: ^git_revwalk, range: cstring) -> c.int ---

	/**
	* Simplify the history by first-parent
	*
	* No parents other than the first for each commit will be enqueued.
	*
	* @param walk The revision walker.
	* @return 0 or an error code
	*/
	git_revwalk_simplify_first_parent :: proc(walk: ^git_revwalk) -> c.int ---

	/**
	* Free a revision walker previously allocated.
	*
	* @param walk traversal handle to close. If NULL nothing occurs.
	*/
	git_revwalk_free :: proc(walk: ^git_revwalk) ---

	/**
	* Return the repository on which this walker
	* is operating.
	*
	* @param walk the revision walker
	* @return the repository being walked
	*/
	git_revwalk_repository :: proc(walk: ^git_revwalk) -> ^git_repository ---

	/**
	* Adds, changes or removes a callback function to hide a commit and its parents
	*
	* @param walk the revision walker
	* @param hide_cb  callback function to hide a commit and its parents
	* @param payload  data payload to be passed to callback function
	* @return 0 or an error code.
	*/
	git_revwalk_add_hide_cb :: proc(walk: ^git_revwalk, hide_cb: git_revwalk_hide_cb, payload: rawptr) -> c.int ---
}
