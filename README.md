# spawn-room

> **AI notice:** this project is developed with the help of AI. Much of the code and documentation was written with [Claude](https://claude.ai) (Anthropic), working under my direction and review. Commits that Claude helped write carry a `Co-Authored-By: Claude` trailer, so you can see which ones in the history.

A template for making Call of Duty zombies style maps and map packs for UZDoom, built on the [Horde Hammer](https://github.com/error-error-fruit-user/horde-hammer) library. Press **Use this template** on GitHub, rename it, and start mapping.

It comes with a small playable map: two rooms joined by a door you buy, zombie spawners, a wall buy, a perk machine, the mystery box, starts for four players, and a map script. It also has one example weapon, packaged so you can copy it to make your own. Everything else (rounds, points, the box, perks, power-ups, going down and reviving, the HUD) is Horde Hammer's, so this template only holds what makes your game yours.

**Status:** early, like Horde Hammer (0.1.0). Names in the library may change before its 1.0.

## What's in it

| Path | What it is |
|---|---|
| `spawnroom/` | The game. This folder is the root of your pk3: UZDoom can load it as it is, and `publish.py` zips it |
| `spawnroom/maps/map01.wad` | The example map (UDMF), with its script inside it |
| `spawnroom/weapons/rifle/`, `spawnroom/sprites/weapons/rifle/` | The example weapon: its script and sounds, and its pictures |
| `spawnroom/zscript/spawnroom/` | The game's own ZScript: its settings (`defaults.zs`) and its player (`player.zs`) |
| `spawnroom/MAPINFO.txt` | Maps, the player class, the HUD, the skill, and numbers for your own map things |
| `spawnroom/LANGUAGE.txt`, `SNDINFO.txt`, `CVARINFO.txt`, `MENUDEF.txt` | Text, sounds, your own settings and their menu |
| `acs/hh.acs` | Horde Hammer's functions for map scripts (a copy of the library's) |
| `publish.py` | Packs the game into `published/spawnroom.pk3` |
| `rename.py` | Renames the template to your game, once |

Every file has comments saying what to change and why.

## Start here

### 1. Install

- **[UZDoom](https://github.com/UZDoom/UZDoom/releases)** 5.0 or newer: the engine.
- **An IWAD**: [Freedoom: Phase 2](https://freedoom.github.io/) (free), or Doom II. The template only uses what both have.
- **[Horde Hammer](https://github.com/error-error-fruit-user/horde-hammer)**: `horde-hammer.pk3` from its releases, or its repository's `hh/` folder, which loads the same way.
- **[Ultimate Doom Builder](https://github.com/UltimateDoomBuilder/UltimateDoomBuilder/releases)**: the map editor.
- **[Python 3](https://www.python.org/downloads/)** for `rename.py` and `publish.py` (nothing else to install).

### 2. Make it yours

Make your copy (**Use this template** on GitHub, then clone it), and pick a name for your game: letters and digits, starting with a letter, unlikely to clash with other mods (`Dead2Rise`, not `Zombies`). Then:

```
python3 rename.py Dead2Rise
```

The template's placeholder is `SpawnRoom`, in three cases: `SpawnRoom_` in class names, `spawnroom` in settings, sounds, the game folder and the pk3, `SPAWNROOM_` in text ids. The script changes all of them (`spawnroom/` becomes `dead2rise/`, `SpawnRoom_Rifle` becomes `Dead2Rise_Rifle`...). Without Python, a search and replace of the three, keeping their case, and renaming the two folders named `spawnroom` does the same. Afterwards delete `rename.py`, make this README about your game, and choose your license (the template's is 0BSD, so you can use any).

The rest of this README says `spawnroom`; read it as your name.

### 3. Play it

```
uzdoom -iwad freedoom2.wad -file horde-hammer.pk3 spawnroom
```

Horde Hammer always loads **before** the game (without it, the game stops at startup with "Unknown class HH_..."). A folder loads like a pk3, so there is nothing to pack while you work. To share the game, `python3 publish.py` writes `published/spawnroom.pk3` (with your `LICENSE` next to it); players load `horde-hammer.pk3` and then it. It also warns about things UZDoom gets wrong without telling you, like two files whose names differ only in case.

## Making the map

### Setting up Ultimate Doom Builder

Open `spawnroom/maps/map01.wad`. In the map options (or, for a new map, the New Map dialog):

- **Game configuration**: the Doom 2 one in **UDMF** format for UZDoom's family of engines (the ZDoom ones). UDMF is what lets things carry arguments, which Horde Hammer uses everywhere.
- **Resources**, in this order: Horde Hammer (`horde-hammer.pk3`, or its `hh/` folder as a directory resource), then the game folder `spawnroom/` as a directory resource. The IWAD is picked separately.

Ultimate Doom Builder reads both like the engine does. The things' numbers come from their `MAPINFO.txt` and their names, categories, sprites and argument labels from comments in their ZScript (`//$Category`, `//$Title`, `//$Arg0`...), so the Things panel shows **Horde Hammer → Zombie Spawner** and **SpawnRoom → Rifle Wall Buy** with named arguments instead of bare numbers. If they show as unknown numbers, check the resources and their order, then reload them (**Tools → Reload Resources**). Give your own things the same comments (see `SpawnRoom_RifleWallBuy` in `zscript.rifle`).

For **map scripts**, copy `acs/hh.acs` into Ultimate Doom Builder's `Compilers/ZDoom/` folder, next to `zcommon.acs`, so its compiler finds it.

For **Test Map** (F9), set the UZDoom executable in **Tools → Game Configurations → Testing**. It passes the resources to UZDoom with `-file`, in their order, so the game starts with the library loaded.

### Placing Horde Hammer's things

The example map has one of nearly everything; look at its things' arguments in the editor. In short:

| Thing | Notes |
|---|---|
| **Player 1-4 Starts** | One per player. For more than 4, Player 5-8 Starts (4001-4004) |
| **Zombie Spawner** | Invisible. Arg 0 is its zone: 0 spawns from round 1, any other zone once a door opens it. Put them where players can't see them appear |
| **Door**, **Debris** | What players buy to open zones. Args 0-3: the zones it opens; arg 4: its cost (0 for 1000). Bought, it vanishes. To open a real door behind it, give it a TID, tag the door sector the same, and let the map script open it (below) |
| **Mystery Box Location** | Where the box can be. Arg 0: 1 for where it always starts, -1 for never first. With one location the box never moves |
| **Perk machines** | Quick Revive, Juggernog, Speed Cola, Double Tap |
| **Wall buys** | Your weapons' own (like **Rifle Wall Buy**). Against a wall, facing out of it, about 40 units up |
| Spectator Spot, Game Over Camera, Respawn Spot | Optional: where spectators' bodies wait, what everyone sees at the end, where players come back each round |

Every thing, its number and its arguments are in [Horde Hammer's README](https://github.com/error-error-fruit-user/horde-hammer#map-things).

### Map scripts

Each map's script is in the map itself: in Ultimate Doom Builder, **Scripts → SCRIPTS**. It compiles when you save the map. The map talks to Horde Hammer through `hh.acs`, which wraps every call the library offers: `HH_GivePoints(player, amount)`, `HH_OpenZone(zone)`, `HH_CurrentRound()`, `HH_StartGame()` and more, listed in the file. Horde Hammer also runs your scripts when things happen, once you ask it to with `HH_Listen`:

```
script "Setup" OPEN {
    HH_Listen("round_started", "RoundStarted");     // runs "RoundStarted" with the round's number
    HH_Listen("door_opened", "DoorOpened");         // with the player, the door's TID and its cost
}
```

The example map's script does two things this way: every fifth round it gives everyone 500 points, and when the Horde Hammer door is bought it opens the sector door behind it (`Door_Open` on the door thing's TID). The events are listed in [Horde Hammer's README](https://github.com/error-error-fruit-user/horde-hammer#map-scripts-and-events): rounds starting and ending, players going down and being revived, doors, perks, the box, power-ups and the end of the game.

A game with an intro sets `hh_auto_start` to 0 in its settings and calls `HH_StartGame()` from its script when the intro is over.

## Making it your game

### Settings

Every Horde Hammer setting (points, costs, zombie health and numbers per round, the box, drops, revive times, the kick...) is a CVar, listed in the library's `CVARINFO.txt`. Your game sets its own defaults in `spawnroom/zscript/spawnroom/defaults.zs`, which has examples; a host can still change any of them in the console. Your game's own settings go in `CVARINFO.txt` (the template has one, a switch between Horde Hammer's zombies and Doom's monsters, shown in the options menu by `MENUDEF.txt`).

### Adding a weapon

A weapon is a folder of its own, plus its pictures (which only load from `sprites/`). The rifle is the example:

```
spawnroom/weapons/rifle/rifle.zs        the weapon, its ammo and its wall buy
spawnroom/weapons/rifle/sndinfo.txt     its sound names
spawnroom/weapons/rifle/sounds/         its sound files (the rifle uses the IWAD's, so it has none)
spawnroom/sprites/weapons/rifle/        its pictures
```

Files in folders don't load by themselves, so each weapon has a line in `ZSCRIPT.zs` (`#include "weapons/rifle/rifle.zs"`) and one at the end of `SNDINFO.txt` (`$include "weapons/rifle/sndinfo.txt"`). To add yours, copy the two folders, replace `rifle` and `Rifle` with your weapon's name in the folder and file names and inside the files, add its two lines, and:

1. **Sprites**: draw your frames and give them a new 4-letter sprite name that no other sprite uses (the rifle's is `SRR`+a letter: `SRRG`, `SRRF`, `SRRP`, `SRRD`), then use those names in the weapon's `States`. A file is named sprite + frame letter + `0`, like `srrga0.png`. First-person frames need offsets so they sit at the bottom of the screen; [SLADE](https://slade.mancubus.net/) sets them.
2. **Sounds**: put your files in `weapons/<weapon>/sounds/` and point the names in its `sndinfo.txt` at them by path (`weapons/<weapon>/sounds/fire.ogg`).
3. **Numbers**: the magazine, damage, fire and reload speed, and how often the box gives it (`HH_Weapon.BoxWeight`), are in its `Default` block, explained there.
4. **Where players get it**: the box gives any weapon in a slot (`Weapon.SlotNumber`), so a weapon with a slot and a box weight is in the box. For a wall buy, give its wall buy class a free number in `MAPINFO.txt`'s `DoomEdNums` (the template's start at 28000) and place it in the map. For a starting weapon, see `player.zs`.

Horde Hammer's README has the [rest of what weapons can do](https://github.com/error-error-fruit-user/horde-hammer#weapons): partial reloads, zoom, last stand pistols, upgraded versions.

### Replacing Horde Hammer's art, sounds and text

Horde Hammer's art is placeholders and its sounds are Doom's. Your game replaces any of them by shipping a file with the same name: perk machines, the box, power-up icons, the HUD's pictures, every `hh/...` sound (in `SNDINFO.txt`) and every `HH_...` string (in `LANGUAGE.txt`). The names are in [Horde Hammer's README](https://github.com/error-error-fruit-user/horde-hammer#art-sounds-and-text). Ship only art and sounds you made or may share; the template itself has none it couldn't give away.

## Testing multiplayer on one machine

Start two copies of UZDoom, one hosting and one joining:

```
uzdoom -iwad freedoom2.wad -file horde-hammer.pk3 spawnroom -host 2
uzdoom -iwad freedoom2.wad -file horde-hammer.pk3 spawnroom -join 127.0.0.1
```

The game starts once both are in. Both must load the same files in the same order. Try what your map adds: buy its doors and wall buys from each player, go down and revive each other, and let one bleed out. UZDoom's multiplayer runs the same game on every machine, so if they drift apart UZDoom reports a desync, which means something in your ZScript did a different thing on each machine (Horde Hammer's README has the rules it follows). A real second computer finds what one machine doesn't, since lag makes desyncs show sooner.

## Map packs

Several zombies maps in one pk3 work like one map, with more of them:

- **Maps**: `maps/map01.wad`, `maps/map02.wad`... each with its own things and its own script.
- **Weapons**: they load for every map, so all the maps share them. Each map chooses which it sells on its walls; the box gives everything in the players' slots on every map.
- **The game's ZScript, text, sounds and settings** are shared too. For a setting that differs between maps, check the map in `defaults.zs` (it runs at the start of every map): `if (Level.MapName ~== "MAP02") settings.Set("hh_box_cost", "500");`. A map's script can also change things as it plays, through `hh.acs`.

**Choosing a map.** A zombies map never ends in an exit to the next one: the game is over when everyone is down. So players need a way to pick a map before they start, and the simplest is UZDoom's own **New Game** menu: give every map an `episode` entry in `MAPINFO.txt`, and the menu lists them by name.

```
clearEpisodes

episode MAP01 {
    name = "$SPAWNROOM_MAP01"
    noSkillMenu
}

episode MAP02 {
    name = "$SPAWNROOM_MAP02"
    noSkillMenu
}

map MAP02 lookup "SPAWNROOM_MAP02" {
    sky1 = "SKY1"
    next = "MAP02"
}
```

Each map then starts as a new game: points, weapons and perks start over, the way they should. In multiplayer the host picks the map when starting (`+map MAP02`, or the New Game menu before hosting from a launcher). A map-select menu of your own (with pictures of each map) is a `MENUDEF.txt` list whose entries start each map; the New Game menu is the same thing, already made.

A **hub** (a lobby map players walk around, with a door or teleporter to each zombies map) is the other way, but Horde Hammer doesn't support it yet: its rounds and HUD run on every map, the lobby included, and players would carry their points and weapons from one map to the next. Until the library can be told a map isn't a zombies map, use the menu.

## License

[0BSD](LICENSE): use it for anything, no credit required. What you build from it is yours to license however you like.
