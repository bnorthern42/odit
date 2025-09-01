/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_deprecated_h__ :: 

/** @name Deprecated Attribute Constants
 *
 * These enumeration values are retained for backward compatibility.
 * The newer versions of these functions should be preferred in all
 * new code.
 *
 * There is no plan to remove these backward compatibility values at
 * this time.
 */
/**@{*/

/** @deprecated use GIT_ATTR_VALUE_UNSPECIFIED */
GIT_ATTR_UNSPECIFIED_T :: GIT_ATTR_VALUE_UNSPECIFIED

/** @deprecated use GIT_ATTR_VALUE_TRUE */
GIT_ATTR_TRUE_T :: GIT_ATTR_VALUE_TRUE

/** @deprecated use GIT_ATTR_VALUE_FALSE */
GIT_ATTR_FALSE_T :: GIT_ATTR_VALUE_FALSE

/** @deprecated use GIT_ATTR_VALUE_STRING */
GIT_ATTR_VALUE_T :: GIT_ATTR_VALUE_STRING

/** @deprecated use git_attr_value_t */
git_attr_t :: git_attr_value_t

/**@}*/

/** @name Deprecated Blob Functions and Constants
 *
 * These functions and enumeration values are retained for backward
 * compatibility.  The newer versions of these functions and values
 * should be preferred in all new code.
 *
 * There is no plan to remove these backward compatibility values at
 * this time.
 */
/**@{*/

/** @deprecated use GIT_BLOB_FILTER_ATTRIBUTES_FROM_HEAD */
GIT_BLOB_FILTER_ATTTRIBUTES_FROM_HEAD :: GIT_BLOB_FILTER_ATTRIBUTES_FROM_HEAD

/**
* Provide a commit signature during commit creation.
*
* Callers should instead define a `git_commit_create_cb` that
* generates a commit buffer using `git_commit_create_buffer`, sign
* that buffer and call `git_commit_create_with_signature`.
*
* @deprecated use a `git_commit_create_cb` instead
*/
git_commit_signing_cb :: proc "c" (^git_buf, ^git_buf, cstring, rawptr) -> c.int

/**@}*/

/** @name Deprecated Config Functions and Constants
 */
/**@{*/

/** @deprecated use GIT_CONFIGMAP_FALSE */
GIT_CVAR_FALSE  :: GIT_CONFIGMAP_FALSE

/** @deprecated use GIT_CONFIGMAP_TRUE */
GIT_CVAR_TRUE   :: GIT_CONFIGMAP_TRUE

/** @deprecated use GIT_CONFIGMAP_INT32 */
GIT_CVAR_INT32  :: GIT_CONFIGMAP_INT32

/** @deprecated use GIT_CONFIGMAP_STRING */
GIT_CVAR_STRING :: GIT_CONFIGMAP_STRING

/** @deprecated use git_cvar_map */
git_cvar_map :: git_configmap

/**
* Formatting options for diff e-mail generation
*/
git_diff_format_email_flags_t :: enum c.uint {
	/** Normal patch, the default */
	NONE,

	/** Don't insert "[PATCH]" in the subject header*/
	EXCLUDE_SUBJECT_PATCH_MARKER,
}

/**
* Options for controlling the formatting of the generated e-mail.
*
* @deprecated use `git_email_create_options`
*/
git_diff_format_email_options :: struct {}

/** @deprecated use `git_email_create_options` */
GIT_DIFF_FORMAT_EMAIL_OPTIONS_VERSION :: 1

/** @deprecated use `git_email_create_options` */
GIT_DIFF_FORMAT_EMAIL_OPTIONS_INIT :: {GIT_DIFF_FORMAT_EMAIL_OPTIONS_VERSION, 0, 1, 1, NULL, NULL, NULL, NULL}

/**@}*/

/** @name Deprecated Error Functions and Constants
 *
 * These functions and enumeration values are retained for backward
 * compatibility.  The newer versions of these functions and values
 * should be preferred in all new code.
 *
 * There is no plan to remove these backward compatibility values at
 * this time.
 */
/**@{*/

/** @deprecated use `GIT_ERROR_NONE` */
GITERR_NONE :: GIT_ERROR_NONE

/** @deprecated use `GIT_ERROR_NOMEMORY` */
GITERR_NOMEMORY :: GIT_ERROR_NOMEMORY

/** @deprecated use `GIT_ERROR_OS` */
GITERR_OS :: GIT_ERROR_OS

/** @deprecated use `GIT_ERROR_INVALID` */
GITERR_INVALID :: GIT_ERROR_INVALID

/** @deprecated use `GIT_ERROR_REFERENCE` */
GITERR_REFERENCE :: GIT_ERROR_REFERENCE

