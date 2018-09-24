#!/usr/bin/env bash

set -euo pipefail

CONJURE_TYPESCRIPT=build/conjure-typescript/bin/conjure-typescript
TEST_DIR=src/__integTest__/__generated__

# Clear directory before regenerating
if [ -e "$TEST_DIR/index.ts" ]; then
    rm -rf "$TEST_DIR/conjure-verification" "$TEST_DIR/index.ts"
fi

"$CONJURE_TYPESCRIPT" generate build/resources/verification-api.conjure.json "$TEST_DIR" --packageName generated --packageVersion 0.0.0

# Clean up package cruft
rm ${TEST_DIR}/*.json "$TEST_DIR/.npmignore"

REPLACE_STRING="s|conjure-client|../../../httpApiBridge|g"

# Replace replaces references to point to internal package
case $(uname -s) in
    Linux*) find src/__integTest__/__generated__/  -name "*.ts" -type f -exec sed -i "${REPLACE_STRING}" {} \;;;
    Darwin*) find src/__integTest__/__generated__/  -name "*.ts" -type f -exec sed -i "" "${REPLACE_STRING}" {} \;;
esac