include('shared.lua')
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Draw()
    for _, ply in pairs(player.GetAll()) do
        if (ply:IsValid() and ply:Alive()) then
            if ply == LocalPlayer() and LocalPlayer().ThirdPerson then
                local BoneIndex = ply:LookupBone("ValveBiped.Bip01_Spine4");
                local BonePos, BoneAng = ply:GetBonePosition(BoneIndex);
                BonePos = BonePos + (BoneAng:Forward() * -26) + (BoneAng:Right() * 2) + (BoneAng:Up() * -2);
                BoneAng = Angle(0, BoneAng.y + 180, 0);
                self:SetRenderOrigin(BonePos);
                self:SetRenderAngles(BoneAng);
                self:SetupBones();
                self:DrawModel();
            end
        end
    end
end

function drawStuff()
    for _, ent in pairs(ents.FindByClass("backpack_mesh")) do
        ent:SetModelScale(0.85, 0)
        ent:Draw()
    end
end
hook.Add("PostDrawOpaqueRenderables", "drawStuff", drawStuff)

function ENT:Initialize()
    self:SetRenderBoundsWS(-Vector(12800, 12800, 12800), Vector(12800, 12800, 12800))
end