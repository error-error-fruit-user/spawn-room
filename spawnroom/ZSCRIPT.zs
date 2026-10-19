version "5.0.0"

// The game's ZScript. Horde Hammer (horde-hammer.pk3) is loaded before this pk3, so its HH_ classes
// can be used and subclassed here. Every file in zscript/spawnroom/ is included below; weapons are
// drop-in packages (zscript.<weapon> next to this file) and load by themselves.

#include "zscript/spawnroom/defaults.zs"
#include "zscript/spawnroom/player.zs"
