#!/bin/bash
set -o nounset
set -o errexit

echo "begin"

echo "clearing releases"

for rel in $(hub release) ; do
  echo "found release ${rel}"
  hub release delete ${rel}
done

echo "end"