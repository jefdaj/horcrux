#!/usr/bin/env bash

cd "$(dirname "$0")"
./00-deps.sh &>/dev/null

horcrux -h