/** @deprecated use `GIT_ERROR_ZLIB` */
GITERR_ZLIB :: GIT_ERROR_ZLIB

/** @deprecated use `GIT_ERROR_REPOSITORY` */
GITERR_REPOSITORY :: GIT_ERROR_REPOSITORY

/** @deprecated use `GIT_ERROR_CONFIG` */
GITERR_CONFIG :: GIT_ERROR_CONFIG

/** @deprecated use `GIT_ERROR_REGEX` */
GITERR_REGEX :: GIT_ERROR_REGEX

/** @deprecated use `GIT_ERROR_ODB` */
GITERR_ODB :: GIT_ERROR_ODB

/** @deprecated use `GIT_ERROR_INDEX` */
GITERR_INDEX :: GIT_ERROR_INDEX

/** @deprecated use `GIT_ERROR_OBJECT` */
GITERR_OBJECT :: GIT_ERROR_OBJECT

/** @deprecated use `GIT_ERROR_NET` */
GITERR_NET :: GIT_ERROR_NET

/** @deprecated use `GIT_ERROR_TAG` */
GITERR_TAG :: GIT_ERROR_TAG

/** @deprecated use `GIT_ERROR_TREE` */
GITERR_TREE :: GIT_ERROR_TREE

/** @deprecated use `GIT_ERROR_INDEXER` */
GITERR_INDEXER :: GIT_ERROR_INDEXER

/** @deprecated use `GIT_ERROR_SSL` */
GITERR_SSL :: GIT_ERROR_SSL

/** @deprecated use `GIT_ERROR_SUBMODULE` */
GITERR_SUBMODULE :: GIT_ERROR_SUBMODULE

/** @deprecated use `GIT_ERROR_THREAD` */
GITERR_THREAD :: GIT_ERROR_THREAD

/** @deprecated use `GIT_ERROR_STASH` */
GITERR_STASH :: GIT_ERROR_STASH

/** @deprecated use `GIT_ERROR_CHECKOUT` */
GITERR_CHECKOUT :: GIT_ERROR_CHECKOUT

/** @deprecated use `GIT_ERROR_FETCHHEAD` */
GITERR_FETCHHEAD :: GIT_ERROR_FETCHHEAD

/** @deprecated use `GIT_ERROR_MERGE` */
GITERR_MERGE :: GIT_ERROR_MERGE

/** @deprecated use `GIT_ERROR_SSH` */
GITERR_SSH :: GIT_ERROR_SSH

/** @deprecated use `GIT_ERROR_FILTER` */
GITERR_FILTER :: GIT_ERROR_FILTER

/** @deprecated use `GIT_ERROR_REVERT` */
GITERR_REVERT :: GIT_ERROR_REVERT

/** @deprecated use `GIT_ERROR_CALLBACK` */
GITERR_CALLBACK :: GIT_ERROR_CALLBACK

/** @deprecated use `GIT_ERROR_CHERRYPICK` */
GITERR_CHERRYPICK :: GIT_ERROR_CHERRYPICK

/** @deprecated use `GIT_ERROR_DESCRIBE` */
GITERR_DESCRIBE :: GIT_ERROR_DESCRIBE

/** @deprecated use `GIT_ERROR_REBASE` */
GITERR_REBASE :: GIT_ERROR_REBASE

/** @deprecated use `GIT_ERROR_FILESYSTEM` */
GITERR_FILESYSTEM :: GIT_ERROR_FILESYSTEM

/** @deprecated use `GIT_ERROR_PATCH` */
GITERR_PATCH :: GIT_ERROR_PATCH

/** @deprecated use `GIT_ERROR_WORKTREE` */
GITERR_WORKTREE :: GIT_ERROR_WORKTREE

/** @deprecated use `GIT_ERROR_SHA1` */
GITERR_SHA1 :: GIT_ERROR_SHA1

/** @deprecated use `GIT_ERROR_SHA` */
GIT_ERROR_SHA1 :: GIT_ERROR_SHA

/**@}*/

/** @name Deprecated Index Functions and Constants
 *
 * These functions and enumeration values are retained for backward
 * compatibility.  The newer versions of these values should be
 * preferred in all new code.
 *
 * There is no plan to remove these backward compatibility values at
 * this time.
 */
/**@{*/

/* The git_idxentry_extended_flag_t enum */
/** @deprecated use `GIT_INDEX_ENTRY_NAMEMASK` */
GIT_IDXENTRY_NAMEMASK          :: GIT_INDEX_ENTRY_NAMEMASK

/** @deprecated use `GIT_INDEX_ENTRY_STAGEMASK` */
GIT_IDXENTRY_STAGEMASK         :: GIT_INDEX_ENTRY_STAGEMASK

