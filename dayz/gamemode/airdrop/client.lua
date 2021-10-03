local function StartAirdrop()
    net.Start("airdrop_start")
    net.SendToServer()
end
net.Receive("airdrop_no", function(l) Derma_Message("A helicopter is already in the airspace. Please wait...", "Airdrop Denied", "Ok") end)
net.Receive("airdrop_confirm", function(l) Derma_Query([[You're about to throw an Airdrop grenade. Are you sure you want to do this? (Everyone will be notified)]], "Airdrop Confirmation", "Yes! Throw the damn thing already", StartAirdrop, "On second thought, maybe not") end)