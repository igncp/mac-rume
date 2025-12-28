#!/bin/bash

set -e

swift-format lint -r -s sources

alejandra flake.nix nix/*

statix check nix
statix check flake.nix

shfmt -w scripts

(cd rume && bash scripts/format-lint.sh)

# .gitmodules is an unrelated change
GIT_CHANGES="$(
    echo "$(git status --porcelain && cd rume && git status --porcelain)" |
        grep -v '\.gitmodules' || true
)"

if [ -n "$GIT_CHANGES" ]; then
    echo "Format or lint issues found. Please run scripts/format-lint.sh and commit the changes."
    echo "Changed files:"
    echo "$GIT_CHANGES"
    exit 1
fi

echo "MacRume: Format and lint checks passed."
