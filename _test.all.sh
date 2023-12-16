#!/usr/bin/env bash
old_dir="$(pwd)"
cdir="$(dirname $0)"
[[ "${cdir}" == "."  ]] && cdir="$(pwd)"
list=$(cat <<- EOF
#image	tag	os	version

test/snx	sid-slim	debian	NA
test/snx	testing-slim	debian	NA
test/snx	trixie-slim	debian	13
test/snx	bookworm-slim	debian	12
test/snx	bullseye-slim	debian	11
test/snx	buster-slim	debian	10

test/snx	noble	ubuntu	24.04
test/snx	mantic	ubuntu	23.10
test/snx	lunar	ubuntu	23.04
test/snx	jammy	ubuntu	22.04
test/snx	focal	ubuntu	20.04
test/snx	bionic	ubuntu	18.04
EOF
)
(grep -v '^[[:space:]]*$' <<< $list | while IFS=$'\t' read -r -a str
do
    [[ -z "${str}" || "${str:0:1}" == "#" ]] && continue
    image="${str[0]}"
    tag="${str[1]}"
    os="${str[2]}"
    version="${str[3]}"
    dockerfile="test/${os}/Dockerfile.${version}.${tag}"
    echo -e "\n==== ${image}:${tag} (${dockerfile})"
    echo "FROM ${os}:${tag}" > ${dockerfile}
    cat ${cdir}/test/Dockerfile.template >>${dockerfile}
    cd ${cdir}
    docker build -t ${image}:${tag} --build-arg BUILD_TIMESTAMP=$(date -uIs) -f ${cdir}/${dockerfile} .
    res=$?
    echo "== Result: ${image}:${tag} (${os}.${version}) = ${res}"
done <<< $list
) 2>&1 | tee _test.all.log
echo ""
grep '==' _test.all.log
echo ""
docker images test/snx
docker image prune -f 2>&1 >/dev/null
echo "" && sleep 5

cd "$old_dir"
