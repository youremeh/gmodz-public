function GM:SetupWorldFog()
    render.FogMode(1)
    render.FogStart((IsBinod and 1500) or 100)
    render.FogEnd((IsBinod and 3000) or 1580)
    render.FogMaxDensity(.0)
    render.FogColor(0, 0, 0)
    return true
end