#!/usr/bin/env python3

from __future__ import annotations

import argparse
import sys
import time
from collections import deque
from html.parser import HTMLParser
from pathlib import Path
from typing import Iterable
from urllib.parse import urljoin, urlsplit, urlunsplit
from urllib.request import Request, urlopen


ALLOWED_HOSTS = {"tweaked.cc", "www.tweaked.cc"}
ASSET_SUFFIXES = {
    ".apng",
    ".avif",
    ".bmp",
    ".css",
    ".gif",
    ".ico",
    ".jpeg",
    ".jpg",
    ".js",
    ".json",
    ".map",
    ".mjs",
    ".pdf",
    ".png",
    ".svg",
    ".toml",
    ".txt",
    ".wasm",
    ".webp",
    ".woff",
    ".woff2",
    ".xml",
    ".zip",
}


class LinkParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.links: set[str] = set()

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag != "a":
            return

        for key, value in attrs:
            if key == "href" and value:
                self.links.add(value)


def canonicalize(url: str) -> str:
    parts = urlsplit(url)
    scheme = "https"
    host = parts.netloc.lower()
    if host == "www.tweaked.cc":
        host = "tweaked.cc"
    path = parts.path or "/"
    if path != "/" and path.endswith("/"):
        path = path[:-1]
    return urlunsplit((scheme, host, path, "", ""))


def is_allowed_host(url: str) -> bool:
    return urlsplit(url).netloc.lower() in ALLOWED_HOSTS


def is_doc_url(url: str) -> bool:
    parts = urlsplit(url)
    path = parts.path or "/"

    if path == "/":
        return True

    lowered = path.lower()
    if any(lowered.endswith(suffix) for suffix in ASSET_SUFFIXES):
        return False

    return lowered.endswith(".html")


def normalize_link(base_url: str, href: str) -> str | None:
    href = href.strip()
    if not href or href.startswith("#"):
        return None
    if href.startswith(("mailto:", "javascript:", "tel:")):
        return None

    absolute = canonicalize(urljoin(base_url, href))
    if not is_allowed_host(absolute):
        return None
    if not is_doc_url(absolute):
        return None
    return absolute


def fetch(url: str, timeout: float, pause: float) -> str:
    request = Request(
        url,
        headers={"User-Agent": "tweaked.cc-doc-crawler/1.0 (+https://tweaked.cc/)"},
    )

    with urlopen(request, timeout=timeout) as response:
        content_type = response.headers.get_content_type()
        if content_type != "text/html":
            return ""

        charset = response.headers.get_content_charset() or "utf-8"
        body = response.read().decode(charset, errors="replace")

    if pause > 0:
        time.sleep(pause)

    return body


def extract_links(base_url: str, html: str) -> Iterable[str]:
    parser = LinkParser()
    parser.feed(html)

    for href in parser.links:
        normalized = normalize_link(base_url, href)
        if normalized:
            yield normalized


def crawl(start_url: str, timeout: float, pause: float) -> list[str]:
    start_url = canonicalize(start_url)
    seen: set[str] = {start_url}
    queue: deque[str] = deque([start_url])

    while queue:
        current = queue.popleft()
        try:
            html = fetch(current, timeout=timeout, pause=pause)
        except Exception as exc:
            print(f"warning: failed to fetch {current}: {exc}", file=sys.stderr)
            continue

        if not html:
            continue

        for link in extract_links(current, html):
            if link in seen:
                continue
            seen.add(link)
            queue.append(link)

    return sorted(seen)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Crawl tweaked.cc and collect all documentation page URLs."
    )
    parser.add_argument(
        "--start",
        default="https://tweaked.cc/",
        help="Starting URL for the crawl. Defaults to https://tweaked.cc/",
    )
    parser.add_argument(
        "--output",
        default="tweaked_urls.txt",
        help="Path to write the discovered URLs to.",
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
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    urls = crawl(args.start, timeout=args.timeout, pause=args.pause)

    output_path = Path(args.output)
    output_path.write_text("\n".join(urls) + "\n", encoding="utf-8")

    print(f"wrote {len(urls)} URLs to {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
