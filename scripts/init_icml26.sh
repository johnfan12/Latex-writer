#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <target-dir>" >&2
  exit 1
fi

TARGET_DIR="$1"
URL="https://media.icml.cc/Conferences/ICML2026/Styles/icml2026.zip"

mkdir -p "${TARGET_DIR}"
ZIP_PATH="${TARGET_DIR}/icml2026.zip"

curl -fL "${URL}" -o "${ZIP_PATH}"

if command -v unzip >/dev/null 2>&1; then
  unzip -o "${ZIP_PATH}" -d "${TARGET_DIR}" >/dev/null
elif command -v busybox >/dev/null 2>&1; then
  (cd "${TARGET_DIR}" && busybox unzip -o "icml2026.zip" >/dev/null)
else
  echo "ERROR: unzip tool not found (need unzip or busybox)." >&2
  exit 1
fi

echo "ICML 2026 template ready at ${TARGET_DIR}"
