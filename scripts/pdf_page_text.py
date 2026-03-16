#!/usr/bin/env python3
import argparse
import os
import sys

try:
    from pypdf import PdfReader
except Exception as exc:
    print(
        "ERROR: pypdf is required. Install with: python3 -m pip install --user pypdf",
        file=sys.stderr,
    )
    print(f"Details: {exc}", file=sys.stderr)
    sys.exit(1)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Extract all text from page k (1-based) in a PDF."
    )
    parser.add_argument("pdf_file", help="Path to the input PDF file")
    parser.add_argument("page_k", type=int, help="1-based page index")
    args = parser.parse_args()

    if args.page_k < 1:
        print("ERROR: page_k must be >= 1", file=sys.stderr)
        return 1
    if not os.path.isfile(args.pdf_file):
        print(f"ERROR: PDF not found: {args.pdf_file}", file=sys.stderr)
        return 1

    try:
        reader = PdfReader(args.pdf_file)
    except Exception as exc:
        print(f"ERROR: failed to open PDF: {exc}", file=sys.stderr)
        return 1

    page_count = len(reader.pages)
    if args.page_k > page_count:
        print(
            f"ERROR: page_k={args.page_k} out of range. PDF has {page_count} pages.",
            file=sys.stderr,
        )
        return 1

    page = reader.pages[args.page_k - 1]
    text = page.extract_text() or ""
    sys.stdout.write(text)
    if text and not text.endswith("\n"):
        sys.stdout.write("\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
