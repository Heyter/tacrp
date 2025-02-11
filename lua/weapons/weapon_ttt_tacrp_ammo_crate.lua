if engine.ActiveGamemode() != "terrortown" then return end

AddCSLuaFile()

SWEP.HoldType               = "normal"


if CLIENT then
   SWEP.PrintName           = "tacrp_ammocrate_name"
   SWEP.Slot                = 6

   SWEP.ViewModelFOV        = 10
   SWEP.DrawCrosshair       = false

   LANG.AddToLanguage("english", "tacrp_ammocrate_name", "Ammo Crate")
   LANG.AddToLanguage("english", "tacrp_ammocrate_help", "{primaryfire} places the Ammo Crate.")
   LANG.AddToLanguage("english", "tacrp_ammocrate_desc", [[
Allows people to replenish ammo. Slow recharge.
Can even give certain traitor weapon ammo types.

Anyone can use it. Explodes if destroyed.
Can be checked for DNA samples of its users.]])

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "tacrp_ammocrate_desc"
   };

   SWEP.Icon                = "entities/tacrp_ammo_crate.png"
end

SWEP.Base                   = "weapon_tttbase"

SWEP.ViewModel              = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel             = "models/weapons/tacint/ammoboxes/ammo_box-2b.mdl"

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"
SWEP.Primary.Delay          = 1.0

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Delay        = 1.0

-- This is special equipment
SWEP.Kind                   = WEAPON_EQUIP
SWEP.CanBuy                 = {ROLE_DETECTIVE, ROLE_TRAITOR}
SWEP.LimitedStock           = true -- only buyable once

SWEP.AllowDrop              = false
SWEP.NoSights               = true

function SWEP:OnDrop()
   self:Remove()
end

function SWEP:PrimaryAttack()
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   self:HealthDrop()
end
function SWEP:SecondaryAttack()
   self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
   self:HealthDrop()
end

local throwsound = Sound( "Weapon_SLAM.SatchelThrow" )

-- ye olde droppe code
function SWEP:HealthDrop()
   if SERVER then
      local ply = self:GetOwner()
      if not IsValid(ply) then return end

      if self.Planted then return end

      local vsrc = ply:GetShootPos()
      local vang = ply:GetAimVector()
      local vvel = ply:GetVelocity()

      local vthrow = vvel + vang * 150

      local health = ents.Create("tacrp_ammo_crate_ttt")
      if IsValid(health) then
         health:SetPos(vsrc + vang * 10)
         health:SetAngles(Angle(0, ply:GetAngles().y - 180, 0))
         health:Spawn()

         health:SetPlacer(ply)

         health:PhysWake()
         local phys = health:GetPhysicsObject()
         if IsValid(phys) then
            phys:SetVelocity(vthrow)
         end
         self:Remove()

         self.Planted = true
      end
   end

   self:EmitSound(throwsound)
end


function SWEP:Reload()
   return false
end

function SWEP:OnRemove()
   if CLIENT and IsValid(self:GetOwner()) and self:GetOwner() == LocalPlayer() and self:GetOwner():Alive() then
      RunConsoleCommand("lastinv")
   end
end

if CLIENT then
   function SWEP:Initialize()
      self:AddHUDHelp("tacrp_ammocrate_help", nil, true)

      return self.BaseClass.Initialize(self)
   end
end

function SWEP:Deploy()
   if SERVER and IsValid(self:GetOwner()) then
      self:GetOwner():DrawViewModel(false)
   end
   return true
end

function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
end