# THIS GAMEMODE IS NO LONGER SUPPORTED BY ME

IF YOU HAVE ANY QUESTIONS ABOUT THIS GAMEMODE OR ITS ADDONS, I WILL NOT HELP YOU. YOU WILL NEED TO FIGURE IT OUT YOURSELF

# Garry's Mod Day-Z Gamemode

Edited by [youremeh](http://github.com/youremeh)

# Install Instructions
1. [Download the SQL files](https://github.com/FredyH/MySQLOO/releases) - Both Windows, and Linux users **NEED** to do this
2. Extract the sql files to `garrysmod\lua\bin\` folder (you must create this folder if missing)
3. Drag the `dayz` gamemode into the `garrysmod\gamemodes\` folder
4. Create a `workshop.lua` file in `garrysmod\lua\autorun\server\`
5. Paste the following inside the `workshop.lua` file
    ```lua
    resource.AddWorkshop("342908364") -- rp_stalker_new
    resource.AddWorkshop("2633539546") -- [GModZ] Materials
    resource.AddWorkshop("2633508338") -- [GModZ] Weapons
    resource.AddWorkshop("2633540974") -- [GModZ] Models
    resource.AddWorkshop("2633541440") -- [GModZ] Sounds
    resource.AddWorkshop("2695585209") -- [GModZ] Playermodels
    resource.AddWorkshop("128093075") -- M9K Small Arms pack
    resource.AddWorkshop("128091208") -- M9K Heavy Weapons
    resource.AddWorkshop("128089118") -- M9K Assault Rifles
    resource.AddWorkshop("144982052") -- M9K Specialties
    ```
6. Use this [collection pack](https://steamcommunity.com/sharedfiles/filedetails/?id=2595587443) or add them to your own
7. Goto `garrysmod\cfg\` and open `server.cfg` and add the following (this prevents instant weapon deploy)
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
10. If you made your own collection, replace the `+host_workshop_collection` with your own numbers
11. Start Server

# Common Questions

#### Q: Why do I not see zombies or loot spawns?
A: You need to use the proper map `rp_stalker_new` otherwise it will NOT work

#### Q: Can I use other maps?
A: Yes, but you will need to do a bunch of code changes (see below)
1. Go to `dayz/gamemode/init.lua` - Add your map name to the index (don't forget to increase the number)
2. Use the following command using the in-game console `geteyepos` and copy the coordinates from the servers console
3. Go to `dayz/gamemode/scripts/shared/shar_safezone.lua` - Add your map name and coordinates for all 3 options (again using `geteyepos`)
4. Go to `dayz/gamemode/scripts/server/loot.lua` - Add your map name, and start making loot spawns
5. Go to `dayz/gamemode/scripts/server/playerdb.lua` - Add your map name, and start making player spawns
6. Save the files and restart the server or change map once finished to see changes

#### Q: Why can I/others walk through props on the map?  
A: You need to make sure you mount the proper game files in `mount.cfg`  
![](https://i.imgur.com/8LAnlnH.png)
- If you're on a VDS, you will need to transfer these files manually  
![](https://i.imgur.com/WfqetJ1.png)
- If you purchased a Gameserver, you should be fine. If nothing works, contact them to mount it themselves

#### Q: Why can't I access the Bank or Shop?  
A: Read the above answer.

#### Q: Can you send me the mount files above?  
A: No. You will have to download the games (CS:S, HL2, TF2) and find the respective folders and do it yourself. Or you can do a simple google search and find a website that hosts them.

#### Q: Can you make me a server?  
A: No.
