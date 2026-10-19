#!/usr/bin/env python3
"""Rename the template's placeholder prefix, SpawnRoom, to your game's name, everywhere.

usage: python3 rename.py MyMap

Run it once, right after making your copy of the template. Every class, setting, sound, text id
and file named after the placeholder is renamed, keeping its case:

    SpawnRoom_Player      ->  MyMap_Player        (classes)
    spawnroom_...         ->  mymap_...           (CVars, sounds, the game folder and the pk3)
    SPAWNROOM_MAP01       ->  MYMAP_MAP01         (LANGUAGE ids)

The name must start with a letter and be letters and digits only. Pick one that won't clash with
anything else in the mods yours gets played with (not HH, which is Horde Hammer's).

README.md, LICENSE and this script are left alone, and so are binary files (maps, pictures,
compiled ACS), which never contain the placeholder. Afterwards, delete this script and rewrite the
README for your game. Dependency-free Python 3.8+.
"""

import os
import re
import sys

PLACEHOLDER = "SpawnRoom"
SKIPPED_DIRS = {".git", ".jj", "secrets", "published", "__pycache__"}
SKIPPED_FILES = {"README.md", "LICENSE", "rename.py"}
BINARY = (".wad", ".png", ".o", ".pk3", ".ogg", ".flac", ".wav", ".mp3", ".lmp")


def replacements(name):
    return [(PLACEHOLDER, name), (PLACEHOLDER.lower(), name.lower()), (PLACEHOLDER.upper(), name.upper())]


def text_files(root):
    for folder, dirs, names in os.walk(root):
        dirs[:] = [d for d in dirs if d not in SKIPPED_DIRS]
        for name in names:
            if name in SKIPPED_FILES or name.lower().endswith(BINARY):
                continue
            yield os.path.join(folder, name)


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__.strip().splitlines()[2])
    name = sys.argv[1]
    if not re.fullmatch(r"[A-Za-z][A-Za-z0-9]*", name):
        sys.exit(f"{name!r}: use letters and digits only, starting with a letter")
    if name.lower() == PLACEHOLDER.lower():
        sys.exit("that is the placeholder's own name")
    if name.lower().startswith("hh"):
        sys.exit("names starting with HH are Horde Hammer's")

    root = os.path.dirname(os.path.abspath(__file__))
    pairs = replacements(name)

    changed = 0
    leftovers = []
    for path in text_files(root):
        try:
            with open(path, encoding="utf-8") as f:
                text = f.read()
        except UnicodeDecodeError:
            continue
        new = text
        for old, replacement in pairs:
            new = new.replace(old, replacement)
        if new != text:
            with open(path, "w", encoding="utf-8") as f:
                f.write(new)
            changed += 1
        if PLACEHOLDER.lower() in new.lower():
            leftovers.append(os.path.relpath(path, root))

    # Files and folders, deepest first, so a folder is renamed after what is in it
    renamed = 0
    for folder, dirs, names in os.walk(root, topdown=False):
        if set(os.path.relpath(folder, root).split(os.sep)) & SKIPPED_DIRS:
            continue
        for entry in names + dirs:
            if entry in SKIPPED_DIRS or PLACEHOLDER.lower() not in entry.lower():
                continue
            target = entry
            for old, replacement in pairs:
                target = target.replace(old, replacement)
            os.rename(os.path.join(folder, entry), os.path.join(folder, target))
            renamed += 1

    print(f"{PLACEHOLDER} is now {name}: {changed} files changed, {renamed} files and folders renamed.")
    for path in leftovers:
        print(f"check {path}: it still has {PLACEHOLDER} in a case this script doesn't change")
    print("Now delete rename.py, and make README.md about your game.")


if __name__ == "__main__":
    main()
