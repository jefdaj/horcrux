#!/usr/bin/env bash

cd "$(dirname "$0")"
./00-setup.sh &>/dev/null

horcrux -h
