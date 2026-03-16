---
name: latex-pdf-writer
description: Write or revise LaTeX manuscripts and compile them to PDF with a reproducible local workflow. Use when tasks involve .tex authoring, ICML 2026 template setup, page-level PDF inspection (rendering one page to image or extracting one page text), bibliography builds, or debugging LaTeX compilation errors.
---

# Latex Pdf Writer

## Workflow

1. Confirm compiler availability.
Run `scripts/compile_pdf.sh --check` from the skill directory.

2. Choose a template.
For ICML template (double-column), run:
`scripts/init_icml26.sh <target-dir>`.
For NeurIPS 2025 single-column preprint template, run:
`scripts/init_nips25.sh <target-dir>`.
Then edit the generated `.tex` file for title, authors, abstract, and body.

3. Compile deterministically.
Run:
`scripts/compile_pdf.sh <tex-file>`
Example:
`scripts/compile_pdf.sh /path/to/example_paper.tex`

4. Debug failed builds.
Read the `.log` file path printed by the script.
Fix missing packages, undefined commands, bibliography issues, then re-run compile.

5. Inspect page layout and page text.
For visual inspection of page `k` (1-based):
`python3 scripts/pdf_page_image.py <pdf-file> <k> [output-png]`
For text-only models:
`python3 scripts/pdf_page_text.py <pdf-file> <k>`

## Conventions

- Prefer `tectonic` when available for reproducible local builds.
- Keep bibliography in `.bib` and ensure citations resolve.
- Make minimal edits to official conference style files (`*.sty`, `*.bst`).
- Use ICML when user asks for ICML-style double-column submission format.
- Use NIPS/NeurIPS single-column output by compiling `nips25_single_column.tex` created by `init_nips25.sh`.

## Resources

- `scripts/compile_pdf.sh`: check toolchain and compile a `.tex` file to PDF.
- `scripts/init_icml26.sh`: download and unpack official `icml2026.zip`.
- `scripts/init_nips25.sh`: download official `NeurIPS2025/Styles.zip` and create `nips25_single_column.tex`.
- `scripts/pdf_page_image.py`: render page `k` (1-based) to PNG image.
- `scripts/pdf_page_text.py`: extract all text from page `k` (1-based).
- `references/troubleshooting.md`: common LaTeX failure patterns and fixes.
