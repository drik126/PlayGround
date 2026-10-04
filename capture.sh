#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
/usr/bin/time -p bash -c 'test -n "${CAPTURE_URL:-}" || { echo "CAPTURE_URL manquant" >&2; exit 1; }'
/usr/bin/time -p bash -c 'test -n "${CAPTURE_DIR:-}" || { echo "CAPTURE_DIR manquant" >&2; exit 1; }'
/usr/bin/time -p bash -c 'test -n "${RUNTIME_DIR:-}" || { echo "RUNTIME_DIR manquant" >&2; exit 1; }'
/usr/bin/time -p mkdir -p "$CAPTURE_DIR"
/usr/bin/time -p test -f "${RUNTIME_DIR}/scripts/default-capture.mjs"
CAPTURE_CODE=0
/usr/bin/time -p node "${RUNTIME_DIR}/scripts/default-capture.mjs" || CAPTURE_CODE=$?
/usr/bin/time -p bash -c 'echo "capture exit=$0 dir=$1 url=$2"' "$CAPTURE_CODE" "$CAPTURE_DIR" "$CAPTURE_URL"
if test "$CAPTURE_CODE" -ne 0; then
  exit "$CAPTURE_CODE"
fi
/usr/bin/time -p test -f "$CAPTURE_DIR/final-desktop.png"
/usr/bin/time -p test -f "$CAPTURE_DIR/final-mobile.png"
/usr/bin/time -p bash -c 'test ! -e "$0/final-desktop.png" || { echo "capture doit rester hors source" >&2; exit 1; }' "$(pwd)"