/** @deprecated use `GIT_INDEX_ENTRY_STAGESHIFT` */
GIT_IDXENTRY_STAGESHIFT        :: GIT_INDEX_ENTRY_STAGESHIFT

/* The git_indxentry_flag_t enum */
/** @deprecated use `GIT_INDEX_ENTRY_EXTENDED` */
GIT_IDXENTRY_EXTENDED          :: GIT_INDEX_ENTRY_EXTENDED

/** @deprecated use `GIT_INDEX_ENTRY_VALID` */
GIT_IDXENTRY_VALID             :: GIT_INDEX_ENTRY_VALID

/* The git_idxentry_extended_flag_t enum */
/** @deprecated use `GIT_INDEX_ENTRY_INTENT_TO_ADD` */
GIT_IDXENTRY_INTENT_TO_ADD     :: GIT_INDEX_ENTRY_INTENT_TO_ADD

/** @deprecated use `GIT_INDEX_ENTRY_SKIP_WORKTREE` */
GIT_IDXENTRY_SKIP_WORKTREE     :: GIT_INDEX_ENTRY_SKIP_WORKTREE

/** @deprecated use `GIT_INDEX_ENTRY_INTENT_TO_ADD | GIT_INDEX_ENTRY_SKIP_WORKTREE` */
GIT_IDXENTRY_EXTENDED_FLAGS    :: (GIT_INDEX_ENTRY_INTENT_TO_ADD|GIT_INDEX_ENTRY_SKIP_WORKTREE)

/** @deprecated this value is not public */
GIT_IDXENTRY_EXTENDED2         :: (1<<15)

/** @deprecated this value is not public */
GIT_IDXENTRY_UPDATE            :: (1<<0)

/** @deprecated this value is not public */
GIT_IDXENTRY_REMOVE            :: (1<<1)

/** @deprecated this value is not public */
GIT_IDXENTRY_UPTODATE          :: (1<<2)

/** @deprecated this value is not public */
GIT_IDXENTRY_ADDED             :: (1<<3)

/** @deprecated this value is not public */
GIT_IDXENTRY_HASHED            :: (1<<4)

/** @deprecated this value is not public */
GIT_IDXENTRY_UNHASHED          :: (1<<5)

/** @deprecated this value is not public */
GIT_IDXENTRY_WT_REMOVE         :: (1<<6)

/** @deprecated this value is not public */
GIT_IDXENTRY_CONFLICTED        :: (1<<7)

/** @deprecated this value is not public */
GIT_IDXENTRY_UNPACKED          :: (1<<8)

/** @deprecated this value is not public */
GIT_IDXENTRY_NEW_SKIP_WORKTREE :: (1<<9)

/* The git_index_capability_t enum */
/** @deprecated use `GIT_INDEX_CAPABILITY_IGNORE_CASE` */
GIT_INDEXCAP_IGNORE_CASE       :: GIT_INDEX_CAPABILITY_IGNORE_CASE

/** @deprecated use `GIT_INDEX_CAPABILITY_NO_FILEMODE` */
GIT_INDEXCAP_NO_FILEMODE       :: GIT_INDEX_CAPABILITY_NO_FILEMODE

/** @deprecated use `GIT_INDEX_CAPABILITY_NO_SYMLINKS` */
GIT_INDEXCAP_NO_SYMLINKS       :: GIT_INDEX_CAPABILITY_NO_SYMLINKS

/** @deprecated use `GIT_INDEX_CAPABILITY_FROM_OWNER` */
GIT_INDEXCAP_FROM_OWNER        :: GIT_INDEX_CAPABILITY_FROM_OWNER

/**@}*/

/** @name Deprecated Object Constants
 *
 * These enumeration values are retained for backward compatibility.  The
 * newer versions of these values should be preferred in all new code.
 *
 * There is no plan to remove these backward compatibility values at
 * this time.
 */
/**@{*/

/** @deprecate use `git_object_t` */
git_otype :: git_object_t

/** @deprecate use `GIT_OBJECT_ANY` */
GIT_OBJ_ANY :: GIT_OBJECT_ANY

/** @deprecate use `GIT_OBJECT_INVALID` */
GIT_OBJ_BAD :: GIT_OBJECT_INVALID

/** @deprecated this value is not public */
GIT_OBJ__EXT1 :: 0

/** @deprecate use `GIT_OBJECT_COMMIT` */
GIT_OBJ_COMMIT :: GIT_OBJECT_COMMIT

/** @deprecate use `GIT_OBJECT_TREE` */
GIT_OBJ_TREE :: GIT_OBJECT_TREE

/** @deprecate use `GIT_OBJECT_BLOB` */
GIT_OBJ_BLOB :: GIT_OBJECT_BLOB

/** @deprecate use `GIT_OBJECT_TAG` */
GIT_OBJ_TAG :: GIT_OBJECT_TAG

