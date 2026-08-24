#!/usr/bin/env python3
import argparse
import json
import re
import sys
from pathlib import Path

IDENTIFIER_RE = re.compile(r"[A-Za-z_][A-Za-z0-9_']*")


def load_dictionary(path: Path) -> dict:
    raw = json.loads(path.read_text(encoding="utf-8"))
    merged = {}
    for key, section in raw.items():
        if key.startswith("_") and isinstance(section, dict):
            merged.update(section)
    return merged


def invert(mapping: dict) -> dict:
    inverted = {}
    for k, v in mapping.items():
        if v in inverted and inverted[v] != k:
            raise ValueError(
                f"dictionary is not bijective: '{v}' is the target of both "
                f"'{inverted[v]}' and '{k}'"
            )
        inverted[v] = k
    return inverted


def split_code_string_comment(line: str):
    spans = []
    i = 0
    n = len(line)
    in_string = False
    span_start = 0

    while i < n:
        ch = line[i]

        if not in_string and ch == '"':
            spans.append(("code", line[span_start:i]))
            span_start = i
            in_string = True
            i += 1
            continue

        if in_string:
            if ch == "\\" and i + 1 < n:
                i += 2
                continue
            if ch == '"':
                in_string = False
                i += 1
                spans.append(("string", line[span_start:i]))
                span_start = i
                continue
            i += 1
            continue

        if not in_string and ch == "-" and i + 1 < n and line[i + 1] == "-":
            spans.append(("code", line[span_start:i]))
            spans.append(("comment", line[i:]))
            span_start = n
            i = n
            break

        i += 1

    if span_start < n:
        kind = "string" if in_string else "code"
        spans.append((kind, line[span_start:]))

    return spans


def translate_line(line: str, mapping: dict) -> str:
    spans = split_code_string_comment(line)
    out = []
    for kind, text in spans:
        if kind != "code":
            out.append(text)
            continue
        out.append(IDENTIFIER_RE.sub(lambda m: mapping.get(m.group(0), m.group(0)), text))
    return "".join(out)


def translate_text(text: str, mapping: dict) -> str:
    return "\n".join(translate_line(line, mapping) for line in text.split("\n"))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("direction", choices=["clean", "smudge"])
    parser.add_argument("--dict", default=str(Path(__file__).parent / "dictionary.json"))
    parser.add_argument("path", nargs="?")
    args = parser.parse_args()

    english_to_latin = load_dictionary(Path(args.dict))
    mapping = english_to_latin if args.direction == "clean" else invert(english_to_latin)

    source = Path(args.path).read_text(encoding="utf-8") if args.path else sys.stdin.read()
    result = translate_text(source, mapping)

    sys.stdout.write(result)
    return 0


if __name__ == "__main__":
    sys.exit(main())
