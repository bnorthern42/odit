#!/bin/bash
set -e
echo 'Building TestingSandbox...'
odin build . -out:sandbox_demo
./sandbox_demo