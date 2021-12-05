DayZItems = {}
DayZItems[1] = {
    Name = "Baseball Bat",
    Desc = "Do you think you could hit a home run?",
    Model = "models/weapons/w_basebat.mdl",
    Weight = 2,
    LootType = "Basic",
    Price = 50,
    Credits = 1,
    SpawnChance = 10,
    SpawnOffset = Vector(0, 0, 0),
    Weapon = "weapon_bat_dayz",
    CanBeSold = true,
}

DayZItems[2] = {
    Name = "Airdrop Grenade",
    Desc = "A grenade that summons a helicopter to drop some supplies",
    Model = "models/weapons/w_eq_fraggrenade_thrown.mdl",
    LootType = "Weapon",
    Weight = 0.8,
    SpawnChance = 1,
    Credits = 10,
    useFunc = function(ply, item)
        if not ply:IsValid() then return true end
        GAMEMODE.UseAirDrop(ply)
        return true
    end
}

DayZItems[3] = {
    Name = "Crowbar",
    Desc = "Somebody... Take his crowbar",
    Model = "models/weapons/w_crowbar.mdl",
    Weight = 5,
    LootType = "Basic",
    Price = 50,
    Credits = 20,
    SpawnChance = 25,
    SpawnOffset = Vector(0, 0, 0),
    Weapon = "weapon_crowbar_dayz",
    CanBeSold = true,
}

DayZItems[4] = {
    Name = "Soda Can",
    Desc = "It's probably something like Pipsi",
    Model = "models/props_junk/PopCan01a.mdl",
    Weight = 0.03,
    LootType = "Basic",
    Price = 5,
    CanBeSold = true,
    Credits = 1,
    SpawnChance = 60,
    SpawnOffset = Vector(0, 0, 6),
    useFunc = function(ply, item)
        ply:Drink(15)
    end
}

DayZItems[5] = {
    Name = "Can'o'beans",
    Desc = "Bush's Best Beans",
    Model = "models/props_junk/garbage_metalcan001a.mdl",
    Weight = 1,
    Price = 7,
    Credits = 1,
    LootType = "Basic",
    CanBeSold = true,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 6),
    useFunc = function(ply, item)
        ply:Eat(12)
    end
}

DayZItems[6] = {
    Name = "Beer",
    Desc = "Does not get you drunk",
    Model = "models/props_junk/garbage_glassbottle001a.mdl",
    Weight = 0.78,
    LootType = "Basic",
    Price = 20,
    CanBeSold = true,
    Credits = 1,
    SpawnChance = 60,
    SpawnOffset = Vector(0, 0, 9),
    useFunc = function(ply, item)
        ply:Drink(13)
    end
}

DayZItems[7] = {
    Name = "Old Milk",
    Desc = "Kind of chunky. Just the way I like it",
    Model = "models/props_junk/garbage_milkcarton002a.mdl",
    Weight = 0.06,
    LootType = "Basic",
    Price = 5,
    Credits = 1,
    CanBeSold = true,
    SpawnChance = 40,
    SpawnOffset = Vector(0, 0, 8),
    useFunc = function(ply, item)
        ply:Drink(8)
    end
}

DayZItems[8] = {
    Name = "Stale Take-away",
    Desc = "I'm pretty sure this expired 2 years ago",
    Model = "models/props_junk/garbage_takeoutcarton001a.mdl",
    Weight = 1,
    LootType = "Basic",
    Price = 8,
    CanBeSold = true,
    SpawnChance = 90,
    SpawnOffset = Vector(0, 0, 15),
    useFunc = function(ply, item)
        ply:Eat(8)
    end
}

DayZItems[9] = {
    Name = "Water Melon",
    Desc = "Well at least something tastes good",
    Model = "models/props_junk/watermelon01.mdl",
    Weight = 5,
    Price = 10,
    CanBeSold = true,
    Credits = 1,
    LootType = "Basic",
    SpawnChance = 55,
    SpawnOffset = Vector(0, 0, 7),
    useFunc = function(ply, item)
        ply:Eat(10)
        ply:Drink(12)
    end
}

