# LaTeX Troubleshooting

## Common failures

1. Missing package or class
- Symptom: `File 'xxx.sty' not found`
- Fix: keep required style files in the same folder, or switch to a compiler that can fetch dependencies (e.g., tectonic with network access).

2. Bibliography not appearing
- Symptom: citation keys show as `?`
- Fix: ensure `.bib` exists, citation keys match, and rerun full compile.

3. Undefined control sequence
- Symptom: `Undefined control sequence`
- Fix: check spelling of macros and confirm package imports.

4. Font problems
- Symptom: Type-3 or missing fonts
- Fix: prefer modern toolchains and avoid legacy `latex + dvips` unless required by venue.

## Repeatable build command

Use from the manuscript directory:

```bash
/path/to/skills/latex-pdf-writer/scripts/compile_pdf.sh paper.tex
```
