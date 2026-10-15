--[[
	Aero UI for Wolves life 3
	Made by rFlixzypoo on discord
	Assets from q_ow2 on discord

	Free open source

	Version Number: 0.9.6
]]--

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/FlixzyVibxsx/AeroUI/refs/heads/main/Lib.lua"))()

local UI = Library.new()
print(UI.SetToggleKey)
UI:SetToggleKey(Enum.KeyCode.LeftShift)
UI:Notify("Welcome", "Aero UI Loaded Successfully", 3)

local Section = UI:NewSection("Credits")
Section.NewParagraph({
    "Made by rFlixzypoo",
    "Assets from q_ow2",
    "Free and Open Source",
    "Version: 0.9.5",
    "Flixz is a simp for his girlfriend <3",
})

local Section = UI:NewSection("Main Functions")

Section.NewButton({
	Text = "Rejoin",
	Callback = function()
		local TeleportService = game:GetService("TeleportService")
		local Players = game:GetService("Players")
		local player = Players.LocalPlayer
		TeleportService:Teleport(game.PlaceId, player)
	end
})

Section.NewButton({
	Text = "Infinite Yield",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	end
})

Section.NewButton({
	Text = "Drop Kick",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/platinww/CrustyMain/refs/heads/main/universal/DropKick.lua"))()
	end
})

local Section = UI:NewSection("Customization")

local chosenColor = Color3.fromRGB(0, 0, 0)
local Value = 1
local Material = "Neon"
local Part = "EyeColor1"

Section.NewDropdown({
	Text = "Select Accessory",
	Default = "Slider Bracelets",
	Options = {"Slider Bracelets", "Cross Bracelets", "Leaves", "Winter Boots", "Double Bracelets", "Curly", "Punk",
	"Lonely Woof", "Swiped Back", "Braided", "Long", "Ewooftional", "Long Straight", "Bed Head", "Short Spiky", "Long Spiky", 
	"Spiky Punk", "Spiky", "Emo-Punk", "Sidecut", "Scene", "Extreme-Edge", "Long Sidecut", "Right Ear Piercing", 
	"Left Ear Piercing", "Septum", "Eyebrow Piercing", "Snake Bites", "Guitar", "Swords", "Cape", "Medic", "Flowers", 
	"Rope", "Ripped Shirt", "Bags", "Sword Set 1", "Sword Set 2", "Sword 1", "Sword 2", "Chains", "LeavesBack", "Backpack", "Scars",},
	Callback = function(option)
		UI:Notify("Accessory Selected", "You selected: " .. option, 2)
		if option == "Slider Bracelets" then
			Value = 1
		elseif option == "Cross Bracelets" then
			Value = 2
		elseif option == "Leaves" then
			Value = 3
		elseif option == "Winter Boots" then
			Value = 4				
		elseif option == "Double Bracelets" then
			Value = 5
		elseif option == "Curly" then
			Value = 6
		elseif option == "Punk" then
			Value = 7
		elseif option == "Lonely Woof" then
			Value = 8
		elseif option == "Swiped Back" then
			Value = 9
		elseif option == "Braided" then
			Value = 10
		elseif option == "Long" then
			Value = 11
		elseif option == "Ewooftional" then
			Value = 12
		elseif option == "Long Straight" then
			Value = 13
		elseif option == "Bed Head" then
			Value = 14
		elseif option == "Short Spiky" then
			Value = 15
		elseif option == "Long Spiky" then
			Value = 16
		elseif option == "Spiky Punk" then
			Value = 17
		elseif option == "Spiky" then
			Value = 18
		elseif option == "Emo-Punk" then
			Value = 19
		elseif option == "Sidecut" then
			Value = 20
		elseif option == "Scene" then
			Value = 21
		elseif option == "Extreme-Edge" then
			Value = 22
		elseif option == "Long Sidecut" then
			Value = 23
		elseif option == "Right Ear Piercing" then
			Value = 24
		elseif option == "Left Ear Piercing" then
			Value = 25
		elseif option == "Septum" then
			Value = 26
		elseif option == "Eyebrow Piercing" then
			Value = 27
		elseif option == "Snake Bites" then
			Value = 28
		elseif option == "Guitar" then
			Value = 29
		elseif option == "Swords" then
			Value = 30
		elseif option == "Cape" then
			Value = 31
		elseif option == "Medic" then
			Value = 32
		elseif option == "Flowers" then
			Value = 33
		elseif option == "Rope" then
			Value = 34
		elseif option == "Ripped Shirt" then
			Value = 35
		elseif option == "Bags" then
			Value = 36
		elseif option == "Sword Set 1" then
			Value = 37
		elseif option == "Sword Set 2" then
			Value = 38
		elseif option == "Sword 1" then
			Value = 39
		elseif option == "Sword 2" then
			Value = 40
		elseif option == "Chains" then
			Value = 41
		elseif option == "LeavesBack" then
			Value = 42
		elseif option == "Backpack" then
			Value = 43
		elseif option == "Scars" then
			Value = 44
		end

	end
})