DayZItems[10] = {
    Name = "Bunch'o'Bananas",
    Desc = "Anyone wanna make banana bread?",
    Model = "models/props/cs_italy/bananna_bunch.mdl",
    Weight = 1,
    LootType = "Basic",
    Price = 6,
    CanBeSold = true,
    Credits = 1,
    SpawnChance = 57,
    SpawnOffset = Vector(0, 0, 2),
    useFunc = function(ply, item)
        ply:Eat(15)
    end
}

DayZItems[11] = {
    Name = "Orange",
    Desc = "Orange you glad I didn't say banana!?",
    Model = "models/props/cs_italy/orange.mdl",
    Weight = 0.30,
    LootType = "Basic",
    CanBeSold = true,
    Price = 4,
    Credits = 1,
    SpawnChance = 65,
    SpawnOffset = Vector(0, 0, 3),
    useFunc = function(ply, item)
        ply:Eat(9)
    end
}

DayZItems[12] = {
    Name = "Fish",
    Desc = "Smells like my ex girlfriend",
    Model = "models/props/cs_militia/fishriver01.mdl",
    Weight = 2,
    LootType = "Basic",
    Price = 5,
    CanBeSold = true,
    SpawnChance = 20,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    useFunc = function(ply, item)
        ply:Eat(10)
    end
}

DayZItems[13] = {
    Name = "Painkillers",
    Desc = "PILLS HERE!!",
    Model = "models/w_models/weapons/w_eq_painpills.mdl",
    Weight = 0.08,
    LootType = "Basic",
    Credits = 1,
    Price = 25,
    CanBeSold = true,
    SpawnChance = 40,
    SpawnOffset = Vector(0, 0, 0),
    useFunc = function(ply, item)
        ply:Heal(15, true)
    end
}

DayZItems[14] = {
    Name = "Bandages",
    Desc = "Got a bandage here!",
    Model = "models/w_models/weapons/w_eq_medkit.mdl",
    Weight = 0.5,
    LootType = "Basic",
    Price = 50,
    CanBeSold = true,
    Price = 80,
    SpawnChance = 30,
    SpawnOffset = Vector(0, 0, 0),
    useFunc = function(ply, item)
        ply:Heal(35, false)
    end
}

DayZItems[15] = {
    Name = "Flashlight",
    Desc = "Provides light in a time of need",
    Model = "models/raviool/flashlight.mdl",
    Weight = 0.32,
    Price = 10,
    CanBeSold = true,
    CamOffset = 0.25,
    SpawnChance = -1,
    SpawnOffset = Vector(0, 0, 0),
    SpawnAngle = Angle(0, 0, 0),
    LootType = "Weapon",
}

DayZItems[16] = {
    Name = "Cheetah",
    Desc = "Sprint for twice as far and regenerate twice as fast",
    Model = "models/props_junk/shoe001a.mdl",
    Weight = 0,
    Credits = 2,
    LootType = "Perk",
    CamOffset = 0.4,
    SpawnChance = 0,
    SpawnOffset = Vector(0, 0, 3.5),
    useFunc = function(ply, item)
        ply:GivePerk(1)
    end
}

DayZItems[17] = {
    Name = "Strong Back",
    Desc = "Double your inventory weight",
    Model = "models/Fallout 3/Campish_Pack.mdl",
    Weight = 0,
    Credits = 5,
    LootType = "Perk",
    CamOffset = 1.8,
    SpawnChance = 0,
    SpawnOffset = Vector(0, 0, 3.5),
    useFunc = function(ply, item)
        ply:GivePerk(2)
    end
}

