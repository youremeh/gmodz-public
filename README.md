# Garry's Mod Day-Z Gamemode

Curious what this gamemode looks like and how it works? Join the public server now!  
Connect IP: 74.91.123.81:27015

################################################################  

Created by ?  
Edited by [VanguardianDG](http://github.com/VanguardianDG)  

# Join the [Discord](https://discord.gg/FM49YHT6TS) for updates

# Install
1. https://github.com/FredyH/MySQLOO/releases
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
7. Make a `start.bat` file inside the folder with `srcds.exe` (https://i.imgur.com/ak4nB8g.png)
8. Paste the following in `start.bat` file
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
9. If you make your own collection, replace the `+host_workshop_collection ###` with your own numbers
10. Start Server
