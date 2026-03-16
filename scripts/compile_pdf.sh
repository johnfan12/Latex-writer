#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
TECTONIC_BIN="${WORK_ROOT}/.local/bin/tectonic"

if [[ "${1:-}" == "--check" ]]; then
  if [[ -x "${TECTONIC_BIN}" ]]; then
    echo "OK: tectonic found at ${TECTONIC_BIN}"
    exit 0
  fi
  if command -v tectonic >/dev/null 2>&1; then
    echo "OK: tectonic found at $(command -v tectonic)"
    exit 0
  fi
  echo "ERROR: tectonic not found. Install it or place binary at ${TECTONIC_BIN}" >&2
  exit 1
fi

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <path/to/file.tex>" >&2
  echo "       $0 --check" >&2
  exit 1
fi

TEX_FILE="$1"
if [[ ! -f "${TEX_FILE}" ]]; then
  echo "ERROR: file not found: ${TEX_FILE}" >&2
  exit 1
fi

if [[ -x "${TECTONIC_BIN}" ]]; then
  COMPILER="${TECTONIC_BIN}"
elif command -v tectonic >/dev/null 2>&1; then
  COMPILER="$(command -v tectonic)"
else
  echo "ERROR: tectonic not found. Run '$0 --check' for details." >&2
  exit 1
fi

pushd "$(dirname "${TEX_FILE}")" >/dev/null
BASE="$(basename "${TEX_FILE}")"
echo "Compiling ${BASE} with ${COMPILER}"
"${COMPILER}" "${BASE}" || {
  echo "Build failed. Re-run with --keep-logs for deeper diagnostics if needed." >&2
  exit 1
}
echo "Done: $(pwd)/${BASE%.tex}.pdf"
popd >/dev/null
