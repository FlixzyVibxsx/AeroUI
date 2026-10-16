--[[
	Aero UI for Wolves life 3
	Made by rFlixzypoo on discord
	Assets from q_ow2 on discord

	Free open source

	Version Number: 1.0.11
]]--

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/FlixzyVibxsx/AeroUI/refs/heads/main/Lib.lua"))()

local UI = Library.new({ ConfigName = "WolvesLife3" })
if not UI:GetSetting("ToggleKey") then
    UI:SetToggleKey(Enum.KeyCode.F1)
end
UI:Notify("Welcome", "Aero UI Loaded Successfully", 3)
if not Library.CanSave() then
    UI:Notify("Storage", "Executor can't save files - settings won't persist", 4)
end

local Section = UI:NewSection("Credits")

Section.NewProfile({
    Title = "Welcome to Aero UI",
})

Section.NewParagraph({
    "Made by rFlixzypoo",
    "Assets from q_ow2",
    "Free and Open Source",
    "Version: 1.0.11",
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

local chosenColor   = Library.DecodeColor(UI:GetSetting("Color")) or Color3.fromRGB(0, 0, 0)
local Material      = UI:GetSetting("Material", "Neon")
local Parts         = UI:GetSetting("Parts", { "EyeColor1" })
local AccessoryName = UI:GetSetting("Accessory", AccessoryNames[1])
local Value         = table.find(AccessoryNames, AccessoryName) or 1

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
		Value = table.find(AccessoryNames, option) or 1
		UI:SetSetting("Accessory", option)
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
		UI:SetSetting("Parts", selectedParts)
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
		Material = option
		UI:SetSetting("Material", option)
	end
})

Section.NewColorPicker({
    Text = "Color",
    Default = chosenColor,
    Callback = function(color)
        chosenColor = color
		UI:SetSetting("Color", Library.EncodeColor(chosenColor))
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
local LocalPlayer       = game:GetService("Players").LocalPlayer
local ACCESSORY_TARGETS = { "Color1", "MeshPart", "Piercing", "Hat" }
local ROOT_NAMES        = { "PlayerCharacters", "Customizing" }  -- spawned / still customizing
local NameBox

local function getRoots()
	local roots = {}
	for _, n in ipairs(ROOT_NAMES) do
		local r = workspace:FindFirstChild(n)
		if r then table.insert(roots, r) end
	end
	return roots
end

local function getPlayerNames()
	local names, seen = {}, {}
	for _, root in ipairs(getRoots()) do
		for _, c in ipairs(root:GetChildren()) do
			if not seen[c.Name] then
				seen[c.Name] = true
				table.insert(names, c.Name)
			end
		end
	end
	return names
end

local function findModel(name)
	for _, root in ipairs(getRoots()) do
		local m = root:FindFirstChild(name)
		if m then return m end
	end
end

local function norm(s)
	return string.lower((string.gsub(s, "[^%w]", "")))
end

local function partData(p)
	return { C = Library.EncodeColor(p.Color), M = p.Material.Name, V = p.MaterialVariant }
end

-- read a model into a plain table (also what gets saved for OCs)
local function readModel(model)
	local snap = { Parts = {}, Accessories = {} }
	local nParts, nAcc = 0, 0

	for _, partName in ipairs(PartOptions) do
		if not snap.Parts[partName] then
			local inst = model:FindFirstChild(partName, true)
			if inst and inst:IsA("BasePart") then
				snap.Parts[partName] = partData(inst)
				nParts = nParts + 1
			end
		end
	end

	local wanted = {}
	for _, accName in ipairs(AccessoryNames) do wanted[norm(accName)] = accName end

	for _, inst in ipairs(model:GetDescendants()) do
		local accName = wanted[norm(inst.Name)]
		if accName and not snap.Accessories[accName] then
			local targets, foundAny = {}, false
			for _, target in ipairs(ACCESSORY_TARGETS) do
				local p = inst:FindFirstChild(target, true)
				if p and p:IsA("BasePart") then
					targets[target] = partData(p)
					foundAny = true
				end
			end
			if not foundAny then
				local fb = inst:IsA("BasePart") and inst or inst:FindFirstChildWhichIsA("BasePart", true)
				if fb then
					for _, target in ipairs(ACCESSORY_TARGETS) do targets[target] = partData(fb) end
					foundAny = true
				end
			end
			if foundAny then
				snap.Accessories[accName] = targets
				nAcc = nAcc + 1
			end
		end
	end
	return snap, nParts, nAcc
end

-- send a snapshot to the game
local function applySnapshot(snap, doParts, doAcc)
	local nParts, nAcc, sent = 0, 0, 0
	local function pace()
		sent = sent + 1
		if sent % 5 == 0 then task.wait(0.05) end
	end

	if doParts then
		local Event = ReplicatedStorage.Events.UpdateColor
		for partName, d in pairs(snap.Parts or {}) do
			local color = Library.DecodeColor(d.C)
			if color then
				Event:FireServer("Color", partName, color, { Material = d.M, MaterialVariant = d.V or "" })
				nParts = nParts + 1
				pace()
			end
		end
	end

	if doAcc then
		local Event = ReplicatedStorage.Events.ColorAccessory
		for accName, targets in pairs(snap.Accessories or {}) do
			local id = table.find(AccessoryNames, accName)
			if id then
				for target, d in pairs(targets) do
					local color = Library.DecodeColor(d.C)
					if color then
						Event:FireServer("Color", id, target, color, { Material = d.M, MaterialVariant = d.V or "" })
						pace()
					end
				end
				nAcc = nAcc + 1
			end
		end
	end
	return nParts, nAcc
end

local function resolveTarget()
	local name = NameBox.GetResolved()
	if not name then
		UI:Notify("Copy Design", "No matching player found", 2)
		return nil
	end
	local model = findModel(name)
	if not model then
		UI:Notify("Copy Design", "Couldn't find " .. name, 2)
		return nil
	end
	return model, name
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
		local p, a = applySnapshot((readModel(model)), true, true)
		UI:Notify("Copied " .. name, p .. " parts, " .. a .. " accessories", 3)
	end
})

