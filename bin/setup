#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

rm -f .binstubs/*
bundle install --binstubs .binstubs
bundle package --all --quiet
