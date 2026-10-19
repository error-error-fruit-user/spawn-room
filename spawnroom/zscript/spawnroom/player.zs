// The player. Horde Hammer works with any player class; this one starts from the library's
// HH_Player (Doom's marine), so it has Doom's pistol and fist and Doom's weapon slots. The box gives
// weapons from the player's slots, so whatever you put in them is the box's roster.

class SpawnRoom_Player : HH_Player {
    Default {
        Player.DisplayName "Survivor";
        // To start with your own weapons instead of Doom's pistol, clear the inherited items and
        // list yours (a weapon and its ammo):
        // Player.StartItem "SpawnRoom_Rifle";
        // Player.StartItem "SpawnRoom_RifleAmmo", 30;
        // and the slots, if you want to choose them all yourself (a weapon's own Weapon.SlotNumber
        // also puts it in a slot):
        // Player.WeaponSlot 1, "Fist";
        // Player.WeaponSlot 2, "Pistol", "SpawnRoom_Rifle";
    }
}
