version "5.0.0"

// The game's ZScript. Horde Hammer (horde-hammer.pk3) is loaded before this pk3, so its HH_ classes
// can be used and subclassed here. Only this file loads by itself: every other script is included
// below, the game's own from zscript/spawnroom/ and each weapon's from weapons/<weapon>/.

#include "zscript/spawnroom/defaults.zs"
#include "zscript/spawnroom/player.zs"

// Weapons: one line per weapon (its sounds are included at the end of SNDINFO.txt)
#include "weapons/rifle/rifle.zs"
