# Garry's Mod Day-Z Gamemode

################################################################

Created by ?  
Edited by [VanguardianDG](http://github.com/VanguardianDG)

# Install
1. [Download the SQL files](https://github.com/FredyH/MySQLOO/releases) - Both Windows, and Linux **NEED** to do this
2. Extract to `garrysmod\lua\bin\` folder (create if missing)
3. Drag gamemode to `garrysmod\gamemodes\dayz\`
4. Create `workshop.lua` in `garrysmod\lua\autorun\server\`
5. Paste the following in `workshop.lua` file
    ```lua
    resource.AddWorkshop("342908364") -- rp_stalker_new
    resource.AddWorkshop("2633539546") -- [GModZ] Materials
    resource.AddWorkshop("2633508338") -- [GModZ] Weapons
    resource.AddWorkshop("2633540974") -- [GModZ] Models
    resource.AddWorkshop("2633541440") -- [GModZ] Sounds
    ```
6. Use this [collection pack](https://steamcommunity.com/sharedfiles/filedetails/?id=2595587443) or add them to your own
7. Goto your `server.cfg` file and add the following
    ```
    sv_defaultdeployspeed 1
    ```
8. Windows Users - Paste the following into a `.bat` file and makes changes where necessary
    ```
    @echo off
    cls
    echo Starting server
    title srcds.com Watchdog
    :srcds
    start /wait srcds.exe -console -game garrysmod -secure +map rp_stalker_new +maxplayers 32 +gamemode dayz +r_hunkalloclightmaps 0 +host_workshop_collection 2595587443
    echo (%time%) WARNING: srcds closed or crashed, restarting.
    goto srcds
    ```
9. Linux users - Use the following commands and make changes where necessary
    ```
    cd /home/gmodserver
    sudo ./srcds_run -console -game garrysmod -secure +map rp_stalker_new +maxplayers 32 +gamemode dayz +r_hunkalloclightmaps 0 +host_workshop_collection 2595587443
    ```
10. If you made your own collection, replace the `+host_workshop_collection ###` with your own numbers
11. Start Server

################################################################

# Common Questions

Q: Why do I not see zombies or loot spawns?  
A: You need to use the proper map `rp_stalker_new` otherwise it will NOT work
- If you want to use other maps, you will need to add spawns for loot and zombies yourself
1. Go to `dayz/gamemode/init.lua` - Add your map name to the index (don't forget to increase the number)
2. Use the following command in your games console `geteyepos` and copy the coordinates from the server console
3. Go to `dayz/gamemode/scripts/shared/shar_safezone.lua` - Add your map name and coordinates for all 3 options
4. Go to `dayz/gamemode/scripts/server/loot.lua` - Add your map name, and start making loot spawns
5. Go to `dayz/gamemode/scripts/server/playerdb.lua` - Add your map name, and start making player spawns
6. Save the files and restart the server or change map once finished to see changes

Q: Why can I/others walk through props on the map?  
A: You need to make sure you mount the proper game files in `mount.cfg` (https://i.imgur.com/8LAnlnH.png)
- If you're on a VDS, you will need to trnasfer these files manually (https://i.imgur.com/WfqetJ1.png)
- If you bought a Gameserver, you should be fine

Q: Why can't I access the Bank or Shop?
A: Read the above answer.
