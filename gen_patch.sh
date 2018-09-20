#!/bin/bash

diff -u ./temp/src/google/protobuf/compiler/subprocess.cc ./patch/subprocess_patched.cc > subprocess.patch
