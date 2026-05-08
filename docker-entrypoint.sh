#!/usr/bin/env sh
set -eu

if [ "$#" -eq 0 ]; then
    exec prepDyn --help
fi

case "$1" in
    prepDyn|GB2MSA|addSeq|UP2AP)
        tool="$1"
        shift
        exec "$tool" "$@"
        ;;
    -*)
        exec prepDyn "$@"
        ;;
    *)
        exec "$@"
        ;;
esac
