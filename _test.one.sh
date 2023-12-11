#!/usr//bin/env bash
image="test/snx"
tag="bookworm-slim"
os="debian"
version="12"
dockerfile="test/${os}/Dockerfile.${version}.${tag}"

echo -e "\n==== ${image}:${tag} (${dockerfile})"
test -f ${dockerfile} && \
docker build -t ${image} -f ${dockerfile} .
res=$?
echo "== Result: ${image}:${tag} (${os}.${version}) = ${res}"

docker images ${image}:${tag}

docker run --rm -it ${image}:${tag} /bin/bash -c echo ""; \
echo -e "==== Verify ===="; \
cat /etc/os-release; \
echo -e "\nWhich 'snx': $(which snx)"; \
echo -e "\nList binaries: "; ls -la /usr/bin/snx* /usr/local/bin/snx* /etc/alternatives/snx; \
echo -e "\nAlternatives: "; update-alternatives --display snx; \
echo -e "\nUsage:"; snx usage
