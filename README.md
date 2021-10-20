# Garry's Mod Day-Z Gamemode

Curious what this gamemode looks like and how it works? Join the public server now!  
Connect IP: 74.91.123.81:27015

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
    resource.AddWorkshop("1092128495") -- Rebirth Content 1
    resource.AddWorkshop("165772389") -- rp_stalker Materials Fix
    resource.AddWorkshop("307324474") -- DayZ Content(NOT A GAMEMODE)
    resource.AddWorkshop("129589968") -- RP_Stalker (Discontinued)
    resource.AddWorkshop("536338229") -- Lite Weapons Pack
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

Q: Why can I/others walk through props on the map?  
A: You need to make sure you mount the proper game files in `mount.cfg` (https://i.imgur.com/8LAnlnH.png)
- If you're on a VDS, you will need to trnasfer these files manually (https://i.imgur.com/WfqetJ1.png)
- If you bought a Gameserver, you should be fine
