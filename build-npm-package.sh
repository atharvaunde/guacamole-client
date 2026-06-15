#!/usr/bin/env bash
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
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
