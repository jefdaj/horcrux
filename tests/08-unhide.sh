#!/usr/bin/env bash

cd my-first-horcrux

# TODO include a test for picking up the hidden keys during decrypt

rm -f horcrux-01.key
horcrux unhide decrypt.key horcrux-01.jpeg horcrux-01.key
horcrux verify verify.key horcrux-01.key 