Section.NewButton({
	Text = "Copy Parts Only",
	Callback = function()
		local model, name = resolveTarget()
		if not model then return end
		local p = applySnapshot((readModel(model)), true, false)
		UI:Notify("Copied " .. name, p .. " parts", 3)
	end
})

Section.NewButton({
	Text = "Copy Accessories Only",
	Callback = function()
		local model, name = resolveTarget()
		if not model then return end
		local _, a = applySnapshot((readModel(model)), false, true)
		UI:Notify("Copied " .. name, a .. " accessories", 3)
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

local Section = UI:NewSection("My OCs")

local function getOCs() return UI:GetSetting("OCs", {}) end

local function trim(s) return (string.gsub(s, "^%s*(.-)%s*$", "%1")) end

local OCBox = Section.NewAutoTextBox({
	Text = "OC Name",
	Placeholder = "Name your OC...",
	SnapOnEnter = false,   -- so a new name isn't snapped onto an old one
	GetOptions = function()
		local names = {}
		for name in pairs(getOCs()) do table.insert(names, name) end
		return names
	end,
})

Section.NewButton({
	Text = "Save OC (from my character)",
	Callback = function()
		local name = trim(OCBox.GetText())
		if name == "" then
			UI:Notify("Save OC", "Type a name first", 2)
			return
		end
		local model = findModel(LocalPlayer.Name)
		if not model then
			UI:Notify("Save OC", "Couldn't find your character", 2)
			return
		end
		local snap, p, a = readModel(model)
		if p + a == 0 then
			UI:Notify("Save OC", "Nothing readable - try Debug: Print Model", 3)
			return
		end

		local ocs = getOCs()
		for existing in pairs(ocs) do   -- overwrite same name regardless of case
			if string.lower(existing) == string.lower(name) then ocs[existing] = nil end
		end
		snap.Saved = os.time()
		ocs[name] = snap
		UI:SetSetting("OCs", ocs)
		UI:SaveSettings()
		UI:Notify("Saved " .. name, p .. " parts, " .. a .. " accessories", 3)
	end
})

Section.NewButton({
	Text = "Apply OC",
	Callback = function()
		local name = OCBox.GetResolved()
		local snap = name and getOCs()[name]
		if not snap then
			UI:Notify("Apply OC", "No saved OC matches", 2)
			return
		end
		local p, a = applySnapshot(snap, true, true)
		UI:Notify("Applied " .. name, p .. " parts, " .. a .. " accessories", 3)
	end
})

Section.NewButton({
	Text = "Delete OC",
	Callback = function()
		local name = OCBox.GetResolved()
		local ocs = getOCs()
		if not (name and ocs[name]) then
			UI:Notify("Delete OC", "No saved OC matches", 2)
			return
		end
		ocs[name] = nil
		UI:SetSetting("OCs", ocs)
		UI:SaveSettings()
		OCBox.SetText("")
		UI:Notify("Deleted", name, 2)
	end
})

local Section = UI:NewSection("Settings")

Default = UI:GetPreset(),

Section.NewButton({
    Text = "Reset",
    Callback = function()
        UI:ClearSettings({ "OCs" })
        UI:ResetTheme()
        syncPicker()
        UI:Notify("Reset", "Settings cleared (OCs kept)", 2)
    end
})

Section.NewKeybind({
    Text = "Toggle UI Key",
    Default = UI:GetSetting("ToggleKey", "F1"),
    Changed = function(key) UI:SetToggleKey(key) end,
})

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
