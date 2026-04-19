#!/usr/bin/env python3

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path
from urllib.parse import urljoin, urlsplit, urlunsplit

from crawl_tweaked_urls import canonicalize, crawl, fetch
from html_to_markdown import convert_html_to_markdown


CONTENT_RE = re.compile(
    r"<section\s+id=\"content\">(?P<content>.*?)</section>\s*<footer>(?P<footer>.*?)</footer>",
    re.DOTALL,
)
ROOT_URL = "https://tweaked.cc/"


def rewrite_doc_link(base_url: str, href: str) -> str:
    href = href.strip()
    if not href or href.startswith(("mailto:", "javascript:", "tel:")):
        return href
    if href.startswith("#"):
        return href

    parts = urlsplit(href)
    fragment = f"#{parts.fragment}" if parts.fragment else ""

    if parts.scheme or parts.netloc:
        if parts.netloc.lower() not in {"tweaked.cc", "www.tweaked.cc"}:
            return href
        path = parts.path or "/"
        if is_doc_path(path):
            return rewrite_doc_path(path) + fragment
        return urlunsplit(("https", "tweaked.cc", path, parts.query, parts.fragment))

    path = parts.path or ""
    if is_doc_path(path):
        return rewrite_doc_path(path) + fragment
    return urljoin(base_url, href)


def is_doc_path(path: str) -> bool:
    return path in {"", ".", "/", "./", ".././"} or path.endswith(("/", ".html", "/./"))


def rewrite_doc_path(path: str) -> str:
    if path in {"", "."}:
        return path
    if path == "/":
        return "/index.md"
    if path.endswith("/./"):
        path = f"{path[:-2]}index.md"
    elif path in {"./", ".././"}:
        return path[:-2] + "index.md"
    if path.endswith("/"):
        return f"{path}index.md"
    if path.endswith(".html"):
        return f"{path[:-5]}.md"
    return path


def output_path_for_url(url: str, docs_dir: Path) -> Path:
    path = urlsplit(url).path or "/"
    if path == "/":
        return docs_dir / "index.md"
    return docs_dir / path.lstrip("/").replace(".html", ".md")


def extract_content(html_text: str, url: str) -> str:
    match = CONTENT_RE.search(html_text)
    if not match:
        raise ValueError(f"Could not find content section in {url}")

    content = match.group("content").strip()
    footer = match.group("footer").strip()
    return f"{content}\n<p>{footer}</p>"


def export_docs(
    start_url: str, docs_dir: Path, timeout: float, pause: float
) -> tuple[int, list[str]]:
    urls = crawl(start_url, timeout=timeout, pause=pause)
    docs_dir.mkdir(parents=True, exist_ok=True)
    failures: list[str] = []

    for url in urls:
        try:
            html_text = fetch(url, timeout=timeout, pause=pause)
            content_html = extract_content(html_text, url)
            markdown = convert_html_to_markdown(
                content_html,
                rewrite_url=lambda href, current_url=url: rewrite_doc_link(
                    current_url, href
                ),
            )

            output_path = output_path_for_url(url, docs_dir)
            output_path.parent.mkdir(parents=True, exist_ok=True)
            output_path.write_text(markdown, encoding="utf-8")
        except Exception as exc:
            failures.append(f"{url}\t{exc}")
            print(f"warning: failed to export {url}: {exc}", file=sys.stderr)

    return len(urls) - len(failures), failures


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Crawl tweaked.cc docs and export each page to Markdown."
    )
    parser.add_argument(
        "--start",
        default=ROOT_URL,
        help="Starting URL for the crawl. Defaults to https://tweaked.cc/",
    )
    parser.add_argument(
        "--output-dir",
        default="docs",
        help="Directory to write Markdown files into.",
    )
    parser.add_argument(
        "--timeout",
        type=float,
        default=20.0,
        help="HTTP timeout in seconds for each request.",
    )
    parser.add_argument(
        "--pause",
        type=float,
        default=0.0,
        help="Pause in seconds after each successful request.",
    )
    parser.add_argument(
        "--failures",
        default="docs_failures.txt",
        help="Path to write failed URLs to when any export fails.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    start_url = canonicalize(args.start)
    docs_dir = Path(args.output_dir)

    exported_count, failures = export_docs(
        start_url=start_url,
        docs_dir=docs_dir,
        timeout=args.timeout,
        pause=args.pause,
    )

    if failures:
        Path(args.failures).write_text("\n".join(failures) + "\n", encoding="utf-8")
        print(
            f"exported {exported_count} pages to {docs_dir} with {len(failures)} failures; see {args.failures}"
        )
        return 1

    print(f"exported {exported_count} pages to {docs_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
