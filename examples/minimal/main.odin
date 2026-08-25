package main

import "core:c"
import "core:fmt"
import "../../odit"

main :: proc() {
	count := odit.git_libgit2_init()
	fmt.printf("libgit2 initialized with count: %d\n", count)

	major, minor, rev: c.int
	odit.git_libgit2_version(&major, &minor, &rev)
	fmt.printf("libgit2 version: %d.%d.%d\n", major, minor, rev)

	odit.git_libgit2_shutdown()
}