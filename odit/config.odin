/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c



// INCLUDE_git_config_h__ :: 

/**
* Priority level of a config file.
*
* These priority levels correspond to the natural escalation logic
* (from higher to lower) when reading or searching for config entries
* in git.git. Meaning that for the same key, the configuration in
* the local configuration is preferred over the configuration in
* the system configuration file.
*
* Callers can add their own custom configuration, beginning at the
* `GIT_CONFIG_LEVEL_APP` level.
*
* Writes, by default, occur in the highest priority level backend
* that is writable. This ordering can be overridden with
* `git_config_set_writeorder`.
*
* git_config_open_default() and git_repository_config() honor those
* priority levels as well.
*
* @see git_config_open_default
* @see git_repository_config
*/
git_config_level_t :: enum c.int {
	/**
	* System-wide on Windows, for compatibility with "Portable Git".
	*/
	LEVEL_PROGRAMDATA = 1,

	/**
	* System-wide configuration file; `/etc/gitconfig` on Linux.
	*/
	LEVEL_SYSTEM = 2,

	/**
	* XDG compatible configuration file; typically
	* `~/.config/git/config`.
	*/
	LEVEL_XDG = 3,

	/**
	* Global configuration file is the user-specific configuration;
	* typically `~/.gitconfig`.
	*/
	LEVEL_GLOBAL = 4,

	/**
	* Local configuration, the repository-specific configuration file;
	* typically `$GIT_DIR/config`.
	*/
	LEVEL_LOCAL = 5,

	/**
	* Worktree-specific configuration; typically
	* `$GIT_DIR/config.worktree`.
	*/
	LEVEL_WORKTREE = 6,

	/**
	* Application-specific configuration file. Callers into libgit2
	* can add their own configuration beginning at this level.
	*/
	LEVEL_APP = 7,

	/**
	* Not a configuration level; callers can use this value when
	* querying configuration levels to specify that they want to
	* have data from the highest-level currently configuration.
	* This can be used to indicate that callers want the most
	* specific config file available that actually is loaded.
	*/
	HIGHEST_LEVEL = -1,
}

/**
* An entry in a configuration file
*/
git_config_entry :: struct {
	/** Name of the configuration entry (normalized). */
	name: cstring,

	/** Literal (string) value of the entry. */
	value: cstring,

	/** The type of backend that this entry exists in (eg, "file"). */
	backend_type: cstring,

	/**
	* The path to the origin of this entry. For config files, this is
	* the path to the file.
	*/
	origin_path: cstring,

	/** Depth of includes where this variable was found. */
	include_depth: c.uint,

	/** Configuration level for the file this was found in. */
	level: git_config_level_t,
}

/**
* A config enumeration callback.
*
* @param entry the entry currently being enumerated
* @param payload a user-specified pointer
* @return non-zero to terminate the iteration.
*/
git_config_foreach_cb :: proc "c" (^git_config_entry, rawptr) -> c.int

/**
* Config var type
*/
git_configmap_t :: enum c.uint {
	FALSE,
	TRUE,
	INT32,
	STRING,
}

