// The game's settings for Horde Hammer. Every Horde Hammer setting is a CVar (listed in the
// library's CVARINFO.txt); this is where a game picks its own defaults, and a host can still change
// any of them in the console (hh_box_cost 500).

class SpawnRoom_Defaults : HH_Defaults {
    override void Fill(HH_SettingsHandler settings) {
        super.Fill(settings);   // the library's defaults first, so you only list what you change

        // The "Zombies" option in the options menu (MENUDEF.txt, CVARINFO.txt): Horde Hammer's
        // zombie, or a random pick of Doom's monsters
        settings.Set("hh_zombie_class", spawnroom_varied_zombies? "HH_VariedZombie": "HH_Zombie");

        // A few more you might change (uncomment one to try it):
        // settings.Set("hh_start_points", "1000");     // points each player starts with
        // settings.Set("hh_box_cost", "950");          // the mystery box
        // settings.Set("hh_auto_start", "0");          // round 1 waits for the map script's HH_StartGame()
    }
}
