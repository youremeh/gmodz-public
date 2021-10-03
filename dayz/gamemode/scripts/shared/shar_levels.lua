GM.DayZ_XP_LVL = {}
GM.DayZ_XP_LVL[1] = {
    XPLow = 0,
    XPHigh = 150,
    AccuracyInc = 0.02,
    DamageInc = 0.1,
}

GM.DayZ_XP_LVL[2] = {
    XPLow = GM.DayZ_XP_LVL[1].XPHigh,
    XPHigh = 325,
    AccuracyInc = 0.02,
    DamageInc = 0.1,
}

GM.DayZ_XP_LVL[3] = {
    XPLow = GM.DayZ_XP_LVL[2].XPHigh,
    XPHigh = 500,
    AccuracyInc = 0.02,
    DamageInc = 0.1,
}

GM.DayZ_XP_LVL[4] = {
    XPLow = GM.DayZ_XP_LVL[2].XPHigh,
    XPHigh = 1000,
    AccuracyInc = 0.02,
    DamageInc = 0.1,
}

GM.DayZ_XP_LVL[5] = {
    XPLow = GM.DayZ_XP_LVL[2].XPHigh,
    XPHigh = 1400,
    AccuracyInc = 0.02,
    DamageInc = 0.1,
}

GM.DayZ_XP_LVL[6] = {
    XPLow = GM.DayZ_XP_LVL[2].XPHigh,
    XPHigh = 1900,
    AccuracyInc = 0.02,
    DamageInc = 0.1,
}

DayZ_XP_LVL_CAP = table.Count(GM.DayZ_XP_LVL)
DayZ_XP_CAP = GM.DayZ_XP_LVL[DayZ_XP_LVL_CAP].XPHigh