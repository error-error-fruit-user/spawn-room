# spawn-room — agent context

## Start here

- Read `CLAUDE.md` for the full project conventions and `../horde-hammer/CLAUDE.md` for ZScript and multiplayer safety rules. These apply to OpenCode too.
- This is the 0BSD GitHub template for UZDoom zombies maps and map packs. Keep it simple, readable and easy for new mappers to rename.
- `spawnroom/` is the pk3 root; classes use `SpawnRoom_`. Horde Hammer loads first and supplies all zombies systems. Use library hooks rather than duplicating systems here.
- `spawnroom/weapons/rifle/` contains the example weapon; sprites live under `spawnroom/sprites/weapons/rifle/`. Include scripts and sound definitions explicitly from the root lumps.
- `acs/hh.acs` mirrors the library's include; refresh it when that API changes.

## Build and verify

Run from this project directory:

- Pack: `python3 publish.py --strict`.
- Compile after ZScript changes: `../horde-hammer/secrets/check.sh spawnroom`.
- Headless: `../horde-hammer/secrets/run.sh -m MAP01 "netevent hhtest_state; wait 2; quit" spawnroom ../horde-hammer/test`. Test defaults win because test loads last.
- Multiplayer: use the library's `secrets/net.sh` and compare both peers' state; see `CLAUDE.md` for details.
- Test `rename.py` only on a copy, never on this repository.

## Working rules

- Ask before editing project files; an explicit request authorizes only its scope.
- Only original or suitably permissive assets; no copyrighted game assets. Preserve the README AI notice.
- Version control is jj colocated with git. For ChatGPT via OpenCode work, use `secrets/commit.sh "message" --opencode` when committing is requested. `--claude` remains available separately.
- Never read tokens or commit `secrets/` or `published/`.
- Current tasks and manual UDB/play checks: `secrets/TODO.md`; cross-project work: `../TODO.md`. Re-read these instead of treating a context snapshot as current status.
