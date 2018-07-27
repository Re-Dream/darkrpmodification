--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
include("shared.lua")

local function CreateFont(name, data, blurSize)
	surface.CreateFont(name, data)
	data.blursize = blurSize
	data.additive = false
	surface.CreateFont("blur_" .. name, data)
end

CreateFont("nametags", {
	font = "Roboto",
	weight = 800,
	size = 24,
	additive = true
}, 12)
CreateFont("nametags2", {
	font = "Roboto",
	weight = 550,
	size = 16,
	additive = true
}, 12)


function ENT:Initialize()
end

local blinktime = .2
local lastblink = CurTime()
local blink = false

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

	surface.SetFont("nametags")
	local text = DarkRP.getPhrase("money_printer")
	local namewidth, nameheight = surface.GetTextSize(text)

	Ang:RotateAroundAxis(Ang:Up(), 90)
	
	cam.Start3D2D(Pos + Ang:Up() * 11.5, Ang, 0.11)
		draw.DrawText(self:GetNWString("printer_name", text), "nametags", -namewidth, -namewidth, Color(255,255,255,255))
		draw.DrawText(owner, "nametags2", -namewidth, -namewidth + 20, Color(0,255,0,255))
		
		draw.DrawText("Print time left: " .. math.max(math.Round(self:GetNWInt("printer_lastprint") - CurTime(), 1) + self:GetNWInt("printer_printtime"), 0) .. "s", "nametags2", -namewidth, -namewidth + 60, Color(255,255,255,255))
		draw.RoundedBoxEx(0, -namewidth, -namewidth + 50, namewidth*2, 5, Color(255,255,255,255))
		local s = ((namewidth*2)*math.min(((CurTime() - self:GetNWInt("printer_lastprint"))/self:GetNWInt("printer_printtime")),1))
		draw.RoundedBoxEx(0, -namewidth+1, -namewidth + 51, s - 2, 3, Color(0,255,255,255))
		
		draw.DrawText("Money in the printer: " .. DarkRP.formatMoney(self:GetNWInt("money_amount", 0)), "nametags2", -namewidth, -namewidth + 90, Color(255,255,255,255))
		draw.RoundedBoxEx(0, -namewidth, -namewidth + 80, namewidth*2, 5, Color(255,255,255,255))
		local ss = ((namewidth*2)*math.max((self:GetNWInt("money_amount") / self:GetNWInt("printer_maxmoneyamount")),0))
		draw.RoundedBoxEx(0, -namewidth+1, -namewidth + 81, self:GetNWInt("money_amount")>0 and ss - 2 or 0, 3, Color(0,255,0,255))
		
		if self:GetNWBool("printer_isburning", false) then
			if (CurTime() >= lastblink + blinktime) then
				blink = not blink
				lastblink = CurTime()
			end
			
			if blink then
				draw.DrawText("! OVERHEATING !", "nametags", 0, namewidth - 10, Color(255,0,0,255), 1)
			end
		end
	cam.End3D2D()
end

function ENT:Think()
end
