#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <target-dir>" >&2
  exit 1
fi

TARGET_DIR="$1"
URL="https://media.neurips.cc/Conferences/NeurIPS2025/Styles.zip"

mkdir -p "${TARGET_DIR}"
ZIP_PATH="${TARGET_DIR}/neurips2025_styles.zip"

curl -fL "${URL}" -o "${ZIP_PATH}"

if command -v unzip >/dev/null 2>&1; then
  unzip -o "${ZIP_PATH}" -d "${TARGET_DIR}" >/dev/null
elif command -v busybox >/dev/null 2>&1; then
  (cd "${TARGET_DIR}" && busybox unzip -o "$(basename "${ZIP_PATH}")" >/dev/null)
else
  echo "ERROR: unzip tool not found (need unzip or busybox)." >&2
  exit 1
fi

# NeurIPS archive extracts into Styles/; copy shell + style to target root.
if [[ -f "${TARGET_DIR}/Styles/neurips_2025.sty" ]]; then
  cp -f "${TARGET_DIR}/Styles/neurips_2025.sty" "${TARGET_DIR}/"
fi
if [[ -f "${TARGET_DIR}/Styles/neurips_2025.tex" ]]; then
  cp -f "${TARGET_DIR}/Styles/neurips_2025.tex" "${TARGET_DIR}/"
fi

if [[ ! -f "${TARGET_DIR}/neurips_2025.tex" ]]; then
  echo "ERROR: neurips_2025.tex not found after extraction." >&2
  exit 1
fi

# Build a convenient single-column entry by enabling preprint mode.
SINGLE_TEX="${TARGET_DIR}/nips25_single_column.tex"
cp -f "${TARGET_DIR}/neurips_2025.tex" "${SINGLE_TEX}"

# Comment default package line and enable preprint line.
awk '
  /^[[:space:]]*%?[[:space:]]*\\usepackage\{neurips_2025\}[[:space:]]*$/ {
    print "% \\usepackage{neurips_2025}";
    next;
  }
  /^[[:space:]]*%[[:space:]]*\\usepackage\[preprint\]\{neurips_2025\}[[:space:]]*$/ {
    print "\\usepackage[preprint]{neurips_2025}";
    next;
  }
  { print $0; }
' "${SINGLE_TEX}" > "${SINGLE_TEX}.tmp"
mv "${SINGLE_TEX}.tmp" "${SINGLE_TEX}"

echo "NeurIPS 2025 template ready at ${TARGET_DIR}"
echo "Single-column entry: ${SINGLE_TEX}"
