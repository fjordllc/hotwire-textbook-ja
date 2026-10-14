#!/usr/bin/env python3
"""Synchronize only the complete sample files referenced by mdBook includes."""
import argparse
import pathlib
import re
import sys

root = pathlib.Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--source', type=pathlib.Path, required=True)
parser.add_argument('--check', action='store_true')
args = parser.parse_args()
paths = set()
for chapter in (root / 'manuscript').rglob('*.md'):
    paths.update(re.findall(r'\{\{#include ../snippets/([^}:]+)\}\}', chapter.read_text()))
errors = []
for name in sorted(paths):
    source = args.source / name
    target = root / 'manuscript/snippets' / name
    if not source.is_file():
        errors.append(f'missing source: {name}')
    elif args.check:
        if not target.is_file() or target.read_bytes() != source.read_bytes():
            errors.append(f'different: {name}')
    else:
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(source.read_bytes())
print(f'{len(paths)} referenced files; {len(errors)} differences')
for error in errors:
    print(error)
sys.exit(bool(errors))
