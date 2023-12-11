#!/usr//bin/env bash
mkdir -m0755 dist

for pkg in "snx-800008209" "snx-800008304"
do
    echo -e "\n\n======== Build package: ${pkg} ========"
    pkg_dir=$(echo $pkg | awk -F- '{print $1"-"$2"-"$2}')
    cd ${pkg_dir}
    dpkg-buildpackage --no-sign --post-clean
    cd ..
    mv -f ${pkg}_* ./dist/
done

docker build -t snx:test -f Dockerfile.bookworm-slim .
docker images snx:test
# docker run --rm -it --entrypoint=/bin/bash snx:test
