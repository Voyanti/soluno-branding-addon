#!/bin/bash
# This script compresses all SVG files in the current directory and its first-level subdirectories.
# It creates two compressed files for each SVG: one using Brotli and one using gzip.

# Adjust -maxdepth if your folder structure is different.
find . -maxdepth 3 -type f -iname "*.svg" | while read -r svg; do
    echo "Processing: $svg"
    
    # Compress with Brotli, producing a file named filename.svg.br
    # The -f flag forces the overwrite if the file already exists.
    brotli -f "$svg"
    
    # Compress with gzip, keeping the original file (-k) and forcing overwrite (-f)
    gzip -kf "$svg"
    
    echo "Created: $svg.br and $svg.gz"
done