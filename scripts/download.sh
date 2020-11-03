#!/bin/bash

source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

# This script is meant to be used with the command 'datalad run'

export PATH="${PATH}:bin"

! python3 -m pip install --no-cache-dir -U crcmod

datasets=(cater_with_masks
	clevr_with_masks
	multi_dsprites
	objects_room
	tetrominoes)

for d in "${datasets[@]}"
do
	gsutil -m -o "GSUtil:parallel_process_count=1" -o "GSUtil:parallel_thread_count=4" \
		cp -R "gs://multi-object-datasets/$d" ./
	git-annex add "$d"/
done

[[ -f md5sums ]] && md5sum -c md5sums
[[ -f md5sums ]] || md5sum $(list -- --fast) > md5sums
