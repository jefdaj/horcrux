#!/usr/bin/env bash

cd my-first-horcrux
# TODO allow verifying multiple files
horcrux verify verify.key secret1.txt
horcrux verify verify.key secret1.txt.gpg