DayZItems[18] = {
    Name = "Fresh Man's Luck",
    Desc = "Have a chance to spawn with extra loot items",
    Model = "models/items/item_item_crate.mdl",
    Weight = 0,
    Credits = 3,
    CamOffset = 0.2,
    LootType = "Perk",
    SpawnChance = 2,
    SpawnOffset = Vector(0, 0, 3.5),
    useFunc = function(ply, item)
        ply:GivePerk(3)
    end
}

DayZItems[19] = {
    Name = "Extra Items",
    Desc = "Spawn with 2x the regular loot",
    Model = "models/items/item_item_crate.mdl",
    Weight = 0,
    Credits = 5,
    CamOffset = 0.8,
    LootType = "Perk",
    SpawnChance = 0,
    SpawnOffset = Vector(0, 0, 3.5),
    useFunc = function(ply, item)
        ply:GivePerk(4)
    end
}

DayZItems[20] = {
    Name = "Zombie Slayer",
    Desc = "Do 50% more damage to Zombies",
    Model = "models/zombie/zm_classic_01.mdl",
    Weight = 0,
    Credits = 1,
    LootType = "Perk",
    CamOffset = 3,
    SpawnChance = 0,
    SpawnOffset = Vector(0, 0, 3.5),
    useFunc = function(ply, item)
        ply:GivePerk(5)
    end
}

DayZItems[21] = {
    Name = "Ghillie Suit",
    Desc = "Equips a Ghillie suit",
    Model = "models/props/cs_militia/footlocker01_closed.mdl",
    Weight = 3,
    Price = 200,
    CanBeSold = true,
    SpawnChance = 10,
    SpawnOffset = Vector(0, 0, 10),
    CamOffset = 1.5,
    SpawnAngle = Angle(0, 0, 0),
    LootType = "Weapon",
    useFunc = function(ply, item)
        ply:setCharModel(99, ply.clothes, ply.gender)
    end
}

DayZItems[22] = {
    Name = "Binoculars",
    Desc = "Spy on people from a distance",
    Model = "models/weapons/W_binoculars.mdl",
    Weight = 3,
    LootType = "Weapon",
    CanBeSold = true,
    Price = 25,
    CamOffset = 0.5,
    SpawnChance = 0,
    SpawnOffset = Vector(0, 0, 0),
    Weapon = "weapon_binoculars_1",
}

DayZItems[23] = {
    Name = "Jerry can",
    Desc = "Used to fuel vehicles",
    Model = "models/props_junk/gascan001a.mdl",
    Price = 50,
    Weight = 10,
    CanBeSold = true,
    LootType = "Basic",
    SpawnChance = 0,
    SpawnOffset = Vector(0, 0, 14),
    useFunc = function(ply, item)
        if SERVER then
            local tr = ply:GetEyeTrace()
            if (tr.Entity and tr.Entity:IsValid() and tr.Entity:IsVehicle()) then
                if (tr.Entity:GetNWInt("fuel") < 100) then
                    if (tr.Entity:GetNWInt("fuel") + 40 <= 100) then
                        tr.Entity:SetNWInt("fuel", tr.Entity:GetNWInt("fuel") + 40)
                        ply:ChatPrint("Refueled for 40% of its tank capacity")
                    else
                        tr.Entity:SetNWInt("fuel", 100)
                        ply:ChatPrint("The fuel tank is now full")
                    end
                    ply:EmitSound("ambient/water/water_spray1.wav", 100, 100)
                else
                    ply:ChatPrint("The fuel tank is already full")
                    return true
                end
            else
                ply:ChatPrint("You are not facing a vehicle")
                return true
            end
        end
    end
}

DayZItems[24] = {
    Name = "Large Backpack",
    Desc = "Doubles your inventory space (does not stack)",
    Model = "models/Fallout 3/Campish_Pack.mdl",
    Weight = 0,
    LootType = "Basic",
    CanBeSold = true,
    Price = 750,
    CamOffset = 2,
    SpawnChance = 0,
    SpawnOffset = Vector(0, 0, 5),
    SpawnAngle = Angle(0, 90, 0),
}

