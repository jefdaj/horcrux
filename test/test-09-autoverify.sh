#!/usr/bin/env bash

# note that we expect secret1.txt to fail verification because we deleted it
# TODO more descriptive error message for that?

horcrux autoverify my-first-horcrux