/** @deprecated this value is not public */
GIT_OBJ__EXT2 :: 5

/** @deprecate use `GIT_OBJECT_OFS_DELTA` */
GIT_OBJ_OFS_DELTA :: GIT_OBJECT_OFS_DELTA

/** @deprecate use `GIT_OBJECT_REF_DELTA` */
GIT_OBJ_REF_DELTA :: GIT_OBJECT_REF_DELTA

/**@}*/

/** @name Deprecated Reference Functions and Constants
 *
 * These functions and enumeration values are retained for backward
 * compatibility.  The newer versions of these values should be
 * preferred in all new code.
 *
 * There is no plan to remove these backward compatibility values at
 * this time.
 */
/**@{*/

 /** Basic type of any Git reference. */
/** @deprecate use `git_reference_t` */
git_ref_t :: git_reference_t

/** @deprecate use `git_reference_format_t` */
git_reference_normalize_t :: git_reference_format_t

/** @deprecate use `GIT_REFERENCE_INVALID` */
GIT_REF_INVALID :: GIT_REFERENCE_INVALID

/** @deprecate use `GIT_REFERENCE_DIRECT` */
GIT_REF_OID :: GIT_REFERENCE_DIRECT

/** @deprecate use `GIT_REFERENCE_SYMBOLIC` */
GIT_REF_SYMBOLIC :: GIT_REFERENCE_SYMBOLIC

/** @deprecate use `GIT_REFERENCE_ALL` */
GIT_REF_LISTALL :: GIT_REFERENCE_ALL

/** @deprecate use `GIT_REFERENCE_FORMAT_NORMAL` */
GIT_REF_FORMAT_NORMAL :: GIT_REFERENCE_FORMAT_NORMAL

/** @deprecate use `GIT_REFERENCE_FORMAT_ALLOW_ONELEVEL` */
GIT_REF_FORMAT_ALLOW_ONELEVEL :: GIT_REFERENCE_FORMAT_ALLOW_ONELEVEL

/** @deprecate use `GIT_REFERENCE_FORMAT_REFSPEC_PATTERN` */
GIT_REF_FORMAT_REFSPEC_PATTERN :: GIT_REFERENCE_FORMAT_REFSPEC_PATTERN

/** @deprecate use `GIT_REFERENCE_FORMAT_REFSPEC_SHORTHAND` */
GIT_REF_FORMAT_REFSPEC_SHORTHAND :: GIT_REFERENCE_FORMAT_REFSPEC_SHORTHAND

/**@}*/

/** @name Deprecated Repository Constants
 *
 * These enumeration values are retained for backward compatibility.
 */

/**
 * @deprecated This option is deprecated; it is now implied when
 * a separate working directory is specified to `git_repository_init`.
 */
GIT_REPOSITORY_INIT_NO_DOTGIT_DIR :: 0

/** @name Deprecated Revspec Constants
*
* These enumeration values are retained for backward compatibility.
* The newer versions of these values should be preferred in all new
* code.
*
* There is no plan to remove these backward compatibility values at
* this time.
*/
/**@{*/
git_revparse_mode_t :: git_revspec_t

/** @deprecated use `GIT_REVSPEC_SINGLE` */
GIT_REVPARSE_SINGLE :: GIT_REVSPEC_SINGLE

/** @deprecated use `GIT_REVSPEC_RANGE` */
GIT_REVPARSE_RANGE :: GIT_REVSPEC_RANGE

/** @deprecated use `GIT_REVSPEC_MERGE_BASE` */
GIT_REVPARSE_MERGE_BASE :: GIT_REVSPEC_MERGE_BASE

/** @name Deprecated Credential Types
*
* These types are retained for backward compatibility.  The newer
* versions of these values should be preferred in all new code.
*
* There is no plan to remove these backward compatibility values at
* this time.
*/
/**@{*/
git_cred :: git_credential

git_cred_userpass_plaintext :: git_credential_userpass_plaintext

git_cred_username :: git_credential_username

git_cred_default :: git_credential_default

git_cred_ssh_key :: git_credential_ssh_key

git_cred_ssh_interactive :: git_credential_ssh_interactive

git_cred_ssh_custom :: git_credential_ssh_custom

git_cred_acquire_cb :: git_credential_acquire_cb

git_cred_sign_callback :: git_credential_sign_cb

git_cred_sign_cb :: git_credential_sign_cb

git_cred_ssh_interactive_callback :: git_credential_ssh_interactive_cb

git_cred_ssh_interactive_cb :: git_credential_ssh_interactive_cb

/** @deprecated use `git_credential_t` */
git_credtype_t :: git_credential_t

