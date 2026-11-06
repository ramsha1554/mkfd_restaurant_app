#!/usr/bin/env bash
# Static overflow-risk scanner for Flutter UI code.
# Exit 1 if any finding. Output is grouped by rule so the agent can fix by category.
set -uo pipefail

ROOT="${1:-lib}"
if [ ! -d "$ROOT" ]; then
  echo "FAIL: directory '$ROOT' not found"
  exit 2
fi

FINDINGS=0
report() {
  local rule="$1" file="$2" line="$3" note="$4"
  echo "  [$rule] $file:$line — $note"
  FINDINGS=$((FINDINGS + 1))
}

scan() {
  local rule="$1" pattern="$2" note="$3"
  local hits
  hits=$(grep -rnE "$pattern" "$ROOT" --include='*.dart' \
    | grep -v '.g.dart' | grep -v '.freezed.dart' \
    | grep -v 'ui/core/theme/' || true)
  if [ -n "$hits" ]; then
    while IFS= read -r hit; do
      local file line
      file="${hit%%:*}"
      line="${hit#*:}"; line="${line%%:*}"
      report "$rule" "$file" "$line" "$note"
    done <<< "$hits"
  fi
}

echo "== verify-flutter-ui :: static layout guard =="
echo

echo "-- fixed heights that commonly clip text --"
scan "FIXED_HEIGHT" 'SizedBox\(\s*height:\s*[0-9]{1,3}\s*\)' \
  "fixed SizedBox height clips at text scale 2.0; use constraints/intrinsic height for text containers"

echo "-- fixed widths around text --"
scan "FIXED_WIDTH_TEXT" 'SizedBox\(\s*width:\s*[0-9]{2,4}\s*,\s*child:\s*Text\(' \
  "fixed width on Text causes clipping; wrap in Flexible/Expanded or use Wrap"

echo "-- Row with Text but no Flexible/Expanded on the same line --"
while IFS= read -r hit; do
  file="${hit%%:*}"; rest="${hit#*:}"; line="${rest%%:*}"
  ctx=$(sed -n "${line},$((line+12))p" "$file")
  if echo "$ctx" | grep -qE '\bText\(' && ! echo "$ctx" | grep -qE 'Flexible|Expanded'; then
    report "UNFLEXED_ROW_TEXT" "$file" "$line" "Row contains Text without Flexible/Expanded — overflows with long strings"
  fi
done < <(grep -rnE '\bRow\($|\bRow\(' "$ROOT" --include='*.dart' || true)

echo "-- fixed-height ListView items / Column in fixed height --"
scan "COLUMN_FIXED_PARENT" 'height:\s*[0-9]{3}\s*,\s*[^)]{0,40}Column\(' \
  "Column inside fixed height overflows when content grows"

echo "-- horizontal ListView/SingleChildScrollView with Column children --"
scan "HORIZONTAL_SCROLL_COLUMN" 'scrollDirection:\s*Axis\.horizontal' \
  "verify children have bounded width; unbounded width in horizontal scroll throws layout errors"

echo "-- raw magic numbers --"
scan "RAW_INSETS" 'EdgeInsets\.(all|symmetric|only|fromLTRB)\([^)]*\b(?!0\b)[0-9]' \
  "raw EdgeInsets literal — use AppSpacing (§5)"
scan "RAW_RADIUS" 'BorderRadius\.circular\(\s*[0-9]' \
  "raw BorderRadius literal — use AppRadius (§5)"
scan "RAW_FONTSIZE" 'fontSize:\s*[0-9]' \
  "raw fontSize — use AppTextStyles (§5)"

echo "-- images without size constraints --"
scan "UNCONSTRAINED_IMAGE" 'Image\.(asset|network)\(' \
  "confirm every Image has width/height/aspectRatio or sits in a constrained parent"

echo "-- keyboard-insensitive bottom padding --"
scan "KEYBOARD_PADDING" 'MediaQuery\.of\(context\)\.size\.height\s*\*\s*0' \
  "height fraction breaks with keyboard open; use viewInsets"

echo
if [ "$FINDINGS" -eq 0 ]; then
  echo "PASS: no static layout risks found"
  exit 0
fi
echo "FAIL: $FINDINGS finding(s) — fix before running the app, then rerun this script"
exit 1
