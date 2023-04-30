#!/bin/bash
# Ignores successful tests and only shows failed ones.
# This is useful when fixing test that fail on local,
# but in CI I want the full log, so don't uese this script.
set -x
# Iterate all the test-fail-*.hxml files and save its stderr output with a file of the same name but with stderr extension
haxe -D buddy-ignore-passing-specs tests.hxml
exit 0
