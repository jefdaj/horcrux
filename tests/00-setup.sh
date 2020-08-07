#!/usr/bin/env bash

check_dep() {
  which $1 &>/dev/null && echo "$1 is installed" || (echo "ERROR! missing $1"; exit 1)
}

echo "checking for dependencies..."
check_dep python2
check_dep horcrux
check_dep steghide
check_dep ssss-split
