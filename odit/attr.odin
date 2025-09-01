/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_attr_h__ :: 

/**
* Possible states for an attribute
*/
git_attr_value_t :: enum c.uint {
	UNSPECIFIED, /**< The attribute has been left unspecified */
	TRUE,        /**< The attribute has been set */
	FALSE,       /**< The attribute has been unset */
	STRING,      /**< This attribute has a value */
}

/**
 * Check attribute flags: Reading values from index and working directory.
 *
 * When checking attributes, it is possible to check attribute files
 * in both the working directory (if there is one) and the index (if
 * there is one).  You can explicitly choose where to check and in
 * which order using the following flags.
 *
 * Core git usually checks the working directory then the index,
 * except during a checkout when it checks the index first.  It will
 * use index only for creating archives or for a bare repo (if an
 * index has been specified for the bare repo).
 */

/** Examine attribute in working directory, then index */
GIT_ATTR_CHECK_FILE_THEN_INDEX :: 0

/** Examine attribute in index, then working directory */
GIT_ATTR_CHECK_INDEX_THEN_FILE :: 1

/** Examine attributes only in the index */
GIT_ATTR_CHECK_INDEX_ONLY :: 2

/**
 * Check attribute flags: controlling extended attribute behavior.
 *
 * Normally, attribute checks include looking in the /etc (or system
 * equivalent) directory for a `gitattributes` file.  Passing the
 * `GIT_ATTR_CHECK_NO_SYSTEM` flag will cause attribute checks to
 * ignore that file.
 *
 * Passing the `GIT_ATTR_CHECK_INCLUDE_HEAD` flag will use attributes
 * from a `.gitattributes` file in the repository at the HEAD revision.
 *
 * Passing the `GIT_ATTR_CHECK_INCLUDE_COMMIT` flag will use attributes
 * from a `.gitattributes` file in a specific commit.
 */

/** Ignore system attributes */
GIT_ATTR_CHECK_NO_SYSTEM        :: (1<<2)

/** Honor `.gitattributes` in the HEAD revision */
GIT_ATTR_CHECK_INCLUDE_HEAD     :: (1<<3)

/** Honor `.gitattributes` in a specific commit */
GIT_ATTR_CHECK_INCLUDE_COMMIT   :: (1<<4)

/**
* An options structure for querying attributes.
*/
git_attr_options :: struct {
	version:   c.uint,

	/** A combination of GIT_ATTR_CHECK flags */
	flags: c.uint,
	commit_id: ^git_oid,

	/**
	* The commit to load attributes from, when
	* `GIT_ATTR_CHECK_INCLUDE_COMMIT` is specified.
	*/
	attr_commit_id: git_oid,
}

/** Current version for the `git_attr_options` structure */
GIT_ATTR_OPTIONS_VERSION :: 1

/** Static constructor for `git_attr_options` */
GIT_ATTR_OPTIONS_INIT :: {GIT_ATTR_OPTIONS_VERSION}

