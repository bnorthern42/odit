package main

import "../odit"
import "core:fmt"
import "core:c"

when ODIN_OS == .Windows do foreign import foo "git2.lib"
when ODIN_OS == .Linux   do foreign import foo "git2.a"
//figure out macos, assume .a/.so ?


main :: proc() {
    count := odit.git_libgit2_init()
    fmt.printf("libgit2 initialized with count: %d\n", count)
    // Add more operations, e.g., open a repository
    odit.git_libgit2_shutdown()
}
/*
-------- Files gone through -------- 


-------- Files In Progress -------- 
 common -all link to this in C version, assume i have to do the same

-------- Files left -------- 
annotated_commit
apply
attr
blame
blob
branch
buffer
cert
checkout
cherrypick
clone
commit
common
config
credential_helpers
credential
cred_helpers
deprecated
describe
diff
email
errors
experimental
filter
git2
global
graph
ignore
indexer
index
mailmap
merge
message
net
notes
object
odb_backend
odb
oidarray
oid
pack
patch
pathspec
proxy
rebase
refdb
reflog
refs
refspec
remote
repository
reset
revert
revparse
revwalk
signature
stash
status
stdint
strarray
submodule
tag
trace
transaction
transport
tree
types
version
worktree
*/