#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
PROJECT_ROOT="$(pwd)"
PORT="${PORT:-3000}"
DIST="$PROJECT_ROOT/dist"
/usr/bin/time -p mkdir -p "$DIST"
/usr/bin/time -p bash -c 'test -f index.html || { echo "index.html manquant" >&2; exit 1; }'
if /usr/bin/time -p test -f package.json; then
  /usr/bin/time -p npm install --no-audit --no-fund
  if /usr/bin/time -p bash -c 'node -e "const p=require(\"./package.json\");process.exit(p.scripts&&p.scripts.build?0:1)"'; then
    /usr/bin/time -p npm run build
  fi
else
  /usr/bin/time -p cp -f "$PROJECT_ROOT/index.html" "$DIST/index.html"
fi
/usr/bin/time -p test -f "$DIST/index.html"
if test -n "${OPENCODE_WEB_DIR:-}"; then
  /usr/bin/time -p mkdir -p "$OPENCODE_WEB_DIR"
  /usr/bin/time -p bash -c 'printf "{\"project\":%s,\"directory\":%s}" "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$0")" "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$1")" > "$2/deployment-output.json"' "$PROJECT_ROOT" "$DIST" "$OPENCODE_WEB_DIR"
fi
/usr/bin/time -p bash -c 'echo "Serving $0 on port $1 (dir $2)"' "$DIST" "$PORT" "$DIST"
/usr/bin/time -p python3 -m http.server "$PORT" --directory "$DIST"