DayZItems[25] = {
    Name = "Repair Wrench",
    Desc = "Used to repair vehicles",
    Model = "models/props_c17/tools_wrench01a.mdl",
    Price = 25,
    Weight = 1,
    CanBeSold = true,
    LootType = "Basic",
    CamOffset = 0.5,
    SpawnChance = 0,
    SpawnOffset = Vector(0, 0, 2),
    useFunc = function(ply, item)
        if SERVER then
            local tr = ply:GetEyeTrace()
            if not ply:HasSkill(13) then ply:ChatPrint("You do not have the skill to use this item") return true end
            local repairAmount = 20
            if ply:HasSkill(14) then
                repairAmount = 40
            end
            if (tr.Entity and tr.Entity:IsValid() and tr.Entity:IsVehicle()) then
                if (tr.Entity:Health() < 100) then
                    if (tr.Entity:Health() + repairAmount <= 100) then
                        tr.Entity:SetHealth(tr.Entity:Health() + repairAmount)
                        ply:ChatPrint("Repaired the vehicle for "..repairAmount.."% of its armor")
                    else
                        tr.Entity:SetHealth(100)
                        ply:ChatPrint("The vehicle is now fully repaired")
                    end
                    ply:EmitSound("physics/metal/metal_barrel_impact_hard1.wav", 100, 100)
                else
                    ply:ChatPrint("The vehicle is already fully repaired")
                    return true
                end
            else
                ply:ChatPrint("You are not facing a vehicle")
                return true
            end
        end
    end
}

DayZItems[26] = {
    Name = "Water Bottle",
    Desc = "Not bath water",
    Model = "models/props/cs_office/water_bottle.mdl",
    Weight = 0.02,
    CanBeSold = true,
    LootType = "Basic",
    Price = 10,
    SpawnChance = 90,
    SpawnOffset = Vector(0, 0, 3.5),
    useFunc = function(ply, item)
        ply:Drink(35)
    end
}

DayZItems[27] = {
    Name = "Market Table A",
    Desc = "Place this table and press F3 on it to sell items",
    Model = "models/props/cs_italy/it_mkt_table1.mdl",
    Weight = 0,
    LootType = "Shop",
    CamOffset = 3,
    Price = 100,
    SpawnChance = 0,
    SpawnOffset = Vector(0, 0, 0),
    Placeable = true,
    NoGlow = true,
    Shopstall = true,
    Health = 75,
}

DayZItems[28] = {
    Name = "Small Wood Barricade",
    Desc = "A weak wall with a medium amount of cover",
    Model = "models/props_wasteland/wood_fence02a.mdl",
    Weight = 1,
    LootType = "Barricade",
    CamOffset = 3.2,
    Price = 125,
    Credits = 1,
    SpawnChance = 0,
    SpawnOffset = Vector(0, 0, 60),
    Placeable = true,
    NoGlow = true,
    Barricade = true,
    Health = 75,
}

DayZItems[29] = {
    Name = "Large Wood Barricade",
    Desc = "A weak wall with a large amount of cover",
    Model = "models/props_wasteland/wood_fence01a.mdl",
    Weight = 1,
    LootType = "Barricade",
    CamOffset = 4,
    Price = 150,
    Credits = 1,
    SpawnChance = 0,
    SpawnOffset = Vector(0, 0, 60),
    Placeable = true,
    NoGlow = true,
    Barricade = true,
    Health = 100,
}

DayZItems[30] = {
    Name = "Small Ladder",
    Desc = "A ladder used for climbing",
    Model = "models/props_c17/metalladder001.mdl",
    Weight = 2,
    LootType = "Barricade",
    CamOffset = 6,
    Price = 100,
    SpawnChance = 0,
    SpawnOffset = Vector(0, 0, 0),
    Placeable = true,
    NoGlow = true,
    Barricade = true,
    Health = 100,
    PlaceFunction = function(ply, ent, ItemID)
        local ladder = ents.Create("func_useableladder")
        ladder:SetPos(ent:GetPos() + ent:GetAngles():Forward() * -25)
        ladder:SetAngles(ent:GetAngles())
        ladder:SetKeyValue("point0", tostring(ladder:GetPos()))
        ladder:SetKeyValue("point1", tostring(ladder:GetPos() + Vector(0, 0, 128)))
        ladder:Spawn()
        ladder:SetParent(ent)
    end
}

