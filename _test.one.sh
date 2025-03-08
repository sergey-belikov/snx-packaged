#!/usr//bin/env bash
(
declare -i res
image="test/snx"
tag="bookworm-slim"
os="debian"
version="12"
dockerfile="test/${os}/Dockerfile.${version}.${tag}"

echo -e "\n==== ${image}:${tag} (${dockerfile})"
test -f ${dockerfile} && docker build --no-cache -t ${image}:${tag} -f ${dockerfile} .
res+=$?
echo "== Result: ${image}:${tag} (${os}.${version}) = ${res}"

docker images ${image}:${tag}

docker run --rm -it ${image}:${tag} /bin/bash -c '
  echo ""; echo "Hostname: $(hostname -f)"; ls -la /dist; \
  echo -e "==== Verify ===="; \
  cat /etc/os-release; \
  echo -e "\nWhich snx: $(which snx)"; \
  echo -e "\nList binaries: "; ls -la /usr/bin/snx* /usr/local/bin/snx* /etc/alternatives/snx; \
  echo -e "\nAlternatives: "; update-alternatives --display snx; \
  echo -e "\nUsage snx:"; snx -h
'
res+=$?

echo "Exit = ${res}"
exit ${res}
) 2>&1 | tee _test.one.log
res=${PIPESTATUS[0]}

echo ""
grep '==' _test.one.log
echo ""
docker images test/snx
docker image prune -f 2>&1 >/dev/null
echo "" && sleep 3
exit ${res}
