#!/bin/bash
set -e
odin build . -out:demo
./demo
rm -f demo