DayZItems[31] = {
    Name = "Wood Ladder",
    Desc = "A ladder used for climbing",
    Model = "models/props/CS_militia/ladderwood.mdl",
    Weight = 4,
    LootType = "Barricade",
    CamOffset = 12,
    Price = 200,
    SpawnChance = 0,
    SpawnOffset = Vector(0, 0, 0),
    Placeable = true,
    NoGlow = true,
    Barricade = true,
    Health = 100,
    PlaceFunction = function(ply, ent, ItemID)
        local ladder = ents.Create("func_useableladder")
        ladder:SetPos(ent:GetPos() + ent:GetAngles():Forward() * -25)
        ladder:SetAngles(ent:GetAngles())
        ladder:SetKeyValue("point0", tostring(ladder:GetPos()))
        ladder:SetKeyValue("point1", tostring(ladder:GetPos() + Vector(0, 0, 256)))
        ladder:Spawn()
        ladder:SetParent(ent)
    end
}

DayZItems[32] = {
    Name = "Metal Fence",
    Desc = "A strong wall with a minimal amount of cover",
    Model = "models/props_c17/fence01a.mdl",
    Weight = 1,
    LootType = "Barricade",
    CamOffset = 3.6,
    Price = 10,
    SpawnChance = 0,
    SpawnOffset = Vector(0, 0, 55),
    Placeable = true,
    NoGlow = true,
    Barricade = true,
    Health = 200,
}

DayZItems[33] = {
    Name = "Wooden Crate",
    Desc = "A wooden crate for cover or standing on",
    Model = "models/props/de_nuke/crate_extrasmall.mdl",
    Weight = 1,
    LootType = "Barricade",
    CamOffset = 2.5,
    Price = 100,
    SpawnChance = 0,
    SpawnOffset = Vector(0, 0, 0),
    Placeable = true,
    NoGlow = true,
    Barricade = true,
    Health = 125,
}

DayZItems[34] = {
    Name = "Market Table B",
    Desc = "Place this table and press F3 on it to sell items",
    Model = "models/props/CS_militia/table_shed.mdl",
    Weight = 1,
    LootType = "Shop",
    CamOffset = 3,
    Price = 100,
    SpawnChance = 0,
    SpawnOffset = Vector(0, 0, 0),
    Placeable = true,
    NoGlow = true,
    Shopstall = true,
    Health = 75,
}

DayZItems[35] = {
    Name = "Plant Pot",
    Desc = "Plant seeds to grow plants",
    Model = "models/props_c17/pottery09a.mdl",
    Weight = 1,
    LootType = "Shop",
    CamOffset = 1,
    Price = 75,
    SpawnChance = 0,
    SpawnOffset = Vector(0, 0, 0),
    Placeable = true,
    NoGlow = true,
    Pot = true,
    Health = 120,
}

DayZItems[36] = {
    Name = "AK-47",
    Desc = "An automatic rifle that takes Rifle Ammo",
    Model = "models/weapons/w_rif_ak47.mdl",
    Weight = 6.83,
    CanBeSold = true,
    Price = 2700,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_ak47",
}

DayZItems[37] = {
    Name = "AUG",
    Desc = "An automatic rifle that takes Rifle Ammo",
    Model = "models/weapons/w_rif_aug.mdl",
    Weight = 13.22,
    CanBeSold = true,
    Price = 3150,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_aug",
}

DayZItems[38] = {
    Name = "AWP",
    Desc = "A powerful bolt-action sniper rifle that takes Sniper Ammo",
    Model = "models/weapons/w_snip_awp.mdl",
    Weight = 13.22,
    CanBeSold = true,
    Price = 5000,
    SpawnChance = 10,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_awp",
}