Section.NewDropdown({
	Text = "Part to Color",
	Default = "EyeColor1",
	Options = {"EyeColor1", "EyeColor2", "Pupil1", "Pupil2", "White1", "White2", "Lash1", "Lash2", "Head", "Cheeks", "Muzzle",
	"Eyebrow1", "Eyebrow2", "EyeLid", "Nose", "Jaw", "Gum", "Toungue1", "Toungue2", "NeckSecondary", "Torso", "TorsoSecondary",
	"Hip", "HipSecondary", "RightShoulder", "RightArm", "RightLowerArm", "DragonFoot1", "LeftShoulder", "LeftArm", "LeftLowerArm",
	"DragonFoot2", "RightThigh", "RightLeg", "RightLowerLeg", "DragonFoot3", "LegFluff1", "LeftThigh", "LeftLeg", "LeftLowerLeg", 
	"DragonFoot4", "LegFluff2", "Tail1", "Tail2", "Tail3", "Tail5", "TailFluff1", "TailFluff2", "TailFluff3", "TailFluff4", 
	"DragonTip", "OceanTailPrimary", "OceanFin", "DragonSpike7", "DragonSpike8", "DragonSpike9", "DragonSpike10", "DragonClaw1",
	"DragonClaw2", "DragonClaw3", "DragonClaw4", "DragonDewClaw1", "DragonDewClaw2", "DragonWingL1", "DragonWingL2", "DragonWingL3",
	"DragonWingL4", "DragonWingL5", "DragonWingR1", "DragonWingR2", "DragonWingR3", "DragonWingR4", "DragonWingR5", "DragonLSkin1", 
	"DragonLSkin2", "DragonLSkin3", "DragonLSkin4", "DragonRSkin1", "DragonRSkin2", "DragonRSkin3", "DragonRSkin4", "DragonWingLDew",
	"DragonWingRDew", "LeftWingStart", "RightWingStart", "DragonHornBig1", "DragonHornBig2", "DragonHornSmall1-1", "DragonHornSmall1-2",
	"DragonHornSmall2-1", "DragonHornSmall2-2", "DragonSpike1", "DragonSpike2", "DragonSpike3", "DragonSpike4", "DragonSpike5", 
	"DragonSpike6", "DragonSpike7", "DragonSpike8", "DragonSpike9", "DragonSpike10", "DragonHornTop1", "DragonHornTop2", "DragonHornTop3",
	"DragonTip", "LeftWingStart", "LeftWing2", "LeftWing3", "RightWingStart", "RightWing2", "RightWing3" "Ocean1Primary", "Ocean1Secondary"
	"Ocean2Primary", "Ocean2Secondary", "OceanTailPrimary", "OceanTailSecondary", "OceanDot1", "OceanDot2", "OceanDot3", "OceanDot4", 
	"OceanSecondary1", "OceanSecondary2", "OceanSecondary3"},
	Callback = function(option)
		UI:Notify("Part Selected", "You selected: " .. option, 2)
		Part = option
	end
})

Section.NewDropdown({
	Text = "Select Material",
	Default = "Neon",
	Options = {"ForceField", "Plastic", "Neon", "Wood", "Slate", "Concrete", "Granite", "Brick", "Pebble", "CorrodedMetal", 
	"DiamondPlate", "Foil", "Grass", "Ice", "Marble", "Metal", "Rock", "Sand", "SmoothPlastic", "Snow", 
	"Fabric",},
	Callback = function(option)
		UI:Notify("Material Selected", "You selected: " .. option, 2)
		Material = option
	end
})