/**
* Mapping from config variables to values.
*/
git_configmap :: struct {
	type:      git_configmap_t,
	str_match: cstring,
	map_value: c.int,
}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Free a config entry.
	*
	* @param entry The entry to free.
	*/
	git_config_entry_free :: proc(entry: ^git_config_entry) ---

	/**
	* Locate the path to the global configuration file
	*
	* The user or global configuration file is usually
	* located in `$HOME/.gitconfig`.
	*
	* This method will try to guess the full path to that
	* file, if the file exists. The returned path
	* may be used on any `git_config` call to load the
	* global configuration file.
	*
	* This method will not guess the path to the xdg compatible
	* config file (`.config/git/config`).
	*
	* @param out Pointer to a user-allocated git_buf in which to store the path
	* @return 0 if a global configuration file has been found. Its path will be stored in `out`.
	*/
	git_config_find_global :: proc(out: ^git_buf) -> c.int ---

	/**
	* Locate the path to the global xdg compatible configuration file
	*
	* The xdg compatible configuration file is usually
	* located in `$HOME/.config/git/config`.
	*
	* This method will try to guess the full path to that
	* file, if the file exists. The returned path
	* may be used on any `git_config` call to load the
	* xdg compatible configuration file.
	*
	* @param out Pointer to a user-allocated git_buf in which to store the path
	* @return 0 if a xdg compatible configuration file has been
	*	found. Its path will be stored in `out`.
	*/
	git_config_find_xdg :: proc(out: ^git_buf) -> c.int ---

	/**
	* Locate the path to the system configuration file
	*
	* If `/etc/gitconfig` doesn't exist, it will look for
	* `%PROGRAMFILES%\Git\etc\gitconfig`.
	*
	* @param out Pointer to a user-allocated git_buf in which to store the path
	* @return 0 if a system configuration file has been
	*	found. Its path will be stored in `out`.
	*/
	git_config_find_system :: proc(out: ^git_buf) -> c.int ---

	/**
	* Locate the path to the configuration file in ProgramData
	*
	* Look for the file in `%PROGRAMDATA%\Git\config` used by portable git.
	*
	* @param out Pointer to a user-allocated git_buf in which to store the path
	* @return 0 if a ProgramData configuration file has been
	*	found. Its path will be stored in `out`.
	*/
	git_config_find_programdata :: proc(out: ^git_buf) -> c.int ---

	/**
	* Open the global, XDG and system configuration files
	*
	* Utility wrapper that finds the global, XDG and system configuration files
	* and opens them into a single prioritized config object that can be
	* used when accessing default config data outside a repository.
	*
	* @param out Pointer to store the config instance
	* @return 0 or an error code
	*/
	git_config_open_default :: proc(out: ^^git_config) -> c.int ---

	/**
	* Allocate a new configuration object
	*
	* This object is empty, so you have to add a file to it before you
	* can do anything with it.
	*
	* @param out pointer to the new configuration
	* @return 0 or an error code
	*/
	git_config_new :: proc(out: ^^git_config) -> c.int ---

	/**
	* Add an on-disk config file instance to an existing config
	*
	* The on-disk file pointed at by `path` will be opened and
	* parsed; it's expected to be a native Git config file following
	* the default Git config syntax (see man git-config).
	*
	* If the file does not exist, the file will still be added and it
	* will be created the first time we write to it.
	*
	* Note that the configuration object will free the file
	* automatically.
	*
	* Further queries on this config object will access each
	* of the config file instances in order (instances with
	* a higher priority level will be accessed first).
	*
	* @param cfg the configuration to add the file to
	* @param path path to the configuration file to add
	* @param level the priority level of the backend
	* @param repo optional repository to allow parsing of
	*  conditional includes
	* @param force replace config file at the given priority level
	* @return 0 on success, GIT_EEXISTS when adding more than one file
	*  for a given priority level (and force_replace set to 0),
	*  GIT_ENOTFOUND when the file doesn't exist or error code
	*/
	git_config_add_file_ondisk :: proc(cfg: ^git_config, path: cstring, level: git_config_level_t, repo: ^git_repository, force: c.int) -> c.int ---

	/**
	* Create a new config instance containing a single on-disk file
	*
	* This method is a simple utility wrapper for the following sequence
	* of calls:
	*	- git_config_new
	*	- git_config_add_file_ondisk
	*
	* @param out The configuration instance to create
	* @param path Path to the on-disk file to open
	* @return 0 on success, or an error code
	*/
	git_config_open_ondisk :: proc(out: ^^git_config, path: cstring) -> c.int ---

	/**
	* Build a single-level focused config object from a multi-level one.
	*
	* The returned config object can be used to perform get/set/delete operations
	* on a single specific level.
	*
	* Getting several times the same level from the same parent multi-level config
	* will return different config instances, but containing the same config_file
	* instance.
	*
	* @param out The configuration instance to create
	* @param parent Multi-level config to search for the given level
	* @param level Configuration level to search for
	* @return 0, GIT_ENOTFOUND if the passed level cannot be found in the
	* multi-level parent config, or an error code
	*/
	git_config_open_level :: proc(out: ^^git_config, parent: ^git_config, level: git_config_level_t) -> c.int ---

	/**
	* Open the global/XDG configuration file according to git's rules
	*
	* Git allows you to store your global configuration at
	* `$HOME/.gitconfig` or `$XDG_CONFIG_HOME/git/config`. For backwards
	* compatibility, the XDG file shouldn't be used unless the use has
	* created it explicitly. With this function you'll open the correct
	* one to write to.
	*
	* @param out pointer in which to store the config object
	* @param config the config object in which to look
	* @return 0 or an error code.
	*/
	git_config_open_global :: proc(out: ^^git_config, config: ^git_config) -> c.int ---

	/**
	* Set the write order for configuration backends. By default, the
	* write ordering does not match the read ordering; for example, the
	* worktree configuration is a high-priority for reading, but is not
	* written to unless explicitly chosen.
	*
	* @param cfg the configuration to change write order of
	* @param levels the ordering of levels for writing
	* @param len the length of the levels array
	* @return 0 or an error code
	*/
	git_config_set_writeorder :: proc(cfg: ^git_config, levels: ^git_config_level_t, len: c.int) -> c.int ---

	/**
	* Create a snapshot of the configuration
	*
	* Create a snapshot of the current state of a configuration, which
	* allows you to look into a consistent view of the configuration for
	* looking up complex values (e.g. a remote, submodule).
	*
	* The string returned when querying such a config object is valid
	* until it is freed.
	*
	* @param out pointer in which to store the snapshot config object
	* @param config configuration to snapshot
	* @return 0 or an error code
	*/
	git_config_snapshot :: proc(out: ^^git_config, config: ^git_config) -> c.int ---

	/**
	* Free the configuration and its associated memory and files
	*
	* @param cfg the configuration to free
	*/
	git_config_free :: proc(cfg: ^git_config) ---

	/**
	* Get the git_config_entry of a config variable.
	*
	* Free the git_config_entry after use with `git_config_entry_free()`.
	*
	* @param out pointer to the variable git_config_entry
	* @param cfg where to look for the variable
	* @param name the variable's name
	* @return 0 or an error code
	*/
	git_config_get_entry :: proc(out: ^^git_config_entry, cfg: ^git_config, name: cstring) -> c.int ---

	/**
	* Get the value of an integer config variable.
	*
	* All config files will be looked into, in the order of their
	* defined level. A higher level means a higher priority. The
	* first occurrence of the variable will be returned here.
	*
	* @param out pointer to the variable where the value should be stored
	* @param cfg where to look for the variable
	* @param name the variable's name
	* @return 0 or an error code
	*/
	git_config_get_int32 :: proc(out: ^i32, cfg: ^git_config, name: cstring) -> c.int ---

	/**
	* Get the value of a long integer config variable.
	*
	* All config files will be looked into, in the order of their
	* defined level. A higher level means a higher priority. The
	* first occurrence of the variable will be returned here.
	*
	* @param out pointer to the variable where the value should be stored
	* @param cfg where to look for the variable
	* @param name the variable's name
	* @return 0 or an error code
	*/
	git_config_get_int64 :: proc(out: ^i64, cfg: ^git_config, name: cstring) -> c.int ---

	/**
	* Get the value of a boolean config variable.
	*
	* This function uses the usual C convention of 0 being false and
	* anything else true.
	*
	* All config files will be looked into, in the order of their
	* defined level. A higher level means a higher priority. The
	* first occurrence of the variable will be returned here.
	*
	* @param out pointer to the variable where the value should be stored
	* @param cfg where to look for the variable
	* @param name the variable's name
	* @return 0 or an error code
	*/
	git_config_get_bool :: proc(out: ^c.int, cfg: ^git_config, name: cstring) -> c.int ---

	/**
	* Get the value of a path config variable.
	*
	* A leading '~' will be expanded to the global search path (which
	* defaults to the user's home directory but can be overridden via
	* `git_libgit2_opts()`.
	*
	* All config files will be looked into, in the order of their
	* defined level. A higher level means a higher priority. The
	* first occurrence of the variable will be returned here.
	*
	* @param out the buffer in which to store the result
	* @param cfg where to look for the variable
	* @param name the variable's name
	* @return 0 or an error code
	*/
	git_config_get_path :: proc(out: ^git_buf, cfg: ^git_config, name: cstring) -> c.int ---

	/**
	* Get the value of a string config variable.
	*
	* This function can only be used on snapshot config objects. The
	* string is owned by the config and should not be freed by the
	* user. The pointer will be valid until the config is freed.
	*
	* All config files will be looked into, in the order of their
	* defined level. A higher level means a higher priority. The
	* first occurrence of the variable will be returned here.
	*
	* @param out pointer to the string
	* @param cfg where to look for the variable
	* @param name the variable's name
	* @return 0 or an error code
	*/
	git_config_get_string :: proc(out: [^]cstring, cfg: ^git_config, name: cstring) -> c.int ---

	/**
	* Get the value of a string config variable.
	*
	* The value of the config will be copied into the buffer.
	*
	* All config files will be looked into, in the order of their
	* defined level. A higher level means a higher priority. The
	* first occurrence of the variable will be returned here.
	*
	* @param out buffer in which to store the string
	* @param cfg where to look for the variable
	* @param name the variable's name
	* @return 0 or an error code
	*/
	git_config_get_string_buf :: proc(out: ^git_buf, cfg: ^git_config, name: cstring) -> c.int ---

	/**
	* Get each value of a multivar in a foreach callback
	*
	* The callback will be called on each variable found
	*
	* The regular expression is applied case-sensitively on the normalized form of
	* the variable name: the section and variable parts are lower-cased. The
	* subsection is left unchanged.
	*
	* @param cfg where to look for the variable
	* @param name the variable's name
	* @param regexp regular expression to filter which variables we're
	* interested in. Use NULL to indicate all
	* @param callback the function to be called on each value of the variable
	* @param payload opaque pointer to pass to the callback
	* @return 0 or an error code.
	*/
	git_config_get_multivar_foreach :: proc(cfg: ^git_config, name: cstring, regexp: cstring, callback: git_config_foreach_cb, payload: rawptr) -> c.int ---

	/**
	* Get each value of a multivar
	*
	* The regular expression is applied case-sensitively on the normalized form of
	* the variable name: the section and variable parts are lower-cased. The
	* subsection is left unchanged.
	*
	* @param out pointer to store the iterator
	* @param cfg where to look for the variable
	* @param name the variable's name
	* @param regexp regular expression to filter which variables we're
	* interested in. Use NULL to indicate all
	* @return 0 or an error code.
	*/
	git_config_multivar_iterator_new :: proc(out: ^^git_config_iterator, cfg: ^git_config, name: cstring, regexp: cstring) -> c.int ---

	/**
	* Return the current entry and advance the iterator
	*
	* The pointers returned by this function are valid until the next call
	* to `git_config_next` or until the iterator is freed.
	*
	* @param entry pointer to store the entry
	* @param iter the iterator
	* @return 0 or an error code. GIT_ITEROVER if the iteration has completed
	*/
	git_config_next :: proc(entry: ^^git_config_entry, iter: ^git_config_iterator) -> c.int ---

	/**
	* Free a config iterator
	*
	* @param iter the iterator to free
	*/
	git_config_iterator_free :: proc(iter: ^git_config_iterator) ---

	/**
	* Set the value of an integer config variable in the config file
	* with the highest level (usually the local one).
	*
	* @param cfg where to look for the variable
	* @param name the variable's name
	* @param value Integer value for the variable
	* @return 0 or an error code
	*/
	git_config_set_int32 :: proc(cfg: ^git_config, name: cstring, value: i32) -> c.int ---

	/**
	* Set the value of a long integer config variable in the config file
	* with the highest level (usually the local one).
	*
	* @param cfg where to look for the variable
	* @param name the variable's name
	* @param value Long integer value for the variable
	* @return 0 or an error code
	*/
	git_config_set_int64 :: proc(cfg: ^git_config, name: cstring, value: i64) -> c.int ---

	/**
	* Set the value of a boolean config variable in the config file
	* with the highest level (usually the local one).
	*
	* @param cfg where to look for the variable
	* @param name the variable's name
	* @param value the value to store
	* @return 0 or an error code
	*/
	git_config_set_bool :: proc(cfg: ^git_config, name: cstring, value: c.int) -> c.int ---

	/**
	* Set the value of a string config variable in the config file
	* with the highest level (usually the local one).
	*
	* A copy of the string is made and the user is free to use it
	* afterwards.
	*
	* @param cfg where to look for the variable
	* @param name the variable's name
	* @param value the string to store.
	* @return 0 or an error code
	*/
	git_config_set_string :: proc(cfg: ^git_config, name: cstring, value: cstring) -> c.int ---

	/**
	* Set a multivar in the local config file.
	*
	* The regular expression is applied case-sensitively on the value.
	*
	* @param cfg where to look for the variable
	* @param name the variable's name
	* @param regexp a regular expression to indicate which values to replace
	* @param value the new value.
	* @return 0 or an error code.
	*/
	git_config_set_multivar :: proc(cfg: ^git_config, name: cstring, regexp: cstring, value: cstring) -> c.int ---

	/**
	* Delete a config variable from the config file
	* with the highest level (usually the local one).
	*
	* @param cfg the configuration
	* @param name the variable to delete
	* @return 0 or an error code.
	*/
	git_config_delete_entry :: proc(cfg: ^git_config, name: cstring) -> c.int ---

	/**
	* Deletes one or several entries from a multivar in the local config file.
	*
	* The regular expression is applied case-sensitively on the value.
	*
	* @param cfg where to look for the variables
	* @param name the variable's name
	* @param regexp a regular expression to indicate which values to delete
	*
	* @return 0 or an error code
	*/
	git_config_delete_multivar :: proc(cfg: ^git_config, name: cstring, regexp: cstring) -> c.int ---

	/**
	* Perform an operation on each config variable.
	*
	* The callback receives the normalized name and value of each variable
	* in the config backend, and the data pointer passed to this function.
	* If the callback returns a non-zero value, the function stops iterating
	* and returns that value to the caller.
	*
	* The pointers passed to the callback are only valid as long as the
	* iteration is ongoing.
	*
	* @param cfg where to get the variables from
	* @param callback the function to call on each variable
	* @param payload the data to pass to the callback
	* @return 0 on success, non-zero callback return value, or error code
	*/
	git_config_foreach :: proc(cfg: ^git_config, callback: git_config_foreach_cb, payload: rawptr) -> c.int ---

	/**
	* Iterate over all the config variables
	*
	* Use `git_config_next` to advance the iteration and
	* `git_config_iterator_free` when done.
	*
	* @param out pointer to store the iterator
	* @param cfg where to get the variables from
	* @return 0 or an error code.
	*/
	git_config_iterator_new :: proc(out: ^^git_config_iterator, cfg: ^git_config) -> c.int ---

	/**
	* Iterate over all the config variables whose name matches a pattern
	*
	* Use `git_config_next` to advance the iteration and
	* `git_config_iterator_free` when done.
	*
	* The regular expression is applied case-sensitively on the normalized form of
	* the variable name: the section and variable parts are lower-cased. The
	* subsection is left unchanged.
	*
	* @param out pointer to store the iterator
	* @param cfg where to ge the variables from
	* @param regexp regular expression to match the names
	* @return 0 or an error code.
	*/
	git_config_iterator_glob_new :: proc(out: ^^git_config_iterator, cfg: ^git_config, regexp: cstring) -> c.int ---

	/**
	* Perform an operation on each config variable matching a regular expression.
	*
	* This behaves like `git_config_foreach` with an additional filter of a
	* regular expression that filters which config keys are passed to the
	* callback.
	*
	* The regular expression is applied case-sensitively on the normalized form of
	* the variable name: the section and variable parts are lower-cased. The
	* subsection is left unchanged.
	*
	* The regular expression is applied case-sensitively on the normalized form of
	* the variable name: the case-insensitive parts are lower-case.
	*
	* @param cfg where to get the variables from
	* @param regexp regular expression to match against config names
	* @param callback the function to call on each variable
	* @param payload the data to pass to the callback
	* @return 0 or the return value of the callback which didn't return 0
	*/
	git_config_foreach_match :: proc(cfg: ^git_config, regexp: cstring, callback: git_config_foreach_cb, payload: rawptr) -> c.int ---

	/**
	* Query the value of a config variable and return it mapped to
	* an integer constant.
	*
	* This is a helper method to easily map different possible values
	* to a variable to integer constants that easily identify them.
	*
	* A mapping array looks as follows:
	*
	*	git_configmap autocrlf_mapping[] = {
	*		{GIT_CVAR_FALSE, NULL, GIT_AUTO_CRLF_FALSE},
	*		{GIT_CVAR_TRUE, NULL, GIT_AUTO_CRLF_TRUE},
	*		{GIT_CVAR_STRING, "input", GIT_AUTO_CRLF_INPUT},
	*		{GIT_CVAR_STRING, "default", GIT_AUTO_CRLF_DEFAULT}};
	*
	* On any "false" value for the variable (e.g. "false", "FALSE", "no"), the
	* mapping will store `GIT_AUTO_CRLF_FALSE` in the `out` parameter.
	*
	* The same thing applies for any "true" value such as "true", "yes" or "1", storing
	* the `GIT_AUTO_CRLF_TRUE` variable.
	*
	* Otherwise, if the value matches the string "input" (with case insensitive comparison),
	* the given constant will be stored in `out`, and likewise for "default".
	*
	* If not a single match can be made to store in `out`, an error code will be
	* returned.
	*
	* @param out place to store the result of the mapping
	* @param cfg config file to get the variables from
	* @param name name of the config variable to lookup
	* @param maps array of `git_configmap` objects specifying the possible mappings
	* @param map_n number of mapping objects in `maps`
	* @return 0 on success, error code otherwise
	*/
	git_config_get_mapped :: proc(out: ^c.int, cfg: ^git_config, name: cstring, maps: ^git_configmap, map_n: c.int) -> c.int ---

	/**
	* Maps a string value to an integer constant
	*
	* @param out place to store the result of the parsing
	* @param maps array of `git_configmap` objects specifying the possible mappings
	* @param map_n number of mapping objects in `maps`
	* @param value value to parse
	* @return 0 or an error code.
	*/
	git_config_lookup_map_value :: proc(out: ^c.int, maps: ^git_configmap, map_n: c.int, value: cstring) -> c.int ---

	/**
	* Parse a string value as a bool.
	*
	* Valid values for true are: 'true', 'yes', 'on', 1 or any
	*  number different from 0
	* Valid values for false are: 'false', 'no', 'off', 0
	*
	* @param out place to store the result of the parsing
	* @param value value to parse
	* @return 0 or an error code.
	*/
	git_config_parse_bool :: proc(out: ^c.int, value: cstring) -> c.int ---

	/**
	* Parse a string value as an int32.
	*
	* An optional value suffix of 'k', 'm', or 'g' will
	* cause the value to be multiplied by 1024, 1048576,
	* or 1073741824 prior to output.
	*
	* @param out place to store the result of the parsing
	* @param value value to parse
	* @return 0 or an error code.
	*/
	git_config_parse_int32 :: proc(out: ^i32, value: cstring) -> c.int ---

	/**
	* Parse a string value as an int64.
	*
	* An optional value suffix of 'k', 'm', or 'g' will
	* cause the value to be multiplied by 1024, 1048576,
	* or 1073741824 prior to output.
	*
	* @param out place to store the result of the parsing
	* @param value value to parse
	* @return 0 or an error code.
	*/
	git_config_parse_int64 :: proc(out: ^i64, value: cstring) -> c.int ---

	/**
	* Parse a string value as a path.
	*
	* A leading '~' will be expanded to the global search path (which
	* defaults to the user's home directory but can be overridden via
	* `git_libgit2_opts()`.
	*
	* If the value does not begin with a tilde, the input will be
	* returned.
	*
	* @param out placae to store the result of parsing
	* @param value the path to evaluate
	* @return 0 or an error code.
	*/
	git_config_parse_path :: proc(out: ^git_buf, value: cstring) -> c.int ---

	/**
	* Perform an operation on each config variable in a given config backend,
	* matching a regular expression.
	*
	* This behaves like `git_config_foreach_match` except that only config
	* entries from the given backend entry are enumerated.
	*
	* The regular expression is applied case-sensitively on the normalized form of
	* the variable name: the section and variable parts are lower-cased. The
	* subsection is left unchanged.
	*
	* @param backend where to get the variables from
	* @param regexp regular expression to match against config names (can be NULL)
	* @param callback the function to call on each variable
	* @param payload the data to pass to the callback
	* @return 0 or an error code.
	*/
	git_config_backend_foreach_match :: proc(backend: ^git_config_backend, regexp: cstring, callback: git_config_foreach_cb, payload: rawptr) -> c.int ---

	/**
	* Lock the backend with the highest priority
	*
	* Locking disallows anybody else from writing to that backend. Any
	* updates made after locking will not be visible to a reader until
	* the file is unlocked.
	*
	* You can apply the changes by calling `git_transaction_commit()`
	* before freeing the transaction. Either of these actions will unlock
	* the config.
	*
	* @param tx the resulting transaction, use this to commit or undo the
	* changes
	* @param cfg the configuration in which to lock
	* @return 0 or an error code
	*/
	git_config_lock :: proc(tx: ^^git_transaction, cfg: ^git_config) -> c.int ---
}
