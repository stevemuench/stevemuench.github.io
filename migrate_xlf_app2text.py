#!/usr/bin/env python3
"""Copy translations from an app-based XLIFF file into a text-message XLIFF.

The first matching source in the app-based file wins.  The input files are
never modified; the output filename is derived from the text-message file.
"""

from __future__ import annotations

import argparse
import copy
from pathlib import Path
import sys
import xml.etree.ElementTree as ET


def local_name(tag: str) -> str:
    """Return an XML tag name without its optional namespace."""
    return tag.rsplit("}", 1)[-1]


def child(element: ET.Element, name: str) -> ET.Element | None:
    """Find the first direct child with *name*, regardless of namespace."""
    return next((item for item in element if local_name(item.tag) == name), None)


def source_key(source: ET.Element) -> bytes:
    """Create a stable key for source text, attributes, and inline markup."""
    # ``tail`` belongs to the surrounding trans-unit's whitespace, not to the
    # source value.  It commonly differs solely because the two files use a
    # different indentation style.
    source_copy = copy.deepcopy(source)
    source_copy.tail = None
    return ET.tostring(source_copy, encoding="utf-8")


def output_path(text_message_path: Path) -> Path:
    """Derive ``f106_text_based_en_it.xlf`` from ``f106_en_it.xlf``."""
    parts = text_message_path.stem.split("_")
    if len(parts) >= 3:
        name = "_".join([*parts[:-2], "text", "based", *parts[-2:]])
    else:
        name = f"{text_message_path.stem}_text_based"
    return text_message_path.with_name(f"{name}{text_message_path.suffix}")


def replace_target_contents(destination: ET.Element, source: ET.Element) -> None:
    """Replace target text and children while retaining destination attributes."""
    destination.text = source.text
    for item in list(destination):
        destination.remove(item)
    for item in source:
        destination.append(copy.deepcopy(item))


def migrate(app_based_path: Path, text_message_path: Path) -> tuple[Path, int, int]:
    """Write a merged copy and return its path, updated count, and unmatched count."""
    try:
        app_tree = ET.parse(app_based_path)
        text_tree = ET.parse(text_message_path)
    except (OSError, ET.ParseError) as error:
        raise ValueError(str(error)) from error

    translations: dict[bytes, ET.Element] = {}
    for unit in app_tree.getroot().iter():
        if local_name(unit.tag) != "trans-unit":
            continue
        source = child(unit, "source")
        target = child(unit, "target")
        if source is not None and target is not None:
            translations.setdefault(source_key(source), target)

    updated = 0
    unmatched = 0
    for unit in text_tree.getroot().iter():
        if local_name(unit.tag) != "trans-unit":
            continue
        source = child(unit, "source")
        if source is None:
            unmatched += 1
            continue
        translated_target = translations.get(source_key(source))
        if translated_target is None:
            unmatched += 1
            continue
        target = child(unit, "target")
        if target is None:
            target = ET.SubElement(unit, "target")
        replace_target_contents(target, translated_target)
        updated += 1

    destination = output_path(text_message_path)
    ET.indent(text_tree, space="  ")
    text_tree.write(destination, encoding="utf-8", xml_declaration=True)
    return destination, updated, unmatched


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Copy app-based XLIFF target values into a text-message XLIFF copy."
    )
    parser.add_argument("app_based_xliff", type=Path, help="translated app-based XLIFF file")
    parser.add_argument("text_message_xliff", type=Path, help="text-message XLIFF file to copy")
    arguments = parser.parse_args()

    try:
        destination, updated, unmatched = migrate(
            arguments.app_based_xliff, arguments.text_message_xliff
        )
    except ValueError as error:
        parser.error(str(error))

    print(f"Created {destination} ({updated} updated, {unmatched} unmatched).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
