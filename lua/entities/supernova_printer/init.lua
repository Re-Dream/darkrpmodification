--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.SeizeReward = 950

ENT.PrintAmount = 7500
ENT.PrintDelay = .2
ENT.PrintHealth = 200
ENT.PrintMaxMoney = 200000
ENT.LastPrint = CurTime()
ENT.PrintType = "Supernova"

function ENT:Initialize()
	self:SetModel("models/props_c17/consolebox01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end

	self.sparking = false
	self.damage = 100
	self.IsMoneyPrinter = true

	self.sound = CreateSound(self, Sound("ambient/levels/labs/equipment_printer_loop1.wav"))
	self.sound:SetSoundLevel(52)
	self.sound:PlayEx(1, 140)
	
	self:SetMaterial("models/debug/debugwhite")
	
	self:SetNWInt("money_amount", 0)
	self:SetNWString("printer_name", self.PrintType .. " Money Printer")
	self:SetNWInt("printer_health", self.PrintHealth)
	self:SetNWInt("printer_maxmoneyamount", self.PrintMaxMoney)
	self:SetNWInt("printer_lastprint", self.LastPrint)
	self:SetNWInt("printer_printtime", self.PrintDelay)
	self:SetNWBool("printer_isburning", false)
end

function ENT:Use(a, b)
	if self:GetNWInt("money_amount", 0) > 0 and IsValid(a) then
		a:addMoney(self:GetNWInt("money_amount", 0))
		DarkRP.notify(a, 0, 4, "You collected " .. DarkRP.formatMoney(self:GetNWInt("money_amount", 0)) .. " from your printer!")
		self:SetNWInt("money_amount", 0)
	end
end

function ENT:OnTakeDamage(dmg)
	if self.burningup then return end
	
	self:SetNWInt("printer_health", math.max(self:GetNWInt("printer_health", self.PrintHealth) - dmg:GetDamage(), 0))
	
	if self:GetNWInt("printer_health", self.PrintHealth) < 1 then
		local rnd = math.random(1, 3)
		if rnd < 3 then
			self:BurstIntoFlames()
		else
			self:Destruct()
		end
	end
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
	DarkRP.notify(self:Getowning_ent(), 1, 4, DarkRP.getPhrase("money_printer_exploded"))
	self:Remove()
end

function ENT:Fireball()
	if not self:IsOnFire() then self.burningup = false return end
	local dist = math.random(140, 400) -- Explosion radius
	for k, v in pairs(ents.FindInSphere(self:GetPos(), dist)) do
		if not v:IsPlayer() and not v:IsWeapon() and v:GetClass() ~= "predicted_viewmodel" and not v.IsMoneyPrinter then
			v:Ignite(math.random(5, 22), 0)
		elseif v:IsPlayer() then
			local distance = v:GetPos():Distance(self:GetPos())
			v:TakeDamage(distance / dist * 100, self, self)
		end
	end
	self:Destruct()
end

function ENT:BurstIntoFlames()
	DarkRP.notify(self:Getowning_ent(), 0, 4, DarkRP.getPhrase("money_printer_overheating"))
	self.burningup = true
	local burntime = 2
	self:Ignite(burntime, 0)
	self:SetNWBool("printer_isburning", true)
	timer.Simple(burntime, function() self:Fireball() end)
end

function ENT:CreateMoneybag()
	if not IsValid(self) or self:IsOnFire() then return end

	if GAMEMODE.Config.printeroverheat then
		local overheatchance = GAMEMODE.Config.printeroverheatchance or 3
		
		local DoBurstIntoFlames = math.random(1, overheatchance) == 3
		if DoBurstIntoFlames then
			self:BurstIntoFlames()
		end
	end
	
	self:SetNWInt("money_amount", math.min(self:GetNWInt("money_amount", 0) + self.PrintAmount or 100, self.PrintMaxMoney))
end

function ENT:Think()
	if self:WaterLevel() > 0 then
		self:Destruct()
		self:Remove()
		return
	end
	
	if CurTime() >= self.LastPrint + self.PrintDelay then
		self.LastPrint = CurTime()
		self:SetNWInt("printer_lastprint", self.LastPrint)
		self:CreateMoneybag()
	end

	self:SetColor(Color(math.random(1, 255), math.random(1, 255),math.random(1, 255)))
	
	if not self.sparking then return end
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetMagnitude(1)
	effectdata:SetScale(1)
	effectdata:SetRadius(2)
	util.Effect("Sparks", effectdata)
end

function ENT:OnRemove()
	if self.sound then
		self.sound:Stop()
	end
end
