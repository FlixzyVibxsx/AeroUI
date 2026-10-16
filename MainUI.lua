--[[
	Aero UI for Wolves life 3
	Made by rFlixzypoo on discord
	Assets from q_ow2 on discord

	Free open source

	Version Number: 1.0.6
]]--

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/FlixzyVibxsx/AeroUI/refs/heads/main/Lib.lua"))()

local UI = Library.new()
print(UI.SetToggleKey)
UI:SetToggleKey(Enum.KeyCode.F1)
UI:Notify("Welcome", "Aero UI Loaded Successfully", 3)

local Section = UI:NewSection("Credits")
Section.NewParagraph({
    "Made by rFlixzypoo",
    "Assets from q_ow2",
    "Free and Open Source",
    "Version: 1.0.6",
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

local AccessoryNames = {"Slider Bracelets", "Cross Bracelets", "Leaves", "Winter Boots", "Double Bracelets", "Curly", "Punk",
	"Lonely Woof", "Swiped Back", "Braided", "Long", "Ewooftional", "Long Straight", "Bed Head", "Short Spiky", "Long Spiky", 
	"Spiky Punk", "Spiky", "Emo-Punk", "Sidecut", "Scene", "Extreme-Edge", "Long Sidecut", "Right Ear Piercing", 
	"Left Ear Piercing", "Septum", "Eyebrow Piercing", "Snake Bites", "Guitar", "Swords", "Cape", "Medic", "Flowers", 
	"Rope", "Ripped Shirt", "Bags", "Sword Set 1", "Sword Set 2", "Sword 1", "Sword 2", "Chains", "LeavesBack", "Backpack", "Scars" }
local PartOptions    = { "EyeColor1", "EyeColor2", "Pupil1", "Pupil2", "White1", "White2", "Lash1", "Lash2", "Head", "Cheeks", "Muzzle",
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
	"DragonTip", "LeftWingStart", "LeftWing2", "LeftWing3", "RightWingStart", "RightWing2", "RightWing3", "Ocean1Primary", "Ocean1Secondary",
	"Ocean2Primary", "Ocean2Secondary", "OceanTailPrimary", "OceanTailSecondary", "OceanDot1", "OceanDot2", "OceanDot3", "OceanDot4", 
	"OceanSecondary1", "OceanSecondary2", "OceanSecondary3", "ChestFluff", "BackFluff","FrontChestFluff", "Neck", }

Section.NewDropdown({
	Text = "Select Accessory",
	Searchable = true,
	MaxHeight = 200,
	Default = "Slider Bracelets",
	Options = AccessoryNames,
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
	Multi = true,
	Searchable = true,
	MaxHeight = 200,
	Default = {"EyeColor1"},
	Options = PartOptions,
	Callback = function(selectedParts)
		Parts = selectedParts
	end
})

Section.NewDropdown({
	Text = "Select Material",
	Searchable = true,
	MaxHeight = 200,
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
		if #Parts == 0 then
			UI:Notify("No Parts", "Select at least one part first", 2)
			return
		end

		local Event = game:GetService("ReplicatedStorage").Events.UpdateColor
		for _, partName in ipairs(Parts) do
			Event:FireServer(
				"Color",
				partName,
				chosenColor,
				{
					Material = Material,
					MaterialVariant = ""
				}
			)
		end
		UI:Notify("Applied", #Parts .. " part(s) updated", 2)
	end
})

local Section = UI:NewSection("Copy Design")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ACCESSORY_TARGETS = { "Color1", "MeshPart", "Piercing", "Hat" }
local NameBox

local function getFolder()
	return workspace:FindFirstChild("PlayerCharacters")
end

local function getPlayerNames()
	local names, folder = {}, getFolder()
	if not folder then
		warn("[CopyDesign] workspace.PlayerCharacters not found")
		return names
	end
	for _, c in ipairs(folder:GetChildren()) do
		table.insert(names, c.Name)
	end
	return names
end

local function norm(s)
	return string.lower((string.gsub(s, "[^%w]", "")))
end

local function resolveTarget()
	local name = NameBox.GetResolved()
	if not name then
		UI:Notify("Copy Design", "No matching player found", 2)
		return nil
	end
	local folder = getFolder()
	local model = folder and folder:FindFirstChild(name)
	if not model then
		UI:Notify("Copy Design", "Couldn't find " .. name .. " in PlayerCharacters", 2)
		return nil
	end
	return model, name
end

local function copyParts(model)
	local Event = ReplicatedStorage.Events.UpdateColor
	local done, seenPart = 0, {}
	for _, partName in ipairs(PartOptions) do
		if not seenPart[partName] then
			seenPart[partName] = true
			local inst = model:FindFirstChild(partName, true)
			if inst and inst:IsA("BasePart") then
				Event:FireServer("Color", partName, inst.Color, {
					Material = inst.Material.Name,
					MaterialVariant = inst.MaterialVariant,
				})
				done = done + 1
				if done % 5 == 0 then task.wait(0.05) end
			end
		end
	end
	return done
end

local function copyAccessories(model)
	local Event = ReplicatedStorage.Events.ColorAccessory
	local wanted = {}
	for id, accName in ipairs(AccessoryNames) do
		wanted[norm(accName)] = id
	end

	local count, handled = 0, {}
	for _, inst in ipairs(model:GetDescendants()) do
		local id = wanted[norm(inst.Name)]
		if id and not handled[id] then
			handled[id] = true
			local sent = false

			local function send(target, part)
				Event:FireServer("Color", id, target, part.Color, {
					Material = part.Material.Name,
					MaterialVariant = part.MaterialVariant,
				})
				sent = true
			end

			local foundAny = false
			for _, target in ipairs(ACCESSORY_TARGETS) do
				local p = inst:FindFirstChild(target, true)
				if p and p:IsA("BasePart") then
					send(target, p)
					foundAny = true
				end
			end

			-- fallback: no named sub-parts, so use the accessory's first part for every slot
			if not foundAny then
				local fallback = inst:IsA("BasePart") and inst or inst:FindFirstChildWhichIsA("BasePart", true)
				if fallback then
					for _, target in ipairs(ACCESSORY_TARGETS) do send(target, fallback) end
				end
			end

			if sent then
				count = count + 1
				task.wait(0.03)
			end
		end
	end
	return count
end

NameBox = Section.NewAutoTextBox({
	Text = "Player",
	Placeholder = "Type a name...",
	GetOptions = getPlayerNames,
})

Section.NewButton({
	Text = "Copy Everything",
	Callback = function()
		local model, name = resolveTarget()
		if not model then return end
		local p = copyParts(model)
		local a = copyAccessories(model)
		UI:Notify("Copied " .. name, p .. " parts, " .. a .. " accessories", 3)
	end
})

Section.NewButton({
	Text = "Copy Parts Only",
	Callback = function()
		local model, name = resolveTarget()
		if not model then return end
		UI:Notify("Copied " .. name, copyParts(model) .. " parts", 3)
	end
})

Section.NewButton({
	Text = "Copy Accessories Only",
	Callback = function()
		local model, name = resolveTarget()
		if not model then return end
		UI:Notify("Copied " .. name, copyAccessories(model) .. " accessories", 3)
	end
})

Section.NewButton({
	Text = "Debug: Print Model",
	Callback = function()
		local model = resolveTarget()
		if not model then return end
		print("---- " .. model:GetFullName() .. " ----")
		for _, d in ipairs(model:GetDescendants()) do
			local line = d.ClassName .. "  " .. d:GetFullName()
			if d:IsA("BasePart") then
				line = line .. string.format("  |  %s  |  %s", tostring(d.Color), d.Material.Name)
			end
			print(line)
		end
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
	Searchable = true,
	MaxHeight = 200,
    Default = "Default",
    Options = UI:GetPresetNames(),
    Callback = function(name)
        UI:ApplyPreset(name)
        syncPicker()
    end
})

Section.NewDropdown({
    Text = "Customize",
	Searchable = true,
	MaxHeight = 200,
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
