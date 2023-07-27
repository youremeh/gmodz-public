--[[
	{ITEM2GET, TIME2CRAFT, {{REQID1, REQAMT}, {REQID2, REQAMT}}}

	ITEM2GET: The item you are wanting to get when crafting is completed
	TIME2CRAFT: The time in seconds it takes to craft that item

	REQID1: The 1st required item to use in crafting
	REQAMT: The amount of the required item needed to craft

	REQID2: The 2nd required item to use in crafting
	REQAMT: The amount of the required item needed to craft
]]
DayZCraft = {}
DayZCraft["craft_basics"] = {
    {
        28,
        30,
        {
            {
                41,
                15
            }
        }
    },
    {
        29,
        30,
        {
            {
                41,
                30
            }
        }
    },
    {
        30,
        30,
        {
            {
                41,
                15
            }
        }
    },
    {
        31,
        30,
        {
            {
                41,
                30
            }
        }
    },
    {
        32,
        30,
        {
            {
                42,
                15
            }
        }
    },
    {
        33,
        30,
        {
            {
                41,
                30
            }
        }
    },
}

DayZCraft["craft_intermediates"] = {
    {28, 60, {{65, 5}}},
    {29, 90, {{65, 10}}},
    {32, 60, {{66, 5}}},
    {33, 60, {{65, 10}}},
    {30, 30, {{66, 10}}},
    {31, 30, {{65, 10}}},
}

DayZCraft["craft_luxuries"] = {
    {38, 90, {{68, 15}, {69, 15}}}
}