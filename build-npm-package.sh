#!/usr/bin/env bash
set -euo pipefail

DOCKER_IMAGE="${1:-docker.io/library/apache:gc}"
WAR_PATH="/opt/guacamole/webapp/guacamole.war"
NPM_DIR="$(cd "$(dirname "$0")" && pwd)/guacamole-common-js-npm"
WORK_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$WORK_DIR"
}
trap cleanup EXIT

echo "==> Extracting WAR from $DOCKER_IMAGE"
cid=$(docker create "$DOCKER_IMAGE")
docker cp "$cid:$WAR_PATH" "$WORK_DIR/guacamole.war"
docker rm "$cid" >/dev/null

echo "==> Unzipping WAR"
unzip -q "$WORK_DIR/guacamole.war" -d "$WORK_DIR/webapp"

echo "==> Copying JS files"
mkdir -p "$NPM_DIR/dist"
cp "$WORK_DIR/webapp/guacamole-common-js/all.js"     "$NPM_DIR/dist/all.js"
cp "$WORK_DIR/webapp/guacamole-common-js/all.min.js" "$NPM_DIR/dist/all.min.js"

echo "==> Building npm package"
cd "$NPM_DIR"
npm pack

echo ""
echo "Done. Tarball: $NPM_DIR/$(ls *.tgz | tail -1)"
echo ""
echo "To publish: cd $NPM_DIR && npm publish"