DayZItems[39] = {
    Name = "Deagle",
    Desc = "A powerful semi-auto pistol that takes Pistol Ammo",
    Model = "models/weapons/w_pist_deagle.mdl",
    Weight = 4.5,
    CanBeSold = true,
    Price = 700,
    SpawnChance = 25,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_deagle",
}

DayZItems[40] = {
    Name = "Dual Berettas",
    Desc = "2 semi-auto pistols that take Pistol Ammo",
    Model = "models/weapons/w_pist_elite.mdl",
    Weight = 2.13,
    CanBeSold = true,
    Price = 1500,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_dualberettas",
}

DayZItems[41] = {
    Name = "Famas",
    Desc = "An automatic rifle that takes Rifle Ammo",
    Model = "models/weapons/w_rif_famas.mdl",
    Weight = 7.95,
    CanBeSold = true,
    Price = 2250,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_famas",
}

DayZItems[42] = {
    Name = "FiveSeven",
    Desc = "A semi-auto pistol that takes Pistol Ammo",
    Model = "models/weapons/w_pist_fiveseven.mdl",
    Weight = 1.60,
    CanBeSold = true,
    Price = 500,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_fiveseven",
}

DayZItems[43] = {
    Name = "G3SG1",
    Desc = "An automatic sniper that takes Sniper Ammo",
    Model = "models/weapons/w_snip_g3sg1.mdl",
    Weight = 9.70,
    CanBeSold = true,
    Price = 5000,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_g3sg1",
}

DayZItems[44] = {
    Name = "Galil",
    Desc = "An automatic rifle that takes Rifle Ammo",
    Model = "models/weapons/w_rif_galil.mdl",
    Weight = 9.59,
    CanBeSold = true,
    Price = 2000,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_galil",
}

DayZItems[45] = {
    Name = "Glock",
    Desc = "A semi-auto pistol that takes Pistol Ammo",
    Model = "models/weapons/w_pist_glock18.mdl",
    Weight = 0.71,
    CanBeSold = true,
    Price = 200,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_glock",
}

DayZItems[46] = {
    Name = "M3 Super 90",
    Desc = "A powerful pump shotgun that takes Shotgun Ammo",
    Model = "models/weapons/w_shot_m3super90.mdl",
    Weight = 7.20,
    CanBeSold = true,
    Price = 1200,
    SpawnChance = 30,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_m3",
}

DayZItems[47] = {
    Name = "M4A1",
    Desc = "An automatic rifle that takes Rifle Ammo",
    Model = "models/weapons/w_rif_m4a1.mdl",
    Weight = 7.46,
    CanBeSold = true,
    Price = 3100,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_m4a1",
}

DayZItems[48] = {
    Name = "M249",
    Desc = "An automatic rifle that takes Rifle Ammo",
    Model = "models/weapons/w_mach_m249para.mdl",
    Weight = 17,
    CanBeSold = true,
    Price = 5200,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_m249",
}

DayZItems[49] = {
    Name = "Mac-10",
    Desc = "An automatic SMG that takes SMG Ammo",
    Model = "models/weapons/w_smg_mac10.mdl",
    Weight = 6.26,
    CanBeSold = true,
    Price = 1050,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_mac10",
}

DayZItems[50] = {
    Name = "MP5",
    Desc = "An automatic SMG that takes SMG Ammo",
    Model = "models/weapons/w_smg_mp5.mdl",
    Weight = 5.59,
    CanBeSold = true,
    Price = 1500,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_mp5",
}

DayZItems[51] = {
    Name = "P90",
    Desc = "An automatic SMG that takes SMG Ammo",
    Model = "models/weapons/w_smg_p90.mdl",
    Weight = 5.51,
    CanBeSold = true,
    Price = 2350,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_p90",
}

