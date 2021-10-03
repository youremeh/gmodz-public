util.AddNetworkString("SV_SendGroup")
util.AddNetworkString("SV_GroupInvite")
util.AddNetworkString("CL_InvitePlayer")
util.AddNetworkString("CL_LeaveGroup")
util.AddNetworkString("CL_AcceptInvite")
util.AddNetworkString("CL_KickPlayer")

function PMETA:GroupKickPlayer(ply)
    if (self == self.Group) then
        ply:LeaveGroup()
        self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You have kicked ", Color(255, 50, 50), ply:Nick(), Color(255, 255, 255), " from the group")
    else
        self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You are not the group leader.")
    end
end
net.Receive("CL_KickPlayer", function(len, ply) ply:GroupKickPlayer(net.ReadEntity()) end)

function PMETA:SendGroupInvite(target)
    if (self.Group and self.Group ~= self) then
        self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You are not the group leader.")
        return false
    end
    if target.GroupInvite then
        self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "This player already has a pending group invite.")
        return false
    end
    if target.Group then
        self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "This player is already in a group.")
        return false
    end
    target:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(50, 255, 50), self:Nick(), Color(255, 255, 255), " has sent you a group invite.")
    self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You have sent ", Color(50, 255, 50), target:Nick(), Color(255, 255, 255), " a group invite.")
    target:SyncGroupInvite(self)
    target.GroupInvite = self
    timer.Simple(25, function() if target:IsValid() then target.GroupInvite = nil end end)
end
net.Receive("CL_InvitePlayer", function(len, ply) ply:SendGroupInvite(net.ReadEntity()) end)

function PMETA:AcceptInvite()
    local groupLeader = self.GroupInvite
    if not groupLeader then self:ChatPrint("There is no pending group invite to accept.") return end
    self:ChatPrint("You have joined "..groupLeader:Nick() .. "'s group.")
    groupLeader:ChatPrint(self:Nick() .. " has joined your group.")
    self.Group = groupLeader
    groupLeader.Group = groupLeader
    groupLeader:SendGroup()
    self.GroupInvite = nil
end
net.Receive("CL_AcceptInvite", function(len, ply) ply:AcceptInvite() end)

function PMETA:updateGroupCount()
    local grpCount = 0
    if not self.Group then return 0 end
    for _, ply in pairs(player.GetAll()) do
        if (ply.Group == self.Group) then grpCount = grpCount + 1 end
    end
    if grpCount <= 1 then
        self.Group = nil
        self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You're alone. The group has been disbanded.")
        self:ResetGroup()
    end
    return grpCount
end

function PMETA:SendGroup()
    local groupSize = self:updateGroupCount()
    local grpPlayers = {}
    net.Start("SV_SendGroup")
    net.WriteUInt(groupSize, 10)
    if (groupSize > 0 and self.Group) then
        for _, ply in pairs(player.GetAll()) do
            if (ply.Group == self.Group) then
                net.WriteEntity(ply)
                table.insert(grpPlayers, ply)
            end
        end
    end
    net.Send(grpPlayers)
end

function PMETA:SyncGroupInvite(groupLeader)
    net.Start("SV_GroupInvite")
    net.WriteEntity(groupLeader)
    net.Send(self)
end

function PMETA:ResetGroup()
    net.Start("SV_SendGroup")
    net.WriteUInt(0, 10)
    net.Send(self)
end

function PMETA:LeaveGroup()
    if (self.Group == NULL or self.Group == nil) then self.Group = nil self:ResetGroup() return end
    if not self.Group then self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You are not in a group.") return end
    if (self == self.Group) then
        for _, ply in pairs(player.GetAll()) do
            if (ply.Group == self) then
                ply.Group = nil
                ply:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "The party leader has disbanded the group.")
                ply:ResetGroup()
            end
        end
    end
    if (self.Group and self.Group:IsValid()) then self.Group:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(50, 255, 50), self:Nick(), Color(255, 255, 255), " has left your group.") end
    local tmpVal = self.Group
    self.Group = nil
    if tmpVal then
        tmpVal:updateGroupCount()
        tmpVal:SendGroup()
    end
    self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You left the group.")
    self:SendGroup()
    self:ResetGroup()
end
net.Receive("CL_LeaveGroup", function(len, ply) ply:LeaveGroup() end)