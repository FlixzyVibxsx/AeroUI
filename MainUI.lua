--[[
	Aero UI for Wolves life 3
	Made by rFlixzypoo on discord
	Assets from q_ow2 on discord

	Free open source

	Version Number: 1.1.0
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

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local MaterialService   = game:GetService("MaterialService")
local LocalPlayer       = game:GetService("Players").LocalPlayer

-------------------------------------------------------------------------
-- DATA LISTS
-------------------------------------------------------------------------

-- list order = accessory ID (1..44)
local AccessoryNames = {
	"Slider Bracelets", "Cross Bracelets", "Leaves", "Winter Boots", "Double Bracelets", "Curly", "Punk",
	"Lonely Woof", "Swiped Back", "Braided", "Long", "Ewooftional", "Long Straight", "Bed Head", "Short Spiky",
	"Long Spiky", "Spiky Punk", "Spiky", "Emo-Punk", "Sidecut", "Scene", "Extreme-Edge", "Long Sidecut",
	"Right Ear Piercing", "Left Ear Piercing", "Septum", "Eyebrow Piercing", "Snake Bites", "Guitar", "Swords",
	"Cape", "Medic", "Flowers", "Rope", "Ripped Shirt", "Bags", "Sword Set 1", "Sword Set 2", "Sword 1", "Sword 2",
	"Chains", "LeavesBack", "Backpack", "Scars",
}

local PartOptions = {
	"EyeColor1", "EyeColor2", "Pupil1", "Pupil2", "White1", "White2", "Lash1", "Lash2", "Head", "Cheeks", "Muzzle",
	"Eyebrow1", "Eyebrow2", "EyeLid", "Nose", "Jaw", "Gum", "Toungue1", "Toungue2", "NeckSecondary", "Torso",
	"TorsoSecondary", "Hip", "HipSecondary", "RightShoulder", "RightArm", "RightLowerArm", "DragonFoot1",
	"LeftShoulder", "LeftArm", "LeftLowerArm", "DragonFoot2", "RightThigh", "RightLeg", "RightLowerLeg",
	"DragonFoot3", "LegFluff1", "LeftThigh", "LeftLeg", "LeftLowerLeg", "DragonFoot4", "LegFluff2",
	"Tail1", "Tail2", "Tail3", "Tail5", "TailFluff1", "TailFluff2", "TailFluff3", "TailFluff4",
	"DragonTip", "OceanTailPrimary", "OceanFin",
	"DragonSpike1", "DragonSpike2", "DragonSpike3", "DragonSpike4", "DragonSpike5", "DragonSpike6",
	"DragonSpike7", "DragonSpike8", "DragonSpike9", "DragonSpike10",
	"DragonClaws1", "DragonClaws2", "DragonClaws3", "DragonClaws4", "DragonDewClaw1", "DragonDewClaw2",
	"DragonWingL1", "DragonWingL2", "DragonWingL3", "DragonWingL4", "DragonWingL5",
	"DragonWingR1", "DragonWingR2", "DragonWingR3", "DragonWingR4", "DragonWingR5",
	"DragonLSkin1", "DragonLSkin2", "DragonLSkin3", "DragonLSkin4",
	"DragonRSkin1", "DragonRSkin2", "DragonRSkin3", "DragonRSkin4",
	"DragonWingLDew", "DragonWingRDew", "LeftWingStart", "RightWingStart",
	"DragonHornBig1", "DragonHornBig2", "DragonHornSmall1-1", "DragonHornSmall1-2",
	"DragonHornSmall2-1", "DragonHornSmall2-2", "DragonHornTop1", "DragonHornTop2", "DragonHornTop3",
	"LeftWing2", "LeftWing3", "RightWing2", "RightWing3",
	"Ocean1Primary", "Ocean1Secondary", "Ocean2Primary", "Ocean2Secondary",
	"OceanTailSecondary", "OceanDot1", "OceanDot2", "OceanDot3", "OceanDot4",
	"OceanSecondary1", "OceanSecondary2", "OceanSecondary3", "Neck", "BackFluff", "ChestFluff", "FrontChestFluff", "UpperTooth1",
	"UpperTooth2", "Tooth3", "Tooth4", "LeftEar", "RightEar", "InsideEars1", "InsideEars2", "RightArmPaw", "LeftArmPaw",
	"RightFootPaw", "LeftFootPaw", "Claws1", "Claws2", "Claws3", "Claws4",
}

-- every Roblox material, straight from the enum
local MaterialOptions = {}
for _, m in ipairs(Enum.Material:GetEnumItems()) do
	if m.Name ~= "Air" then table.insert(MaterialOptions, m.Name) end
end
table.sort(MaterialOptions)

------------------------------------------------------------------------
-- CREDITS
------------------------------------------------------------------------
local Section = UI:NewSection("Credits")

Section.NewProfile({
	Title = "Welcome to Aero UI",
})

Section.NewParagraph({
	"Made by rFlixzypoo",
	"Assets from q_ow2",
	"Free and Open Source",
	"Version: 1.1.0",
	"Flixz is a simp for his girlfriend <3",
})

------------------------------------------------------------------------
-- MAIN FUNCTIONS
------------------------------------------------------------------------
local Section = UI:NewSection("Main Functions")

Section.NewButton({
	Text = "Rejoin",
	Callback = function()
		local TeleportService = game:GetService("TeleportService")
		TeleportService:Teleport(game.PlaceId, LocalPlayer)
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

------------------------------------------------------------------------
-- CUSTOMIZATION
------------------------------------------------------------------------
local Section = UI:NewSection("Customization")

-- saved / default values (all of these persist between sessions)
local chosenColor   = Library.DecodeColor(UI:GetSetting("Color")) or Color3.fromRGB(0, 0, 0)
local Material      = UI:GetSetting("Material", "Neon")
local Parts         = UI:GetSetting("Parts", { "EyeColor1" })
local AccessoryName = UI:GetSetting("Accessory", AccessoryNames[1])
local Value         = table.find(AccessoryNames, AccessoryName) or 1
local Variant       = UI:GetSetting("Variant", "")
if type(Parts) ~= "table" then Parts = { "EyeColor1" } end

-- ---- material variant helpers ----
local function listVariants()
	local names, seen = {}, {}
	for _, v in ipairs(MaterialService:GetDescendants()) do
		if v:IsA("MaterialVariant") and not seen[v.Name] then
			seen[v.Name] = true
			table.insert(names, v.Name)
		end
	end
	return names
end

-- returns variantName, baseMaterialName for a colormap ID (e.g. 123456 or "rbxassetid://123456")
local function findVariantByColorMap(id)
	local want = tostring(id):match("%d+")
	if not want then return nil end
	for _, v in ipairs(MaterialService:GetDescendants()) do
		if v:IsA("MaterialVariant") then
			local ok, cm = pcall(function() return v.ColorMap end)
			if ok and cm then
				for digits in tostring(cm):gmatch("%d+") do
					if digits == want then
						return v.Name, v.BaseMaterial.Name
					end
				end
			end
		end
	end
	return nil
end

Section.NewDropdown({
	Text = "Select Accessory",
	Default = AccessoryName,
	Options = AccessoryNames,
	Callback = function(option)
		UI:Notify("Accessory Selected", "You selected: " .. option, 2)
		Value = table.find(AccessoryNames, option) or 1
		UI:SetSetting("Accessory", option)
	end
})

local PartsDropdown = Section.NewDropdown({
	Text = "Parts to Color",
	Multi = true,
	Default = Parts,
	Options = PartOptions,
	Callback = function(selectedParts)
		Parts = selectedParts
		UI:SetSetting("Parts", selectedParts)
	end
})

Section.NewDropdown({
	Text = "Select Material",
	Default = Material,
	Options = MaterialOptions,
	Callback = function(option)
		UI:Notify("Material Selected", "You selected: " .. option, 2)
		Material = option
		UI:SetSetting("Material", option)
	end
})

local VariantBox = Section.NewAutoTextBox({
	Text = "Variant",
	Placeholder = "Name or colormap ID...",
	SnapOnEnter = false,
	Default = Variant,
	GetOptions = listVariants,
})

Section.NewButton({
	Text = "Set Variant",
	Callback = function()
		local text = (VariantBox.GetText():gsub("^%s*(.-)%s*$", "%1"))

		if text == "" then
			Variant = ""
			UI:SetSetting("Variant", "")
			UI:Notify("Variant", "Cleared", 2)
			return
		end

		if (text:match("%d+") and not text:match("%a")) or text:lower():find("rbxassetid") then
			local name, base = findVariantByColorMap(text)
			if not name then
				UI:Notify("Variant", "No variant uses that colormap ID", 3)
				return
			end
			Variant = name
			Material = base              -- a variant only works on its base material
			UI:SetSetting("Material", base)
			VariantBox.SetText(name)
			UI:Notify("Variant", name .. " (" .. base .. ")", 3)
		else
			local name = VariantBox.GetResolved()
			if not name then
				UI:Notify("Variant", "No variant with that name", 3)
				return
			end
			Variant = name
			UI:Notify("Variant", name, 2)
		end
		UI:SetSetting("Variant", Variant)
	end
})

Section.NewColorPicker({
	Text = "Color",
	Default = chosenColor,
	Callback = function(color)
		chosenColor = color
		UI:SetSetting("Color", Library.EncodeColor(color))
	end
})

Section.NewButton({
	Text = "Set Name Color",
	Callback = function()
		local Event = ReplicatedStorage.Events["UpdateSetting"]
		Event:InvokeServer("ChangeColor", { chosenColor.R, chosenColor.G, chosenColor.B })
	end
})

Section.NewButton({
	Text = "Set Accessory Color/Material",
	Callback = function()
		local Event = ReplicatedStorage.Events["ColorAccessory"]
		for _, target in ipairs({ "Color1", "MeshPart", "Piercing", "Hat" }) do
			Event:FireServer("Color", Value, target, chosenColor, {
				Material = Material,
				MaterialVariant = Variant,
			})
		end
	end
})

Section.NewButton({
	Text = "Set Part Color/Material",
	Callback = function()
		if #Parts == 0 then
			UI:Notify("Parts", "Select at least one part first", 2)
			return
		end
		local Event = ReplicatedStorage.Events.UpdateColor
		for _, partName in ipairs(Parts) do
			Event:FireServer("Color", partName, chosenColor, {
				Material = Material,
				MaterialVariant = Variant,
			})
		end
		UI:Notify("Applied", #Parts .. " part(s) updated", 2)
	end
})

------------------------------------------------------------------------
-- COLOR FADE  (own tab, own state - independent of Customization)
------------------------------------------------------------------------
local Section = UI:NewSection("Color Fade")

do
	local SEND_INTERVAL = 0.1   -- seconds between sends (raise if the game lags)
	local ACC_TARGETS   = { "Color1", "MeshPart", "Piercing", "Hat" }

	-- only keep names that exist in the master lists (protects against bad saved data)
	local validPart, validAcc = {}, {}
	for _, n in ipairs(PartOptions)     do validPart[n] = true end
	for _, n in ipairs(AccessoryNames)  do validAcc[n]  = true end

	local function cleanList(list, valid)
		local out = {}
		if type(list) == "table" then
			for _, n in ipairs(list) do
				if type(n) == "string" and valid[n] then table.insert(out, n) end
			end
		end
		return out
	end

	-- all fade state lives here; nothing else in the script touches it
	local S = {
		Colors = {
			Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 255, 255),
			Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255),
		},
		Slot = 1, Phase = 0, SendAcc = 0, Sig = "", Conn = nil, Warned = false,
	}

	-- load saved settings
	local savedColors = UI:GetSetting("FadeColors")
	if type(savedColors) == "table" then
		for i = 1, #S.Colors do
			local c = Library.DecodeColor(savedColors[i])
			if c then S.Colors[i] = c end
		end
	end
	S.Count  = math.clamp(tonumber(UI:GetSetting("FadeCount", 3)) or 3, 2, #S.Colors)
	S.Tenths = math.clamp(tonumber(UI:GetSetting("FadeTenths", 10)) or 10, 1, 100)

	local savedParts = UI:GetSetting("FadeParts")
	S.Parts = (savedParts ~= nil) and cleanList(savedParts, validPart) or table.clone(PartOptions)

	S.Material = UI:GetSetting("FadeMaterial", "Neon")
	if type(S.Material) ~= "string" then S.Material = "Neon" end

	-- accessories are now a LIST (new save key; migrates the old single-name save if valid)
	local savedAcc = UI:GetSetting("FadeAccessories")
	if savedAcc ~= nil then
		S.Accessories = cleanList(savedAcc, validAcc)
	else
		local old = UI:GetSetting("FadeAccessory")
		S.Accessories = (type(old) == "string" and validAcc[old]) and { old } or {}
	end
	S.UseAccessory = UI:GetSetting("FadeUseAccessory", false) == true

	local function saveColors()
		local out = {}
		for i, c in ipairs(S.Colors) do out[i] = Library.EncodeColor(c) end
		UI:SetSetting("FadeColors", out)
	end

	local function hasTargets()
		return #S.Parts > 0 or (S.UseAccessory and #S.Accessories > 0)
	end

	local function currentColor()
		local n    = S.Count
		local base = math.floor(S.Phase)
		local frac = S.Phase - base
		local a    = S.Colors[base % n + 1]
		local b    = S.Colors[(base + 1) % n + 1]
		local alpha = TweenService:GetValue(frac, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		return a:Lerp(b, alpha)
	end

	local function send(color)
		local events = ReplicatedStorage:FindFirstChild("Events")
		if not events then return end
		local UpdateColor    = events:FindFirstChild("UpdateColor")
		local ColorAccessory = events:FindFirstChild("ColorAccessory")
		local data = { Material = S.Material, MaterialVariant = "" }

		if UpdateColor then
			for _, partName in ipairs(S.Parts) do
				UpdateColor:FireServer("Color", partName, color, data)
			end
		end
		if S.UseAccessory and ColorAccessory then
			for _, accName in ipairs(S.Accessories) do
				local id = table.find(AccessoryNames, accName)
				if id then
					for _, target in ipairs(ACC_TARGETS) do
						ColorAccessory:FireServer("Color", id, target, color, data)
					end
				end
			end
		end
	end

	-- one tick of work; runs inside pcall so nothing in here can kill the fade
	local function tick()
		if not hasTargets() then
			S.Sig = ""   -- nothing selected: stay on, stay idle
			return
		end

		local color = currentColor()
		local r = math.floor(color.R * 255 + 0.5)
		local g = math.floor(color.G * 255 + 0.5)
		local b = math.floor(color.B * 255 + 0.5)

		-- only send when the color OR the fade's own selections changed
		local sig = table.concat({
			r, g, b, S.Material,
			S.UseAccessory and table.concat(S.Accessories, ",") or "-",
			table.concat(S.Parts, ","),
		}, "|")
		if sig == S.Sig then return end
		S.Sig = sig

		send(color)
	end

	local function step(dt)
		S.Phase   = (S.Phase + dt / (S.Tenths / 10)) % S.Count
		S.SendAcc = S.SendAcc + dt
		if S.SendAcc < SEND_INTERVAL then return end
		S.SendAcc = 0

		local ok, err = pcall(tick)
		if not ok and not S.Warned then
			S.Warned = true   -- warn once instead of spamming every tick
			warn("[ColorFade] " .. tostring(err))
		end
	end

	local function setFade(on)
		if on and not S.Conn then
			S.Sig = ""
			S.Warned = false
			S.Conn = RunService.Heartbeat:Connect(step)
		elseif not on and S.Conn then
			S.Conn:Disconnect()
			S.Conn = nil
		end
	end
	UI.ScreenGui.Destroying:Connect(function() setFade(false) end)

	-- ---------------- controls ----------------
	Section.NewToggle({
		Text = "Color Fade",
		Callback = function(on)
			setFade(on)   -- start/stop first so a notification problem can never block it
			if on then
				if not hasTargets() then
					UI:Notify("Color Fade", "On, but nothing selected yet", 3)
				else
					local accText = (S.UseAccessory and #S.Accessories > 0)
						and (" | " .. #S.Accessories .. " accessories") or ""
					UI:Notify("Color Fade", string.format("%d parts | %s%s", #S.Parts, S.Material, accText), 3)
				end
			end
		end
	})

	local fadePartsDropdown = Section.NewDropdown({
		Text = "Fade Parts",
		Multi = true,
		Default = S.Parts,
		Options = PartOptions,
		Callback = function(selected)
			S.Parts = cleanList(selected, validPart)   -- deselecting everything is fine
			UI:SetSetting("FadeParts", S.Parts)
		end
	})

	Section.NewDropdown({
		Text = "Fade Material",
		Default = S.Material,
		Options = MaterialOptions,
		Callback = function(option)
			S.Material = option
			UI:SetSetting("FadeMaterial", option)
		end
	})

	Section.NewToggle({
		Text = "Fade Accessories Too",
		Default = S.UseAccessory,
		Callback = function(on)
			S.UseAccessory = on
			UI:SetSetting("FadeUseAccessory", on)
		end
	})

	Section.NewDropdown({
		Text = "Fade Accessories",
		Multi = true,
		Default = S.Accessories,
		Options = AccessoryNames,
		Callback = function(selected)
			S.Accessories = cleanList(selected, validAcc)   -- a list, not a single name
			UI:SetSetting("FadeAccessories", S.Accessories)
		end
	})

	Section.NewSlider({
		Text = "Fade Time (x0.1s)", Min = 1, Max = 100, Value = S.Tenths,
		Callback = function(v)
			S.Tenths = math.max(v, 1)
			UI:SetSetting("FadeTenths", S.Tenths)
		end
	})

	Section.NewSlider({
		Text = "Colors Used", Min = 2, Max = #S.Colors, Value = S.Count,
		Callback = function(v)
			S.Count = math.clamp(v, 2, #S.Colors)
			UI:SetSetting("FadeCount", S.Count)
		end
	})

	local slotNames = {}
	for i = 1, #S.Colors do slotNames[i] = "Color " .. i end

	local fadePicker
	Section.NewDropdown({
		Text = "Edit Fade Color",
		Default = "Color 1",
		Options = slotNames,
		Callback = function(opt)
			S.Slot = tonumber(opt:match("%d+")) or 1
			fadePicker.SetColor(S.Colors[S.Slot])
		end
	})

	fadePicker = Section.NewColorPicker({
		Text = "Fade Color",
		Default = S.Colors[1],
		Callback = function(c)
			S.Colors[S.Slot] = c   -- live: the loop reads this every frame
			saveColors()
		end
	})
end

------------------------------------------------------------------------
-- COPY DESIGN
------------------------------------------------------------------------
local Section = UI:NewSection("Copy Design")

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

------------------------------------------------------------------------
-- MY OCs
------------------------------------------------------------------------
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

------------------------------------------------------------------------
-- SETTINGS
------------------------------------------------------------------------
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
	Default = UI:GetPreset(),
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
	Text = "Reset Saved Settings",
	Callback = function()
		UI:ClearSettings({ "OCs" })   -- keeps your saved OCs
		UI:ResetTheme()
		syncPicker()
		UI:Notify("Reset", "Settings cleared (OCs kept)", 2)
	end
})

Section.NewKeybind({
	Text = "Toggle UI Key",
	Default = UI:GetSetting("ToggleKey", "F1"),
	Changed = function(key)
		UI:SetToggleKey(key)
	end
})