/** @deprecated use `GIT_CREDENTIAL_USERPASS_PLAINTEXT` */
GIT_CREDTYPE_USERPASS_PLAINTEXT :: GIT_CREDENTIAL_USERPASS_PLAINTEXT

/** @deprecated use `GIT_CREDENTIAL_SSH_KEY` */
GIT_CREDTYPE_SSH_KEY :: GIT_CREDENTIAL_SSH_KEY

/** @deprecated use `GIT_CREDENTIAL_SSH_CUSTOM` */
GIT_CREDTYPE_SSH_CUSTOM :: GIT_CREDENTIAL_SSH_CUSTOM

/** @deprecated use `GIT_CREDENTIAL_DEFAULT` */
GIT_CREDTYPE_DEFAULT :: GIT_CREDENTIAL_DEFAULT

/** @deprecated use `GIT_CREDENTIAL_SSH_INTERACTIVE` */
GIT_CREDTYPE_SSH_INTERACTIVE :: GIT_CREDENTIAL_SSH_INTERACTIVE

/** @deprecated use `GIT_CREDENTIAL_USERNAME` */
GIT_CREDTYPE_USERNAME :: GIT_CREDENTIAL_USERNAME

/** @deprecated use `GIT_CREDENTIAL_SSH_MEMORY` */
GIT_CREDTYPE_SSH_MEMORY :: GIT_CREDENTIAL_SSH_MEMORY

/* Deprecated Credential Helper Types */
git_cred_userpass_payload :: git_credential_userpass_payload

/** @name Deprecated Trace Callback Types
*
* These types are retained for backward compatibility.  The newer
* versions of these values should be preferred in all new code.
*
* There is no plan to remove these backward compatibility values at
* this time.
*/
/**@{*/
git_trace_callback :: git_trace_cb

/** Deprecated OID "raw size" definition */
GIT_OID_RAWSZ    :: GIT_OID_SHA1_SIZE

/** Deprecated OID "hex size" definition */
GIT_OID_HEXSZ    :: GIT_OID_SHA1_HEXSIZE

/** Deprecated OID "hex zero" definition */
GIT_OID_HEX_ZERO :: GIT_OID_SHA1_HEXZERO

/**
* This structure is used to provide callers information about the
* progress of indexing a packfile.
*
* This type is deprecated, but there is no plan to remove this
* type definition at this time.
*/
git_transfer_progress :: git_indexer_progress

/**
* Type definition for progress callbacks during indexing.
*
* This type is deprecated, but there is no plan to remove this
* type definition at this time.
*/
git_transfer_progress_cb :: git_indexer_progress_cb

/**
* Type definition for push transfer progress callbacks.
*
* This type is deprecated, but there is no plan to remove this
* type definition at this time.
*/
git_push_transfer_progress :: git_push_transfer_progress_cb

/** The type of a remote completion event */
git_remote_completion_type :: git_remote_completion_t

/**
* Callback for listing the remote heads
*/
git_headlist_cb :: proc "c" (^git_remote_head, rawptr) -> c.int

/**@}*/

/** @name Deprecated Version Constants
 *
 * These constants are retained for backward compatibility.  The newer
 * versions of these constants should be preferred in all new code.
 *
 * There is no plan to remove these backward compatibility constants at
 * this time.
 */
/**@{*/
LIBGIT2_VER_MAJOR      :: LIBGIT2_VERSION_MAJOR
LIBGIT2_VER_MINOR      :: LIBGIT2_VERSION_MINOR
LIBGIT2_VER_REVISION   :: LIBGIT2_VERSION_REVISION
LIBGIT2_VER_PATCH      :: LIBGIT2_VERSION_PATCH
LIBGIT2_VER_PRERELEASE :: LIBGIT2_VERSION_PRERELEASE

