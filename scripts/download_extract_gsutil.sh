#!/bin/bash

source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

# this script is meant to be used with 'datalad run'

files_url=(
	"https://storage.googleapis.com/pub/gsutil.tar.gz bin/gsutil.tar.gz")

git-annex addurl --fast -c annex.largefiles=anything --raw --batch --with-files <<EOF
$(for file_url in "${files_url[@]}" ; do echo "${file_url}" ; done)
EOF
git-annex get --fast -Jcpus
git-annex migrate --fast -c annex.largefiles=anything bin/gsutil.tar.gz

tar -C bin/ -xzf bin/gsutil.tar.gz
rm -rf bin/gsutil_build/
mv bin/gsutil/ bin/gsutil_build/

pushd bin/ >/dev/null
ln -sf gsutil_build/gsutil gsutil
popd >/dev/null