DayZItems[52] = {
    Name = "P228",
    Desc = "A semi-auto pistol that takes Pistol Ammo",
    Model = "models/weapons/w_pist_p228.mdl",
    Weight = 1.81,
    CanBeSold = true,
    Price = 300,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_p228",
}

DayZItems[53] = {
    Name = "Scout",
    Desc = "A bolt action sniper that takes Sniper Ammo",
    Model = "models/weapons/w_snip_scout.mdl",
    Weight = 14.48,
    CanBeSold = true,
    Price = 1700,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_scout",
}

DayZItems[54] = {
    Name = "SG550",
    Desc = "An sutomatic sniper that takes Sniper Ammo",
    Model = "models/weapons/w_snip_sg550.mdl",
    Weight = 3.72,
    CanBeSold = true,
    Price = 5000,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_sg550",
}

DayZItems[55] = {
    Name = "SG552",
    Desc = "An automatic rifle that takes Rifle Ammo",
    Model = "models/weapons/w_rif_sg552.mdl",
    Weight = 8.92,
    CanBeSold = true,
    Price = 2750,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_sg552",
}

DayZItems[56] = {
    Name = "TMP",
    Desc = "An automatic SMG that takes SMG Ammo",
    Model = "models/weapons/w_smg_tmp.mdl",
    Weight = 2.91,
    CanBeSold = true,
    Price = 1250,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_tmp",
}

DayZItems[57] = {
    Name = "UMP-45",
    Desc = "An automatic SMG that takes SMG Ammo",
    Model = "models/weapons/w_smg_ump45.mdl",
    Weight = 4.63,
    CanBeSold = true,
    Price = 1200,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_ump",
}

DayZItems[58] = {
    Name = "USP-45",
    Desc = "A semi-auto pistol that takes Pistol Ammo",
    Model = "models/weapons/w_pist_usp.mdl",
    Weight = 1.65,
    CanBeSold = true,
    Price = 200,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_usp",
}

DayZItems[59] = {
    Name = "XM1014",
    Desc = "A semi-auto shotgun that takes Shotgun Ammo",
    Model = "models/weapons/w_shot_xm1014.mdl",
    Weight = 8.42,
    CanBeSold = true,
    Price = 2000,
    SpawnChance = 45,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Weapon",
    Gun = true,
    Weapon = "lite_xm1014",
}

DayZItems[60] = {
    Name = "30x Rifle Ammo",
    Desc = "A box of rifle ammo",
    Model = "models/Items/BoxMRounds.mdl",
    Weight = 2.5,
    CanBeSold = true,
    Price = 60,
    SpawnChance = 80,
    SpawnOffset = Vector(0, 0, 5),
    LootType = "Weapon",
    ClipSize = 1,
    AmmoType = "ar2",
    useFunc = function (ply, Amount, AmmoType)
        ply:GiveAmmo(30, "ar2")
    end
}

DayZItems[61] = {
    Name = "30x SMG Ammo",
    Desc = "A box of smg ammo",
    Model = "models/Items/BoxSRounds.mdl",
    Weight = 2.5,
    CanBeSold = true,
    Price = 50,
    SpawnChance = 80,
    SpawnOffset = Vector(0, 0, 5),
    LootType = "Weapon",
    ClipSize = 1,
    AmmoType = "smg1",
    useFunc = function (ply, Amount, AmmoType)
        ply:GiveAmmo(30, "smg1")
    end
}

DayZItems[62] = {
    Name = "5x Sniper Ammo",
    Desc = "A box of sniper ammo",
    Model = "models/Items/combine_rifle_cartridge01.mdl",
    Weight = 2.9,
    CanBeSold = true,
    Price = 125,
    SpawnChance = 80,
    SpawnOffset = Vector(0, 0, 5),
    LootType = "Weapon",
    ClipSize = 1,
    AmmoType = "SniperRound",
    useFunc = function (ply, Amount, AmmoType)
        ply:GiveAmmo(5, "SniperRound")
    end
}