/**
* The callback used with git_attr_foreach.
*
* This callback will be invoked only once per attribute name, even if there
* are multiple rules for a given file. The highest priority rule will be
* used.
*
* @see git_attr_foreach.
*
* @param name The attribute name.
* @param value The attribute value. May be NULL if the attribute is explicitly
*              set to UNSPECIFIED using the '!' sign.
* @param payload A user-specified pointer.
* @return 0 to continue looping, non-zero to stop. This value will be returned
*         from git_attr_foreach.
*/
git_attr_foreach_cb :: proc "c" (cstring, cstring, rawptr) -> c.int

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Return the value type for a given attribute.
	*
	* This can be either `TRUE`, `FALSE`, `UNSPECIFIED` (if the attribute
	* was not set at all), or `VALUE`, if the attribute was set to an
	* actual string.
	*
	* If the attribute has a `VALUE` string, it can be accessed normally
	* as a NULL-terminated C string.
	*
	* @param attr The attribute
	* @return the value type for the attribute
	*/
	git_attr_value :: proc(attr: cstring) -> git_attr_value_t ---

	/**
	* Look up the value of one git attribute for path.
	*
	* @param value_out Output of the value of the attribute.  Use the GIT_ATTR_...
	*             macros to test for TRUE, FALSE, UNSPECIFIED, etc. or just
	*             use the string value for attributes set to a value.  You
	*             should NOT modify or free this value.
	* @param repo The repository containing the path.
	* @param flags A combination of GIT_ATTR_CHECK... flags.
	* @param path The path to check for attributes.  Relative paths are
	*             interpreted relative to the repo root.  The file does
	*             not have to exist, but if it does not, then it will be
	*             treated as a plain file (not a directory).
	* @param name The name of the attribute to look up.
	* @return 0 or an error code.
	*/
	git_attr_get :: proc(value_out: [^]cstring, repo: ^git_repository, flags: u32, path: cstring, name: cstring) -> c.int ---

	/**
	* Look up the value of one git attribute for path with extended options.
	*
	* @param value_out Output of the value of the attribute.  Use the GIT_ATTR_...
	*             macros to test for TRUE, FALSE, UNSPECIFIED, etc. or just
	*             use the string value for attributes set to a value.  You
	*             should NOT modify or free this value.
	* @param repo The repository containing the path.
	* @param opts The `git_attr_options` to use when querying these attributes.
	* @param path The path to check for attributes.  Relative paths are
	*             interpreted relative to the repo root.  The file does
	*             not have to exist, but if it does not, then it will be
	*             treated as a plain file (not a directory).
	* @param name The name of the attribute to look up.
	* @return 0 or an error code.
	*/
	git_attr_get_ext :: proc(value_out: [^]cstring, repo: ^git_repository, opts: ^git_attr_options, path: cstring, name: cstring) -> c.int ---

	/**
	* Look up a list of git attributes for path.
	*
	* Use this if you have a known list of attributes that you want to
	* look up in a single call.  This is somewhat more efficient than
	* calling `git_attr_get()` multiple times.
	*
	* For example, you might write:
	*
	*     const char *attrs[] = { "crlf", "diff", "foo" };
	*     const char **values[3];
	*     git_attr_get_many(values, repo, 0, "my/fun/file.c", 3, attrs);
	*
	* Then you could loop through the 3 values to get the settings for
	* the three attributes you asked about.
	*
	* @param values_out An array of num_attr entries that will have string
	*             pointers written into it for the values of the attributes.
	*             You should not modify or free the values that are written
	*             into this array (although of course, you should free the
	*             array itself if you allocated it).
	* @param repo The repository containing the path.
	* @param flags A combination of GIT_ATTR_CHECK... flags.
	* @param path The path inside the repo to check attributes.  This
	*             does not have to exist, but if it does not, then
	*             it will be treated as a plain file (i.e. not a directory).
	* @param num_attr The number of attributes being looked up
	* @param names An array of num_attr strings containing attribute names.
	* @return 0 or an error code.
	*/
	git_attr_get_many :: proc(values_out: [^]cstring, repo: ^git_repository, flags: u32, path: cstring, num_attr: c.int, names: [^]cstring) -> c.int ---

	/**
	* Look up a list of git attributes for path with extended options.
	*
	* @param values_out An array of num_attr entries that will have string
	*             pointers written into it for the values of the attributes.
	*             You should not modify or free the values that are written
	*             into this array (although of course, you should free the
	*             array itself if you allocated it).
	* @param repo The repository containing the path.
	* @param opts The `git_attr_options` to use when querying these attributes.
	* @param path The path inside the repo to check attributes.  This
	*             does not have to exist, but if it does not, then
	*             it will be treated as a plain file (i.e. not a directory).
	* @param num_attr The number of attributes being looked up
	* @param names An array of num_attr strings containing attribute names.
	* @return 0 or an error code.
	*/
	git_attr_get_many_ext :: proc(values_out: [^]cstring, repo: ^git_repository, opts: ^git_attr_options, path: cstring, num_attr: c.int, names: [^]cstring) -> c.int ---

	/**
	* Loop over all the git attributes for a path.
	*
	* @param repo The repository containing the path.
	* @param flags A combination of GIT_ATTR_CHECK... flags.
	* @param path Path inside the repo to check attributes.  This does not have
	*             to exist, but if it does not, then it will be treated as a
	*             plain file (i.e. not a directory).
	* @param callback Function to invoke on each attribute name and value.
	*                 See git_attr_foreach_cb.
	* @param payload Passed on as extra parameter to callback function.
	* @return 0 on success, non-zero callback return value, or error code
	*/
	git_attr_foreach :: proc(repo: ^git_repository, flags: u32, path: cstring, callback: git_attr_foreach_cb, payload: rawptr) -> c.int ---

	/**
	* Loop over all the git attributes for a path with extended options.
	*
	* @param repo The repository containing the path.
	* @param opts The `git_attr_options` to use when querying these attributes.
	* @param path Path inside the repo to check attributes.  This does not have
	*             to exist, but if it does not, then it will be treated as a
	*             plain file (i.e. not a directory).
	* @param callback Function to invoke on each attribute name and value.
	*                 See git_attr_foreach_cb.
	* @param payload Passed on as extra parameter to callback function.
	* @return 0 on success, non-zero callback return value, or error code
	*/
	git_attr_foreach_ext :: proc(repo: ^git_repository, opts: ^git_attr_options, path: cstring, callback: git_attr_foreach_cb, payload: rawptr) -> c.int ---

	/**
	* Flush the gitattributes cache.
	*
	* Call this if you have reason to believe that the attributes files on
	* disk no longer match the cached contents of memory.  This will cause
	* the attributes files to be reloaded the next time that an attribute
	* access function is called.
	*
	* @param repo The repository containing the gitattributes cache
	* @return 0 on success, or an error code
	*/
	git_attr_cache_flush :: proc(repo: ^git_repository) -> c.int ---

	/**
	* Add a macro definition.
	*
	* Macros will automatically be loaded from the top level `.gitattributes`
	* file of the repository (plus the built-in "binary" macro).  This
	* function allows you to add others.  For example, to add the default
	* macro, you would call:
	*
	*     git_attr_add_macro(repo, "binary", "-diff -crlf");
	*
	* @param repo The repository to add the macro in.
	* @param name The name of the macro.
	* @param values The value for the macro.
	* @return 0 or an error code.
	*/
	git_attr_add_macro :: proc(repo: ^git_repository, name: cstring, values: cstring) -> c.int ---
}
