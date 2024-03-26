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
for i in *; do
  if [[ -f $i/layer.tar ]]; then
    echo $i
    cd $i 
    tar -xf "layer.tar" 
    cd ..
  fi
done
