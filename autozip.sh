#!/bin/bash

# Iterate over subdirectories
for subdir in */; do
  # Extract the subdirectory name
  dirname=$(basename "$subdir")

  # Zip the subdirectory into a unique .zip file
  zip -r "$dirname.zip" "$subdir"
done

