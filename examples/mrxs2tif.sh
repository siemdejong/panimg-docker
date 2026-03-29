#!/bin/bash
#SBATCH --job-name=panimg
#SBATCH --qos=low
#SBATCH --cpus-per-task=8
#SBATCH --mem=50G
#SBATCH --ntasks=1
#SBATCH --time=0-48:00:00
#SBATCH --container-image="ghcr.io#siemdejong/panimg-docker"
#SBATCH --container-mounts=/path/to/input/files/:/path/to/input/files/,/path/to/output/files/:/path/to/output/files/

set -euo pipefail

INPUT_DIR=/path/to/input/files
OUTPUT_DIR=/path/to/output/files

mkdir -p "$OUTPUT_DIR"

shopt -s nullglob

for mrxs in "$INPUT_DIR"/*.mrxs; do
    base=$(basename "$mrxs" .mrxs)
    sidecar_dir="$INPUT_DIR/$base"

    echo "Processing: $base"

    # Create isolated temp dirs
    tmp_in=$(mktemp -d)
    tmp_out=$(mktemp -d)

    # Copy the .mrxs file
    cp -a "$mrxs" "$tmp_in/"

    # Copy the associated folder (dat/ini/etc) if present
    if [[ -d "$sidecar_dir" ]]; then
        cp -a "$sidecar_dir" "$tmp_in/"
    else
        echo "WARNING: Sidecar directory not found for $base (expected: $sidecar_dir). Trying conversion anyway."
    fi
    
    ls $tmp_in

    # Convert (tmp_in contains only this slide bundle)


    panimg convert "$tmp_in" "$tmp_out"
    
    ls $tmp_out
    
    

    # panimg outputs a random-name .tif; grab the first tif created
    tif_file=$(find "$tmp_out" -maxdepth 2 -type f \( -iname "*.tif" -o -iname "*.tiff" \) | head -n 1)

    if [[ -z "${tif_file:-}" ]]; then
        echo "ERROR: No TIF produced for $base"
        rm -rf "$tmp_in" "$tmp_out"
        continue
    fi

    # Move/rename to original base name
    mv "$tif_file" "$OUTPUT_DIR/${base}.tif"

    # Cleanup
    rm -rf "$tmp_in" "$tmp_out"

    echo "Finished: $base"
done

echo "All MRXS files processed."
