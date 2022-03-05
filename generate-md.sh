#!/bin/bash
set -e

for f in template/*; do 
    cp "$f" "$(basename $f).md"
done

# cp template/* .

for filename in *.md;
do
  if [[ "$filename" == 'README.md' ]]; then
    continue
  fi
  echo '```zig' >> $filename
  cat "code/$(basename $filename .md).zig" >> $filename
  echo '```' >> $filename
done

echo Done!