DayZItems[63] = {
    Name = "20x Pistol Ammo",
    Desc = "A box of pistol ammo",
    Model = "models/Items/357ammo.mdl",
    Weight = 1.8,
    CanBeSold = true,
    Price = 50,
    SpawnChance = 80,
    SpawnOffset = Vector(0, 0, 5),
    LootType = "Weapon",
    ClipSize = 1,
    AmmoType = "pistol",
    useFunc = function (ply, Amount, AmmoType)
        ply:GiveAmmo(20, "Pistol")
    end
}

DayZItems[64] = {
    Name = "10x Shotgun Shells",
    Desc = "A box of shotgun shells",
    Model = "models/Items/BoxBuckshot.mdl",
    Weight = 2.7,
    CanBeSold = true,
    Price = 65,
    SpawnChance = 80,
    SpawnOffset = Vector(0, 0, 5),
    LootType = "Weapon",
    ClipSize = 1,
    AmmoType = "buckshot",
    useFunc = function (ply, Amount, AmmoType)
        ply:GiveAmmo(10, "buckshot")
    end
}

DayZItems[65] = {
    Name = "Wood",
    Desc = "Used for crafting multiple items",
    Model = "models/Gibs/wood_gib01d.mdl",
    Weight = 1.5,
    CanBeSold = true,
    Price = 50,
    SpawnChance = 5,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Basic",
}

DayZItems[66] = {
    Name = "Scrap Metal",
    Desc = "Used for crafting multiple items",
    Model = "models/props_c17/TrapPropeller_Lever.mdl",
    Weight = 1.0,
    CanBeSold = true,
    Price = 75,
    SpawnChance = 5,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Basic",
}

DayZItems[67] = {
    Name = "Gun Powder",
    Desc = "Used to craft any type of ammo",
    Model = "models/props_junk/metal_paintcan001a.mdl",
    Weight = 0.5,
    CanBeSold = true,
    Price = 100,
    SpawnChance = 5,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Basic",
}

DayZItems[68] = {
    Name = "Weapon Part A",
    Desc = "Used to craft weapons",
    Model = "models/weapons/w_eq_eholster_elite.mdl",
    Weight = 1.8,
    CanBeSold = true,
    Price = 250,
    SpawnChance = 5,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
    LootType = "Basic",
}

DayZItems[69] = {
    Name = "Weapon Part B",
    Desc = "Used to craft high tier weapons",
    Model = "models/weapons/w_defuser.mdl",
    LootType = "Basic",
    Weight = 1.6,
    CanBeSold = true,
    Price = 300,
    SpawnChance = 5,
    SpawnOffset = Vector(0, 0, 1),
    SpawnAngle = Angle(0, 0, 90),
}

DayZItems[70] = {
    Name = "Mystery Box",
    Desc = "Does not contain teddy bears that we know of",
    Model = "models/items/item_item_crate.mdl",
    Weight = 2,
    LootType = "Basic",
    CanBeSold = true,
    CamOffset = 2,
    Credits = 5,
    SpawnChance = 0,
    SpawnOffset = Vector(0,0,5),
    SpawnAngle = Angle(0,90,0),
    useFunc = function(ply,item)
        local lootTable = {1,2,3,14,21,24,28,29,30,31,32,33,36,37,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64}
        local giveItem = table.Random(lootTable)
        local amount = math.random(1,2)
        local weightLimit = ply:getWeightLimit()
        if (ply.WeightCur + (DayZItems[giveItem].Weight * amount) > weightLimit) then
            ply:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You would have got ", Color(50, 255, 50), amount, Color(255, 255, 255), 'x ', Color(50, 255, 50), DayZItems[giveItem].Name, Color(255, 255, 255), ' but you are overweight')
            return true
        end
        ply:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You unboxed ", Color(50, 255, 50), amount, Color(255, 255, 255), 'x ', Color(50, 255, 50), DayZItems[giveItem].Name)
        ply:GiveItem(giveItem, amount)
    end
}