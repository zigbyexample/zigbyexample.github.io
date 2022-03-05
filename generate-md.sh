#!/bin/bash
set -e

cp template/*.md .

for FILE in template/*.md;
do
  filename="$(basename $FILE .md)"
  echo '```zig' >> $filename.md
  cat "code/$filename.zig" >> $filename.md
  echo '```' >> $filename.md
done

echo Done!