@(default_calling_convention="c", link_prefix="")
foreign lib {
	git_blob_create_fromworkdir       :: proc(id: ^git_oid, repo: ^git_repository, relative_path: cstring) -> c.int ---
	git_blob_create_fromdisk          :: proc(id: ^git_oid, repo: ^git_repository, path: cstring) -> c.int ---
	git_blob_create_fromstream        :: proc(out: ^^git_writestream, repo: ^git_repository, hintpath: cstring) -> c.int ---
	git_blob_create_fromstream_commit :: proc(out: ^git_oid, stream: ^git_writestream) -> c.int ---
	git_blob_create_frombuffer        :: proc(id: ^git_oid, repo: ^git_repository, buffer: rawptr, len: c.int) -> c.int ---

	/** Deprecated in favor of `git_blob_filter`.
	*
	* @deprecated Use git_blob_filter
	* @see git_blob_filter
	*/
	git_blob_filtered_content :: proc(out: ^git_buf, blob: ^git_blob, as_path: cstring, check_for_binary_data: c.int) -> c.int ---

	/** Deprecated in favor of `git_filter_list_stream_buffer`.
	*
	* @deprecated Use git_filter_list_stream_buffer
	* @see Use git_filter_list_stream_buffer
	*/
	git_filter_list_stream_data :: proc(filters: ^git_filter_list, data: ^git_buf, target: ^git_writestream) -> c.int ---

	/** Deprecated in favor of `git_filter_list_apply_to_buffer`.
	*
	* @deprecated Use git_filter_list_apply_to_buffer
	* @see Use git_filter_list_apply_to_buffer
	*/
	git_filter_list_apply_to_data :: proc(out: ^git_buf, filters: ^git_filter_list, _in: ^git_buf) -> c.int ---

	/**
	* Write the contents of the tree builder as a tree object.
	* This is an alias of `git_treebuilder_write` and is preserved
	* for backward compatibility.
	*
	* This function is deprecated, but there is no plan to remove this
	* function at this time.
	*
	* @deprecated Use git_treebuilder_write
	* @see git_treebuilder_write
	*/
	git_treebuilder_write_with_buffer :: proc(oid: ^git_oid, bld: ^git_treebuilder, tree: ^git_buf) -> c.int ---

	/**
	* Resize the buffer allocation to make more space.
	*
	* This will attempt to grow the buffer to accommodate the target size.
	*
	* If the buffer refers to memory that was not allocated by libgit2 (i.e.
	* the `asize` field is zero), then `ptr` will be replaced with a newly
	* allocated block of data.  Be careful so that memory allocated by the
	* caller is not lost.  As a special variant, if you pass `target_size` as
	* 0 and the memory is not allocated by libgit2, this will allocate a new
	* buffer of size `size` and copy the external data into it.
	*
	* Currently, this will never shrink a buffer, only expand it.
	*
	* If the allocation fails, this will return an error and the buffer will be
	* marked as invalid for future operations, invaliding the contents.
	*
	* @param buffer The buffer to be resized; may or may not be allocated yet
	* @param target_size The desired available size
	* @return 0 on success, -1 on allocation failure
	*/
	git_buf_grow :: proc(buffer: ^git_buf, target_size: c.int) -> c.int ---

	/**
	* Set buffer to a copy of some raw data.
	*
	* @param buffer The buffer to set
	* @param data The data to copy into the buffer
	* @param datalen The length of the data to copy into the buffer
	* @return 0 on success, -1 on allocation failure
	*/
	git_buf_set :: proc(buffer: ^git_buf, data: rawptr, datalen: c.int) -> c.int ---

	/**
	* Check quickly if buffer looks like it contains binary data
	*
	* @param buf Buffer to check
	* @return 1 if buffer looks like non-text data
	*/
	git_buf_is_binary :: proc(buf: ^git_buf) -> c.int ---

	/**
	* Check quickly if buffer contains a NUL byte
	*
	* @param buf Buffer to check
	* @return 1 if buffer contains a NUL byte
	*/
	git_buf_contains_nul :: proc(buf: ^git_buf) -> c.int ---

	/**
	* Free the memory referred to by the git_buf.  This is an alias of
	* `git_buf_dispose` and is preserved for backward compatibility.
	*
	* This function is deprecated, but there is no plan to remove this
	* function at this time.
	*
	* @deprecated Use git_buf_dispose
	* @see git_buf_dispose
	*/
	git_buf_free :: proc(buffer: ^git_buf) ---

	/**
	* Create an e-mail ready patch from a diff.
	*
	* @deprecated git_email_create_from_diff
	* @see git_email_create_from_diff
	*/
	git_diff_format_email :: proc(out: ^git_buf, diff: ^git_diff, opts: ^git_diff_format_email_options) -> c.int ---

	/**
	* Create an e-mail ready patch for a commit.
	*
	* @deprecated git_email_create_from_commit
	* @see git_email_create_from_commit
	*/
	git_diff_commit_as_email :: proc(out: ^git_buf, repo: ^git_repository, commit: ^git_commit, patch_no: c.int, total_patches: c.int, flags: u32, diff_opts: ^git_diff_options) -> c.int ---

	/**
	* Initialize git_diff_format_email_options structure
	*
	* Initializes a `git_diff_format_email_options` with default values. Equivalent
	* to creating an instance with GIT_DIFF_FORMAT_EMAIL_OPTIONS_INIT.
	*
	* @param opts The `git_blame_options` struct to initialize.
	* @param version The struct version; pass `GIT_DIFF_FORMAT_EMAIL_OPTIONS_VERSION`.
	* @return Zero on success; -1 on failure.
	*/
	git_diff_format_email_options_init :: proc(opts: ^git_diff_format_email_options, version: c.uint) -> c.int ---

	/**
	* Return the last `git_error` object that was generated for the
	* current thread.  This is an alias of `git_error_last` and is
	* preserved for backward compatibility.
	*
	* This function is deprecated, but there is no plan to remove this
	* function at this time.
	*
	* @deprecated Use git_error_last
	* @see git_error_last
	*/
	giterr_last :: proc() -> ^git_error ---

	/**
	* Clear the last error.  This is an alias of `git_error_last` and is
	* preserved for backward compatibility.
	*
	* This function is deprecated, but there is no plan to remove this
	* function at this time.
	*
	* @deprecated Use git_error_clear
	* @see git_error_clear
	*/
	giterr_clear :: proc() ---

	/**
	* Sets the error message to the given string.  This is an alias of
	* `git_error_set_str` and is preserved for backward compatibility.
	*
	* This function is deprecated, but there is no plan to remove this
	* function at this time.
	*
	* @deprecated Use git_error_set_str
	* @see git_error_set_str
	*/
	giterr_set_str :: proc(error_class: c.int, _string: cstring) ---

	/**
	* Indicates that an out-of-memory situation occurred.  This is an alias
	* of `git_error_set_oom` and is preserved for backward compatibility.
	*
	* This function is deprecated, but there is no plan to remove this
	* function at this time.
	*
	* @deprecated Use git_error_set_oom
	* @see git_error_set_oom
	*/
	giterr_set_oom           :: proc() ---
	git_index_add_frombuffer :: proc(index: ^git_index, entry: ^git_index_entry, buffer: rawptr, len: c.int) -> c.int ---

	/**
	* Get the size in bytes for the structure which
	* acts as an in-memory representation of any given
	* object type.
	*
	* For all the core types, this would the equivalent
	* of calling `sizeof(git_commit)` if the core types
	* were not opaque on the external API.
	*
	* @param type object type to get its size
	* @return size in bytes of the object
	*/
	git_object__size :: proc(type: git_object_t) -> c.int ---

	/**
	* Determine if the given git_object_t is a valid object type.
	*
	* @deprecated use `git_object_type_is_valid`
	*
	* @param type object type to test.
	* @return 1 if the type represents a valid object type, 0 otherwise
	*/
	git_object_typeisloose :: proc(type: git_object_t) -> c.int ---

	/**
	* Ensure the remote name is well-formed.
	*
	* @deprecated Use git_remote_name_is_valid
	* @param remote_name name to be checked.
	* @return 1 if the reference name is acceptable; 0 if it isn't
	*/
	git_remote_is_valid_name :: proc(remote_name: cstring) -> c.int ---

	/**
	* Ensure the reference name is well-formed.
	*
	* Valid reference names must follow one of two patterns:
	*
	* 1. Top-level names must contain only capital letters and underscores,
	*    and must begin and end with a letter. (e.g. "HEAD", "ORIG_HEAD").
	* 2. Names prefixed with "refs/" can be almost anything.  You must avoid
	*    the characters '~', '^', ':', '\\', '?', '[', and '*', and the
	*    sequences ".." and "@{" which have special meaning to revparse.
	*
	* @deprecated Use git_reference_name_is_valid
	* @param refname name to be checked.
	* @return 1 if the reference name is acceptable; 0 if it isn't
	*/
	git_reference_is_valid_name     :: proc(refname: cstring) -> c.int ---
	git_tag_create_frombuffer       :: proc(oid: ^git_oid, repo: ^git_repository, buffer: cstring, force: c.int) -> c.int ---
	git_cred_free                   :: proc(cred: ^git_credential) ---
	git_cred_has_username           :: proc(cred: ^git_credential) -> c.int ---
	git_cred_get_username           :: proc(cred: ^git_credential) -> cstring ---
	git_cred_userpass_plaintext_new :: proc(out: ^^git_credential, username: cstring, password: cstring) -> c.int ---
	git_cred_default_new            :: proc(out: ^^git_credential) -> c.int ---
	git_cred_username_new           :: proc(out: ^^git_credential, username: cstring) -> c.int ---
	git_cred_ssh_key_new            :: proc(out: ^^git_credential, username: cstring, publickey: cstring, privatekey: cstring, passphrase: cstring) -> c.int ---
	git_cred_ssh_key_memory_new     :: proc(out: ^^git_credential, username: cstring, publickey: cstring, privatekey: cstring, passphrase: cstring) -> c.int ---
	git_cred_ssh_interactive_new    :: proc(out: ^^git_credential, username: cstring, prompt_callback: git_credential_ssh_interactive_cb, payload: rawptr) -> c.int ---
	git_cred_ssh_key_from_agent     :: proc(out: ^^git_credential, username: cstring) -> c.int ---
	git_cred_ssh_custom_new         :: proc(out: ^^git_credential, username: cstring, publickey: cstring, publickey_len: c.int, sign_callback: git_credential_sign_cb, payload: rawptr) -> c.int ---
	git_cred_userpass               :: proc(out: ^^git_credential, url: cstring, user_from_url: cstring, allowed_types: c.uint, payload: rawptr) -> c.int ---
	git_oid_iszero                  :: proc(id: ^git_oid) -> c.int ---

	/**
	* Free the memory referred to by the git_oidarray.  This is an alias of
	* `git_oidarray_dispose` and is preserved for backward compatibility.
	*
	* This function is deprecated, but there is no plan to remove this
	* function at this time.
	*
	* @deprecated Use git_oidarray_dispose
	* @see git_oidarray_dispose
	*/
	git_oidarray_free :: proc(array: ^git_oidarray) ---

	/**
	* Copy a string array object from source to target.
	*
	* This function is deprecated, but there is no plan to remove this
	* function at this time.
	*
	* @param tgt target
	* @param src source
	* @return 0 on success, < 0 on allocation failure
	*/
	git_strarray_copy :: proc(tgt: ^git_strarray, src: ^git_strarray) -> c.int ---

	/**
	* Free the memory referred to by the git_strarray.  This is an alias of
	* `git_strarray_dispose` and is preserved for backward compatibility.
	*
	* This function is deprecated, but there is no plan to remove this
	* function at this time.
	*
	* @deprecated Use git_strarray_dispose
	* @see git_strarray_dispose
	*/
	git_strarray_free :: proc(array: ^git_strarray) ---

	/** @name Deprecated Options Initialization Functions
	*
	* These functions are retained for backward compatibility.  The newer
	* versions of these functions should be preferred in all new code.
	*
	* There is no plan to remove these backward compatibility functions at
	* this time.
	*/
	/**@{*/
	git_blame_init_options             :: proc(opts: ^git_blame_options, version: c.uint) -> c.int ---
	git_checkout_init_options          :: proc(opts: ^git_checkout_options, version: c.uint) -> c.int ---
	git_cherrypick_init_options        :: proc(opts: ^git_cherrypick_options, version: c.uint) -> c.int ---
	git_clone_init_options             :: proc(opts: ^git_clone_options, version: c.uint) -> c.int ---
	git_describe_init_options          :: proc(opts: ^git_describe_options, version: c.uint) -> c.int ---
	git_describe_init_format_options   :: proc(opts: ^git_describe_format_options, version: c.uint) -> c.int ---
	git_diff_init_options              :: proc(opts: ^git_diff_options, version: c.uint) -> c.int ---
	git_diff_find_init_options         :: proc(opts: ^git_diff_find_options, version: c.uint) -> c.int ---
	git_diff_format_email_init_options :: proc(opts: ^git_diff_format_email_options, version: c.uint) -> c.int ---
	git_diff_patchid_init_options      :: proc(opts: ^git_diff_patchid_options, version: c.uint) -> c.int ---
	git_fetch_init_options             :: proc(opts: ^git_fetch_options, version: c.uint) -> c.int ---
	git_indexer_init_options           :: proc(opts: ^git_indexer_options, version: c.uint) -> c.int ---
	git_merge_init_options             :: proc(opts: ^git_merge_options, version: c.uint) -> c.int ---
	git_merge_file_init_input          :: proc(input: ^git_merge_file_input, version: c.uint) -> c.int ---
	git_merge_file_init_options        :: proc(opts: ^git_merge_file_options, version: c.uint) -> c.int ---
	git_proxy_init_options             :: proc(opts: ^git_proxy_options, version: c.uint) -> c.int ---
	git_push_init_options              :: proc(opts: ^git_push_options, version: c.uint) -> c.int ---
	git_rebase_init_options            :: proc(opts: ^git_rebase_options, version: c.uint) -> c.int ---
	git_remote_create_init_options     :: proc(opts: ^git_remote_create_options, version: c.uint) -> c.int ---
	git_repository_init_init_options   :: proc(opts: ^git_repository_init_options, version: c.uint) -> c.int ---
	git_revert_init_options            :: proc(opts: ^git_revert_options, version: c.uint) -> c.int ---
	git_stash_apply_init_options       :: proc(opts: ^git_stash_apply_options, version: c.uint) -> c.int ---
	git_status_init_options            :: proc(opts: ^git_status_options, version: c.uint) -> c.int ---
	git_submodule_update_init_options  :: proc(opts: ^git_submodule_update_options, version: c.uint) -> c.int ---
	git_worktree_add_init_options      :: proc(opts: ^git_worktree_add_options, version: c.uint) -> c.int ---
	git_worktree_prune_init_options    :: proc(opts: ^git_worktree_prune_options, version: c.uint) -> c.int ---
}
