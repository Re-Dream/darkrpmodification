--[[---------------------------------------------------------------------------
DarkRP custom jobs
---------------------------------------------------------------------------
This file contains your custom jobs.
This file should also contain jobs from DarkRP that you edited.

Note: If you want to edit a default DarkRP job, first disable it in darkrp_config/disabled_defaults.lua
      Once you've done that, copy and paste the job to this file and edit it.

The default jobs can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/jobrelated.lua

For examples and explanation please visit this wiki page:
http://wiki.darkrp.com/index.php/DarkRP:CustomJobFields

Add your custom jobs under the following line:
---------------------------------------------------------------------------]]

TEAM_HITMAN = DarkRP.createJob("Hitman", {
	color = Color(255, 140, 0, 255),
	model = "models/player/leet.mdl",
	description = [[You take hits from people for money.]],
	weapons = {},
	command = "hitmanjob",
	max = 0, -- at most 70% of the players can have this job. Set to a whole number to set an absolute limit.
	salary = 45,
	admin = 0,
	vote = false,
	hasLicense = false,
	-- The following fields are OPTIONAL. If you do not need them, or do not need to change them from their defaults, REMOVE them.
	modelScale = 1,
	maxpocket = 20,
	maps = {"rp_downtown_v2", "gm_construct"},
	ammo = {
		["pistol"] = 60,
	},
    category = "Other", -- The name of the category it is in. Note: the category must be created!
    sortOrder = 100, -- The position of this thing in its category. Lower number means higher up.
 
    playerClass = "player_darkrp",
    label = "Hitman", -- Optional: the text on the button in the F4 menu
})

--[[---------------------------------------------------------------------------
Define which team joining players spawn into and what team you change to if demoted
---------------------------------------------------------------------------]]
GAMEMODE.DefaultTeam = TEAM_CITIZEN
--[[---------------------------------------------------------------------------
Define which teams belong to civil protection
Civil protection can set warrants, make people wanted and do some other police related things
---------------------------------------------------------------------------]]
GAMEMODE.CivilProtection = {
    [TEAM_POLICE] = true,
    [TEAM_CHIEF] = true,
    [TEAM_MAYOR] = true,
}
--[[---------------------------------------------------------------------------
Jobs that are hitmen (enables the hitman menu)
---------------------------------------------------------------------------]]
DarkRP.addHitmanTeam(TEAM_MOB)
DarkRP.addHitmanTeam(TEAM_HITMAN)