#!/bin/bash
set -x
# Iterate all the test-fail-*.hxml files and save its stderr output with a file of the same name but with stderr extension
for f in test-fail-*.hxml; do
    haxe $f 2> $f.stderr
done
exit 0
