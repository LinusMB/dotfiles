#!/usr/bin/env bash

cd "$(dirname "${0}")"

find . -type f ! -path '*/.git/*' ! -name "$(basename ${0})" ! -name '.gitconfig' -print0 |
    while IFS= read -r -d '' file; do
        src="$(pwd)/${file#*/}"
        target="${HOME}/${file#*/}"
        ln -sf "${src}" "${target}"
    done
