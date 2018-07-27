--[[---------------------------------------------------------------------------
DarkRP custom entities
---------------------------------------------------------------------------

This file contains your custom entities.
This file should also contain entities from DarkRP that you edited.

Note: If you want to edit a default DarkRP entity, first disable it in darkrp_config/disabled_defaults.lua
	Once you've done that, copy and paste the entity to this file and edit it.

The default entities can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua#L111

For examples and explanation please visit this wiki page:
http://wiki.darkrp.com/index.php/DarkRP:CustomEntityFields

Add entities under the following line:
---------------------------------------------------------------------------]]
DarkRP.createEntity("Regular Money Printer", {
    ent = "regular_printer",
    model = "models/props_c17/consolebox01a.mdl",
    price = 2500,
    max = 2,
    cmd = "buyregularprinter"
})

DarkRP.createEntity("Upgraded Money Printer", {
    ent = "upgraded_printer",
    model = "models/props_c17/consolebox01a.mdl",
    price = 5000,
    max = 2,
    cmd = "buyupgradedprinter"
})

DarkRP.createEntity("Overclocked Money Printer", {
    ent = "overclocked_printer",
    model = "models/props_c17/consolebox01a.mdl",
    price = 15000,
    max = 2,
    cmd = "buyoverclockedprinter"
})

DarkRP.createEntity("Quantum Money Printer", {
    ent = "Quantum_printer",
    model = "models/props_c17/consolebox01a.mdl",
    price = 40000,
    max = 2,
    cmd = "buyquantumprinter"
})