Section.NewColorPicker({
    Text = "Color",
    Default = chosenColor,
    Callback = function(color)
        chosenColor = color
    end
})

Section.NewButton({
	Text = "Set Name Color",
	Callback = function()
		local Event = game:GetService("ReplicatedStorage").Events["UpdateSetting"]
		Event:InvokeServer(
    		"ChangeColor",
    		{
        		chosenColor.R,
        		chosenColor.G,
        		chosenColor.B
    		}
		)
	end
})

Section.NewButton({
	Text = "Set Accessory Color/Material",
	Callback = function()
		local Event = game:GetService("ReplicatedStorage").Events["ColorAccessory"]
		Event:FireServer(
    		"Color",
    		Value,
			"Color1",
    		chosenColor,
    		{
    		    Material = Material,
    		    MaterialVariant = ""
    		}
		)
		local Event = game:GetService("ReplicatedStorage").Events["ColorAccessory"]
		Event:FireServer(
    		"Color",
    		Value,
			"MeshPart",
    		chosenColor,
    		{
    		    Material = Material,
    		    MaterialVariant = ""
    		}
		)
		local Event = game:GetService("ReplicatedStorage").Events["ColorAccessory"]
		Event:FireServer(
    		"Color",
    		Value,
			"Piercing",
    		chosenColor,
    		{
    		    Material = Material,
    		    MaterialVariant = ""
    		}
		)
		local Event = game:GetService("ReplicatedStorage").Events["ColorAccessory"]
		Event:FireServer(
    		"Color",
    		Value,
			"Hat",
    		chosenColor,
    		{
    		    Material = Material,
    		    MaterialVariant = ""
    		}
		)
		
	end
})

Section.NewButton({
	Text = "Set Part Color/Material",
	Callback = function()
		local Event = game:GetService("ReplicatedStorage").Events.UpdateColor
		Event:FireServer(
			"Color",
			Part,
			chosenColor,
			{
			    Material = Material,
			    MaterialVariant = ""
			}
		)
	end
})

local Section = UI:NewSection("Settings")

local ThemeTargets = {
    { "Accent",            "Accent"      },
    { "Accent Hover",      "AccentHover" },
    { "Window Background", "Secondary"   },
    { "Title Bar / Tabs",  "Primary"     },
    { "Rows / Buttons",    "Elevated"    },
    { "Borders",           "Edge"        },
    { "Text",              "Text"        },
    { "Dim Text",          "TextDim"     },
}

local targetNames, targetKeys = {}, {}
for _, t in ipairs(ThemeTargets) do
    table.insert(targetNames, t[1])
    targetKeys[t[1]] = t[2]
end

local selectedKey = "Accent"
local picker

local function syncPicker()
    picker.SetColor(UI:GetTheme(selectedKey))
end

Section.NewDropdown({
    Text = "Theme Preset",
    Default = "Default",
    Options = UI:GetPresetNames(),
    Callback = function(name)
        UI:ApplyPreset(name)
        syncPicker()
    end
})

Section.NewDropdown({
    Text = "Customize",
    Default = "Accent",
    Options = targetNames,
    Callback = function(name)
        selectedKey = targetKeys[name]
        syncPicker()
    end
})

picker = Section.NewColorPicker({
    Text = "Custom Color",
    Default = UI:GetTheme("Accent"),
    Callback = function(color)
        UI:SetTheme(selectedKey, color)
    end
})

Section.NewButton({
    Text = "Reset Theme",
    Callback = function()
        UI:ResetTheme()
        syncPicker()
        UI:Notify("Theme", "Theme reset to default", 2)
    end
})

Section.NewButton({
    Text = "Reset",
    Callback = function()
        UI:Notify("Reset", "Settings reset!", 2)
    end
})

Section.NewKeybind({
    Text = "Toggle UI Key",
    Default = "F1",
    Callback = function(key)
        UI:SetToggleKey(key)
    end
})
