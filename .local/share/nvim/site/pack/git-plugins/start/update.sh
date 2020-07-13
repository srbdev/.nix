#!/bin/bash

for f in *; do
  if [ -d "$f" ]; then
    echo "Updating $f:"
    cd $f
    git pull
    cd ..
  fi
done
