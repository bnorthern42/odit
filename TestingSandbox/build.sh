#!/bin/bash
echo 'build this sandbox main file'

odin build . -extra-linker-flags:"-L./libs/build -l:git2.a -lz"