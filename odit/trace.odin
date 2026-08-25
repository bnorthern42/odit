/*
* Copyright (C) the libgit2 contributors. All rights reserved.
*
* This file is part of libgit2, distributed under the GNU GPL v2 with
* a Linking Exception. For full terms see the included COPYING file.
*/
package odit

import "core:c"

_ :: c

when ODIN_OS == .Windows {
	foreign import lib {
		"git2.lib",
		"system:ws2_32",
		"system:crypt32",
		"system:rpcrt4",
		"system:ole32",
		"system:advapi32",
		"system:shell32",
		"system:user32",
	}
} else when ODIN_OS == .Darwin {
	foreign import lib {
		"../libs/build/libgit2.a",
		"system:z",
		"system:iconv",
		"system:Security",
		"system:CoreFoundation",
		"system:pthread",
	}
} else {
	foreign import lib {
		"../libs/build/libgit2.a",
		"system:z",
		"system:ssl",
		"system:crypto",
		"system:pthread",
	}
}




// INCLUDE_git_trace_h__ :: 

/**
* Available tracing levels.  When tracing is set to a particular level,
* callers will be provided tracing at the given level and all lower levels.
*/
git_trace_level_t :: enum c.uint {
	/** No tracing will be performed. */
	NONE,

	/** Severe errors that may impact the program's execution */
	FATAL,

	/** Errors that do not impact the program's execution */
	ERROR,

	/** Warnings that suggest abnormal data */
	WARN,

	/** Informational messages about program execution */
	INFO,

	/** Detailed data that allows for debugging */
	DEBUG,

	/** Exceptionally detailed debugging data */
	TRACE,
}

/**
* An instance for a tracing function
*
* @param level the trace level
* @param msg the trace message
*/
git_trace_cb :: proc "c" (git_trace_level_t, cstring)

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/**
	* Sets the system tracing configuration to the specified level with the
	* specified callback.  When system events occur at a level equal to, or
	* lower than, the given level they will be reported to the given callback.
	*
	* @param level Level to set tracing to
	* @param cb Function to call with trace data
	* @return 0 or an error code
	*/
	git_trace_set :: proc(level: git_trace_level_t, cb: git_trace_cb) -> c.int ---
}
