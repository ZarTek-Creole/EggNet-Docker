#!/bin/bash
set -e
echo "RUN AS $(id)"
for f in /startup-sequence/shell/*.sh; do
  (echo "Load sequence $f" && source "$f") || exit 1
done
exit 0
