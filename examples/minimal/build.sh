#!/bin/bash
set -e
echo 'Building minimal example...'
odin build . -out:minimal_demo
./minimal_demo
rm -f minimal_demo