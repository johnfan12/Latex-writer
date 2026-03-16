#!/usr/bin/env python3
import argparse
import os
import sys

try:
    import pypdfium2 as pdfium
except Exception as exc:
    print(
        "ERROR: pypdfium2 is required. Install with: python3 -m pip install --user pypdfium2",
        file=sys.stderr,
    )
    print(f"Details: {exc}", file=sys.stderr)
    sys.exit(1)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Render page k (1-based) from PDF to a PNG image."
    )
    parser.add_argument("pdf_file", help="Path to the input PDF file")
    parser.add_argument("page_k", type=int, help="1-based page index")
    parser.add_argument(
        "output_png",
        nargs="?",
        help="Output PNG path (default: <pdf-dir>/<pdf-stem>.page-<k>.png)",
    )
    parser.add_argument(
        "--scale",
        type=float,
        default=2.0,
        help="Render scale factor (default: 2.0)",
    )
    args = parser.parse_args()

    if args.page_k < 1:
        print("ERROR: page_k must be >= 1", file=sys.stderr)
        return 1
    if args.scale <= 0:
        print("ERROR: --scale must be > 0", file=sys.stderr)
        return 1
    if not os.path.isfile(args.pdf_file):
        print(f"ERROR: PDF not found: {args.pdf_file}", file=sys.stderr)
        return 1

    try:
        pdf = pdfium.PdfDocument(args.pdf_file)
    except Exception as exc:
        print(f"ERROR: failed to open PDF: {exc}", file=sys.stderr)
        return 1

    page_count = len(pdf)
    if args.page_k > page_count:
        print(
            f"ERROR: page_k={args.page_k} out of range. PDF has {page_count} pages.",
            file=sys.stderr,
        )
        return 1

    if args.output_png:
        output = args.output_png
    else:
        abs_pdf = os.path.abspath(args.pdf_file)
        pdf_dir = os.path.dirname(abs_pdf)
        stem = os.path.splitext(os.path.basename(abs_pdf))[0]
        output = os.path.join(pdf_dir, f"{stem}.page-{args.page_k}.png")

    page = pdf[args.page_k - 1]
    bitmap = page.render(scale=args.scale)
    pil_image = bitmap.to_pil()
    pil_image.save(output)
    print(os.path.abspath(output))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
