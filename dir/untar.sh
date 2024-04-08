#! /bin/bash

# 1.
image="$1"
version="$2"
folder_filter="$3"

# 2.
work_dir=.
target_dir="$work_dir/output"


# 3.
cd "$work_dir"

mkdir -p "$target_dir"
docker image save $image -o tar2.tar
tar -xf tar2.tar -C $target_dir
for i in $target_dir/blobs/sha256/*; do
  type=$(file -b --mime-type "$i")
  echo $type
  if [[ $type == "application/x-tar" ]]; then
    echo $i
    tar -xf $i -C $target_dir  
  fi
done
