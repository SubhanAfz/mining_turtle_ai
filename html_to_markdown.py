#!/usr/bin/env python3

from __future__ import annotations

import argparse
import html
import re
from html.parser import HTMLParser
from pathlib import Path
from typing import Callable


WHITESPACE_RE = re.compile(r"[ \t\r\f\v]+")
MULTI_BLANK_RE = re.compile(r"\n{3,}")


class MarkdownConverter(HTMLParser):
    def __init__(self, rewrite_url: Callable[[str], str] | None = None) -> None:
        super().__init__(convert_charrefs=True)
        self.parts: list[str] = []
        self.href_stack: list[str | None] = []
        self.list_stack: list[tuple[str, int]] = []
        self.blockquote_depth = 0
        self.in_pre = False
        self.in_code = False
        self.skip_depth = 0
        self.rewrite_url = rewrite_url

    def convert(self, text: str) -> str:
        self.feed(text)
        self.close()
        output = "".join(self.parts)
        output = output.replace("\xa0", " ")
        output = MULTI_BLANK_RE.sub("\n\n", output)
        return output.strip() + "\n"

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        attrs_dict = dict(attrs)

        if tag in {"script", "style", "noscript"}:
            self.skip_depth += 1
            return

        if self.skip_depth:
            return

        if tag in {"h1", "h2", "h3", "h4", "h5", "h6"}:
            level = int(tag[1])
            self._ensure_block()
            self.parts.append("#" * level + " ")
        elif tag == "p":
            self._ensure_block()
        elif tag == "br":
            self.parts.append("  \n")
        elif tag == "hr":
            self._ensure_block()
            self.parts.append("---\n\n")
        elif tag in {"strong", "b"}:
            self.parts.append("**")
        elif tag in {"em", "i"}:
            self.parts.append("*")
        elif tag == "code":
            if self.in_pre:
                self.in_code = True
            else:
                self.parts.append("`")
                self.in_code = True
        elif tag == "pre":
            self._ensure_block()
            self.parts.append("```\n")
            self.in_pre = True
        elif tag == "a":
            self.parts.append("[")
            href = attrs_dict.get("href")
            if href and self.rewrite_url:
                href = self.rewrite_url(href)
            self.href_stack.append(href)
        elif tag == "img":
            alt = attrs_dict.get("alt") or ""
            src = attrs_dict.get("src") or ""
            if src and self.rewrite_url:
                src = self.rewrite_url(src)
            self.parts.append(f"![{self._escape_inline(alt)}]({src})")
        elif tag == "blockquote":
            self._ensure_block()
            self.blockquote_depth += 1
        elif tag in {"ul", "ol"}:
            self._ensure_block()
            self.list_stack.append((tag, 0))
        elif tag == "li":
            self._ensure_list_item()
        elif tag in {
            "div",
            "section",
            "article",
            "header",
            "footer",
            "nav",
            "main",
            "table",
            "tr",
        }:
            self._ensure_block()
        elif tag in {"td", "th"}:
            if self.parts and not self.parts[-1].endswith("\n"):
                self.parts.append(" ")

    def handle_endtag(self, tag: str) -> None:
        if tag in {"script", "style", "noscript"}:
            if self.skip_depth:
                self.skip_depth -= 1
            return

        if self.skip_depth:
            return

        if tag in {
            "h1",
            "h2",
            "h3",
            "h4",
            "h5",
            "h6",
            "p",
            "div",
            "section",
            "article",
            "header",
            "footer",
            "nav",
            "main",
            "table",
            "tr",
        }:
            self._ensure_block()
        elif tag in {"strong", "b"}:
            self.parts.append("**")
        elif tag in {"em", "i"}:
            self.parts.append("*")
        elif tag == "code":
            if self.in_code and not self.in_pre:
                self.parts.append("`")
            self.in_code = False
        elif tag == "pre":
            self.parts.append("\n```\n\n")
            self.in_pre = False
            self.in_code = False
        elif tag == "a":
            href = self.href_stack.pop() if self.href_stack else None
            if href:
                self.parts.append(f"]({href})")
            else:
                self.parts.append("]")
        elif tag == "blockquote":
            self._ensure_block()
            self.blockquote_depth = max(0, self.blockquote_depth - 1)
        elif tag in {"ul", "ol"}:
            if self.list_stack:
                self.list_stack.pop()
            self._ensure_block()
        elif tag == "li":
            self.parts.append("\n")
        elif tag in {"td", "th"}:
            self.parts.append(" ")

    def handle_data(self, data: str) -> None:
        if self.skip_depth or not data:
            return

        if self.in_pre:
            self.parts.append(data)
            return

        text = WHITESPACE_RE.sub(" ", data)
        if not text.strip():
            return

        if self.blockquote_depth and self._at_line_start():
            self.parts.append(">" * self.blockquote_depth + " ")

        self.parts.append(self._escape_text(text))

    def handle_entityref(self, name: str) -> None:
        self.handle_data(html.unescape(f"&{name};"))

    def handle_charref(self, name: str) -> None:
        self.handle_data(html.unescape(f"&#{name};"))

    def _ensure_block(self) -> None:
        if not self.parts:
            return
        current = "".join(self.parts[-2:]) if len(self.parts) >= 2 else self.parts[-1]
        if current.endswith("\n\n"):
            return
        if current.endswith("\n"):
            self.parts.append("\n")
        else:
            self.parts.append("\n\n")

    def _at_line_start(self) -> bool:
        if not self.parts:
            return True
        return self.parts[-1].endswith("\n")

    def _ensure_list_item(self) -> None:
        if self.parts and not self.parts[-1].endswith("\n"):
            self.parts.append("\n")

        depth = len(self.list_stack)
        indent = "  " * max(0, depth - 1)

        if not self.list_stack:
            marker = "- "
        else:
            kind, count = self.list_stack[-1]
            count += 1
            self.list_stack[-1] = (kind, count)
            marker = f"{count}. " if kind == "ol" else "- "

        if self.blockquote_depth:
            self.parts.append(">" * self.blockquote_depth + " ")

        self.parts.append(indent + marker)

    def _escape_text(self, text: str) -> str:
        if self.in_code:
            return text
        return text.replace("\\", "\\\\")

    def _escape_inline(self, text: str) -> str:
        return text.replace("[", "\\[").replace("]", "\\]")


def convert_html_to_markdown(
    html_text: str, rewrite_url: Callable[[str], str] | None = None
) -> str:
    converter = MarkdownConverter(rewrite_url=rewrite_url)
    return converter.convert(html_text)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Convert an HTML file to Markdown.")
    parser.add_argument("input", help="Path to the source HTML file.")
    parser.add_argument(
        "output",
        nargs="?",
        help="Optional output Markdown path. Defaults to input path with .md suffix.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    input_path = Path(args.input)
    output_path = Path(args.output) if args.output else input_path.with_suffix(".md")

    html_text = input_path.read_text(encoding="utf-8")
    markdown = convert_html_to_markdown(html_text)
    output_path.write_text(markdown, encoding="utf-8")

    print(f"wrote markdown to {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
