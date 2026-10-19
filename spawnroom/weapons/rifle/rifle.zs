// The rifle: an example weapon package. A weapon is a folder of its own, plus its pictures:
//
//     weapons/rifle/rifle.zs          this file: the weapon, its ammo and its wall buy
//     weapons/rifle/sndinfo.txt       its sound names
//     weapons/rifle/sounds/           its sound files (the rifle has none: it uses the IWAD's)
//     sprites/weapons/rifle/          its pictures (SRR?: names are 4 letters, a frame letter, a 0;
//                                     pictures only load from sprites/, so they can't live here)
//
// Files in folders don't load by themselves: ZSCRIPT.zs has an #include line for this file and
// SNDINFO.txt an $include line for sndinfo.txt. To make your own weapon, copy the two folders,
// rename every "Rifle" and the sprite letters (SRR), draw your own frames, and add your two lines.
// The art here is original (0BSD); the sounds are the IWAD's own, so nothing copyrighted ships
// with the template.

// Its ammo: what Max Ammo refills and wall buys sell. Every weapon brings its own.
class SpawnRoom_RifleAmmo : Ammo {
    Default {
        Inventory.Amount 30;
        Inventory.MaxAmount 150;    // the most the player can carry, besides the magazine
    }
}

class SpawnRoom_Rifle : HH_Weapon {
    Default {
        Tag "Rifle";                            // the name on the HUD and in the box
        Weapon.SlotNumber 4;                    // its slot: the box only gives weapons in a slot
        Weapon.AmmoType "SpawnRoom_RifleAmmo";
        Weapon.AmmoGive 60;                     // reserve ammo it comes with
        HH_Weapon.ActiveAmmo 15;                // the magazine
        HH_Weapon.FireFrameRate 3;              // tics per FF frame below (Double Tap takes one off)
        HH_Weapon.ReloadFrameRate 6;            // tics per FR frame below (Speed Cola takes one off)
        HH_Weapon.KeepPartialReload true;       // reloading keeps the rounds left in the magazine
        HH_Weapon.BoxWeight 10;                 // how often the box gives it (Doom's own weapons are 1)
        HH_Weapon.LastStand 0;                  // not a pistol: going down never pulls it out
        XScale 1.0;                             // its pickup picture is drawn at full size
        YScale 1.0;
    }

    // The frames. Each line is: sprite, frame letters, tics, and what happens on that frame.
    // TNT1 A 0 is an invisible frame that takes no time, for decisions ("When..." jumps there if
    // true, otherwise carries on).
    States {
    Spawn:                      // lying on the floor, or in the mystery box
        SRRP A -1;
        Stop;
    Select:                     // being pulled out
        SRRG A 1 A_Raise;
        Loop;
    Deselect:                   // being put away
        TNT1 A 0 ZoomOut;
        SRRG A 1 A_Lower;
        Loop;
    Ready:                      // held: fire, reload and zoom keys work here
        SRRG A 1 ReadyWeapon;
        Loop;
    Fire:
        TNT1 A 0 WhenNoActiveAmmo("Reload");
        TNT1 A 0 A_StartSound("spawnroom/rifle/fire", CHAN_WEAPON);
        // Several things on one frame go in braces. ShootBullets: spread in degrees, damage,
        // bullets; FF makes the frame last FireFrameRate tics (the 1 is only a placeholder)
        SRRF A 1 Bright { ShootBullets(1.5, 20, 1); FF(); }
        SRRF B 1 FF;
        SRRG A 1 FF;
        Goto Ready;
    Reload:
        TNT1 A 0 WhenFullAmmo("Ready");             // the magazine is full already
        TNT1 A 0 WhenNoAmmo("Ready");               // nothing left to load
        TNT1 A 0 ZoomOut;
        SRRG B 1 FR;
        TNT1 A 0 A_StartSound("spawnroom/rifle/out", CHAN_WEAPON);
        SRRG C 1 FR;
        SRRG C 1 FR;
        TNT1 A 0 A_StartSound("spawnroom/rifle/in", CHAN_WEAPON);
        SRRG B 1 FR;
        TNT1 A 0 Reload;                            // moves the rounds into the magazine
        Goto Ready;
    Zoom:                       // the zoom key
        TNT1 A 0 ToggleZoom;    // goes to ZoomIn or ZoomOut
    ZoomIn:
        TNT1 A 0 ZoomIn;
        Goto Ready;
    ZoomOut:
        TNT1 A 0 ZoomOut;
        Goto Ready;
    }
}

// Buying it off the wall: place it in a map on a wall (Ultimate Doom Builder lists it under
// "SpawnRoom"; its number is in MAPINFO.txt). Buying it again sells its ammo for half the price.
class SpawnRoom_RifleWallBuy : HH_WallBuy {
    Default {
        //$Category "SpawnRoom"
        //$Title "Rifle Wall Buy"
        HH_WallBuy.Weapon "SpawnRoom_Rifle";
        HH_WallBuy.Cost 1200;
    }

    States {
    Spawn:
        SRRD A -1 Bright;       // its chalk outline
        Stop;
    }
}
