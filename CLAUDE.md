# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

**spawn-room** is a GitHub template repository for zombies maps and map packs on GZDoom/UZDoom. It holds no zombies systems of its own: it depends on **Horde Hammer** (`../horde-hammer`, prefix `HH_`), loaded before it, and shows a mapper how to use it with a small playable example and drop-in weapons. People copy it ("Use this template") and make it theirs, so everything in it is meant to be read, renamed and replaced. Planned work is in `secrets/TODO.md` (local, untracked); work that spans the projects in `..` is in `../TODO.md`.

Nacht des Schreckens (`../nacht-des-schreckens`) is the first real game on Horde Hammer; when unsure how a game should use the library, look at how nacht does it once it has moved over, and make the template the simplest version of that.

## Commands

- Pack: `python3 publish.py` (once it is copied from `../nacht-des-schreckens/publish.py`; change `PACKAGE`, `NAME` and `LICENSES` at its top) zips the game folder into `published/<name>.pk3`.
- Play: `uzdoom -iwad freedoom2.wad -file horde-hammer.pk3 <name>.pk3`, or the folders themselves with `-file` while developing. tdl (`../tdl`) plays the built pk3s.
- Version control is **jj** (colocated with git). `secrets/commit.sh "msg" [--claude]` commits and moves the `main` bookmark; use `--claude` for work Claude helped write (adds the Co-Authored-By trailer). `secrets/push.sh` pushes `main` as `error-error-fruit-user` with `secrets/token.txt` or, if there is none, the shared `../token.txt`. Both run from anywhere in the project.

## Conventions

- Everything in `../horde-hammer/CLAUDE.md` (capitalization, lump names, folders, multiplayer rules, UDB hints) applies here, with the game's own prefix in place of `HH_`. The template uses a placeholder prefix that a new project replaces in one search (pick it so it can't match anything else, and say in the README how to rename it).
- Only use the library through what it offers (its classes, properties, events, ACS calls). If the template needs something the library lacks, that is a library change, not a workaround here.
- Ship **no copyrighted assets**: Freedoom-compatible, original or CC0 art and sounds only, so a template copy can be shared freely. Assume `freedoom2.wad` as the IWAD and work with `doom2.wad` too.
- Drop-in weapons follow the layout in `../horde-hammer/secrets/TODO.md` (**18**): a folder per weapon with its own `zscript.<weapon>` and `sndinfo.<weapon>`, nothing else to edit.
- Comments here are for mappers new to ZScript: explain what to change and why, more than library code would.

## Working in this repo

- Ask before editing project files (standing preference of the repo owner).
- `secrets/` (`commit.sh`, `push.sh`, `TODO.md`, any token) and `published/` are local/untracked; don't commit them, and never read `token.txt` (here or in `..`).
- The repo is **0BSD** (`LICENSE`); only bring in code or assets under a license at least as permissive. Keep the AI notice at the top of `README.md`.
