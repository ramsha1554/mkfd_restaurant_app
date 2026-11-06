#!/usr/bin/env bash
# Runtime overflow/layout error detector.
# Usage:
#   bash scripts/check_runtime.sh run     -> runs app, scans output for layout errors
#   bash scripts/check_runtime.sh log <file> -> scans an existing run log
#
# Exits 1 if a fatal layout/state error is found in debug output.
set -uo pipefail

PATTERNS='RenderFlex overflowed|RenderBox was not laid out|Unbounded height|Unbounded width|Vertical viewport was given unbounded height|Horizontal viewport was given unbounded width|setState\(\) called after dispose|A Timer is still pending|Incorrect use of ParentDataWidget|BoxConstraints forces an infinite'

scan_file() {
  local f="$1"
  [ -f "$f" ] || { echo "WARN: log file '$f' not found"; return 0; }
  local hits
  hits=$(grep -nE "$PATTERNS" "$f" || true)
  if [ -z "$hits" ]; then
    echo "PASS: no layout/state errors in $f"
    return 0
  fi
  echo "FAIL: layout/state errors in $f"
  echo "$hits" | head -40
  echo "(truncated to 40 lines)"
  return 1
}

mode="${1:-run}"

if [ "$mode" = "log" ]; then
  scan_file "${2:-}"
  exit $?
fi

LOG="$(mktemp -t flutter_ui_run.XXXXXX.log)"
echo "Running 'flutter run -d chrome' — interact with the app, then press q to stop."
echo "Log: $LOG"
flutter run -d chrome --web-port=5000 2>&1 | tee "$LOG"
echo
scan_file "$LOG"
status=$?
rm -f "$LOG"
exit $status
