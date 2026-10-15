--Aero UI
--//Version 0.9.1
local Library = {}
Library.__index = Library

local Players         = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService    = game:GetService("TweenService")
local CoreGui         = game:GetService("CoreGui")
local Player          = Players.LocalPlayer

local Config = {
    Theme = {
        Primary    = Color3.fromRGB(28, 28, 36),
        Secondary  = Color3.fromRGB(20, 20, 26),
        Elevated   = Color3.fromRGB(38, 38, 50),
        Accent     = Color3.fromRGB(110, 100, 255),
        AccentHover= Color3.fromRGB(140, 130, 255),
        Edge       = Color3.fromRGB(70, 65, 120),
        Text       = Color3.fromRGB(240, 240, 255),
        TextDim    = Color3.fromRGB(140, 138, 165),
        Success    = Color3.fromRGB(60, 210, 120),
        Error      = Color3.fromRGB(255, 75, 75),
        Close      = Color3.fromRGB(28, 28, 36),
        CloseText  = Color3.fromRGB(110, 100, 255),
    },
    Size  = UDim2.new(0, 380, 0, 480),
    Title = "Aero UI Library | I love my girlfriend <3",
}

local TI_FAST   = TweenInfo.new(0.18, Enum.EasingStyle.Quint)
local TI_MED    = TweenInfo.new(0.28, Enum.EasingStyle.Quint)
local TI_SLOW   = TweenInfo.new(0.4,  Enum.EasingStyle.Quint)
local ITEM_PAD  = 6
local CORNER    = 8

local PARENT = game:GetService("RunService"):IsStudio()
    and Player:FindFirstChild("PlayerGui") or CoreGui

for _, v in next, PARENT:GetChildren() do
    if v.Name == "AeroUI" then v:Destroy() end
end

local function Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or CORNER)
    c.Parent = parent
    return c
end

local function Stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color     = color or Config.Theme.Edge
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent    = parent
    return s
end

local function Label(parent, props)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text           = props.Text      or ""
    l.TextColor3     = props.Color     or Config.Theme.Text
    l.TextSize       = props.Size      or 13
    l.Font           = Enum.Font.GothamMedium
    l.TextXAlignment = props.AlignX    or Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.Size           = props.FrameSize or UDim2.new(1, 0, 1, 0)
    l.Position       = props.Pos       or UDim2.new(0, 0, 0, 0)
    l.Parent         = parent
    return l
end

local function Tween(obj, info, props)
    TweenService:Create(obj, info, props):Play()
end

local function HoverGlow(frame, stroke)
    frame.MouseEnter:Connect(function()
        Tween(stroke, TI_FAST, { Color = Config.Theme.Accent, Thickness = 1.5 })
    end)
    frame.MouseLeave:Connect(function()
        Tween(stroke, TI_FAST, { Color = Config.Theme.Edge, Thickness = 1 })
    end)
end

local THEME_KEYS = { "Primary", "Secondary", "Elevated", "Accent", "AccentHover", "Edge", "Text", "TextDim", "Success", "Error" }

local DefaultTheme = {}
for k, v in next, Config.Theme do DefaultTheme[k] = v end

local THEME_PROPS = {
    Frame          = { "BackgroundColor3" },
    TextLabel      = { "BackgroundColor3", "TextColor3" },
    TextButton     = { "BackgroundColor3", "TextColor3" },
    TextBox        = { "BackgroundColor3", "TextColor3", "PlaceholderColor3" },
    ScrollingFrame = { "BackgroundColor3", "ScrollBarImageColor3" },
    UIStroke       = { "Color" },
}

local PresetOrder = { "Default", "Crimson", "Ocean", "Emerald", "Sunset", "Midnight", "CoastalPink" }
local ThemePresets = {
    Default  = DefaultTheme,
    Crimson  = { Primary = Color3.fromRGB(36, 26, 28), Secondary = Color3.fromRGB(26, 18, 20), Elevated = Color3.fromRGB(52, 36, 40),
                 Accent = Color3.fromRGB(255, 70, 85), AccentHover = Color3.fromRGB(255, 115, 125), Edge = Color3.fromRGB(120, 60, 68),
                 Text = Color3.fromRGB(255, 240, 242), TextDim = Color3.fromRGB(170, 140, 146) },
    Ocean    = { Primary = Color3.fromRGB(22, 30, 40), Secondary = Color3.fromRGB(15, 22, 30), Elevated = Color3.fromRGB(30, 42, 56),
                 Accent = Color3.fromRGB(50, 170, 255), AccentHover = Color3.fromRGB(110, 200, 255), Edge = Color3.fromRGB(50, 90, 125),
                 Text = Color3.fromRGB(235, 245, 255), TextDim = Color3.fromRGB(130, 150, 170) },
    Emerald  = { Primary = Color3.fromRGB(22, 34, 28), Secondary = Color3.fromRGB(15, 25, 20), Elevated = Color3.fromRGB(30, 48, 38),
                 Accent = Color3.fromRGB(50, 215, 130), AccentHover = Color3.fromRGB(110, 240, 175), Edge = Color3.fromRGB(50, 110, 80),
                 Text = Color3.fromRGB(236, 255, 244), TextDim = Color3.fromRGB(130, 165, 145) },
    Sunset   = { Primary = Color3.fromRGB(38, 28, 24), Secondary = Color3.fromRGB(28, 20, 17), Elevated = Color3.fromRGB(54, 40, 34),
                 Accent = Color3.fromRGB(255, 150, 50), AccentHover = Color3.fromRGB(255, 185, 110), Edge = Color3.fromRGB(125, 85, 55),
                 Text = Color3.fromRGB(255, 246, 236), TextDim = Color3.fromRGB(175, 150, 130) },
    Midnight = { Primary = Color3.fromRGB(18, 18, 18), Secondary = Color3.fromRGB(10, 10, 10), Elevated = Color3.fromRGB(32, 32, 32),
                 Accent = Color3.fromRGB(230, 230, 230), AccentHover = Color3.fromRGB(255, 255, 255), Edge = Color3.fromRGB(70, 70, 70),
                 Text = Color3.fromRGB(245, 245, 245), TextDim = Color3.fromRGB(140, 140, 140) },
    CoastalPink = { Primary = Color3.fromRGB(40, 28, 34), Secondary = Color3.fromRGB(30, 20, 26), Elevated = Color3.fromRGB(58, 40, 50),
                 Accent = Color3.fromRGB(255, 128, 176), AccentHover = Color3.fromRGB(255, 170, 205), Edge = Color3.fromRGB(135, 80, 105),
                 Text = Color3.fromRGB(255, 242, 248), TextDim = Color3.fromRGB(180, 145, 162) },
}

local ThemeMap = {}
local Pending  = {}

local function Raw(inst)
    inst:SetAttribute("NoTheme", true)
    return inst
end

local function tagInstance(inst)
    local props = THEME_PROPS[inst.ClassName]
    if not props or inst:GetAttribute("NoTheme") then return end
    for _, prop in ipairs(props) do
        local attr = "Theme_" .. prop
        if inst:GetAttribute(attr) == nil then
            local current = inst[prop]
            for _, key in ipairs(THEME_KEYS) do
                if Config.Theme[key] == current then
                    inst:SetAttribute(attr, key)
                    break
                end
            end
        end
    end
end

local function TrackTheme(root)
    for _, d in ipairs(root:GetDescendants()) do tagInstance(d) end
    root.DescendantAdded:Connect(tagInstance)
end

local function pickKey(inst, prop, old)
    local current = inst[prop]
    local role = inst:GetAttribute("Theme_" .. prop)
    if role and old[role] == current then return role end   
    for _, key in ipairs(THEME_KEYS) do                      
        if old[key] == current then return key end
    end
    return role                                              
end

local function commit(gui, changes)
    local old = {}
    for k, v in next, Config.Theme do old[k] = v end

    for key, color in next, changes do
        if Config.Theme[key] ~= nil and typeof(color) == "Color3" then
            Config.Theme[key] = color
            if key == "Accent" then Config.Theme.CloseText = color
            elseif key == "Primary" then Config.Theme.Close = color end
        end
    end

    if not gui then
        warn("[AeroUI] theme: no ScreenGui to recolor")
        return
    end

    local count, warned = 0, false
    for _, inst in ipairs(gui:GetDescendants()) do
        local props = THEME_PROPS[inst.ClassName]
        if props and not inst:GetAttribute("NoTheme") then
            local ok, err = pcall(function()
                for _, prop in ipairs(props) do
                    local key = pickKey(inst, prop, old)
                    if key then
                        inst[prop] = Config.Theme[key]
                        count = count + 1
                    end
                end
            end)
            if not ok and not warned then
                warned = true
                warn("[AeroUI] theme error: " .. tostring(err))
            end
        end
    end
    if count == 0 then warn("[AeroUI] theme: nothing was recolored") end
end

function Library:SetTheme(key, color) commit(self.ScreenGui, { [key] = color }) end
function Library:GetTheme(key)        return Config.Theme[key] end
function Library:ApplyPreset(name)    if ThemePresets[name] then commit(self.ScreenGui, ThemePresets[name]) end end
function Library:ResetTheme()         commit(self.ScreenGui, DefaultTheme) end
function Library:GetPresetNames()     return table.clone(PresetOrder) end

local NotifContainer
local function GetNotifContainer()
    if NotifContainer then return NotifContainer end
    NotifContainer = Instance.new("Frame")
    NotifContainer.BackgroundTransparency = 1
    NotifContainer.Size     = UDim2.new(0, 300, 0, 0)
    NotifContainer.Position = UDim2.new(0.5, -150, 0, 20)
    NotifContainer.ZIndex   = 9999
    NotifContainer.Name     = "AeroNotifications"
    NotifContainer.Parent   = CoreGui
    return NotifContainer
end

function Library:Notify(title, message, duration)
    local c = GetNotifContainer()

    local notif = Instance.new("Frame")
    notif.BackgroundColor3 = Config.Theme.Elevated
    notif.BorderSizePixel  = 0
    notif.Size             = UDim2.new(1, 0, 0, 64)
    notif.Position         = UDim2.new(0, 0, 0, -70)
    notif.Parent           = c
    Corner(notif, 10)
    Stroke(notif, Config.Theme.Accent, 1)

    local bar = Instance.new("Frame")
    bar.BackgroundColor3 = Config.Theme.Accent
    bar.BorderSizePixel  = 0
    bar.Size             = UDim2.new(0, 3, 1, -16)
    bar.Position         = UDim2.new(0, 8, 0, 8)
    bar.Parent           = notif
    Corner(bar, 4)

    Label(notif, { Text = title,   Color = Config.Theme.Text,    Size = 13, Pos = UDim2.new(0, 20, 0, 8),  FrameSize = UDim2.new(1, -28, 0, 22) })
    Label(notif, { Text = message, Color = Config.Theme.TextDim, Size = 11, Pos = UDim2.new(0, 20, 0, 32), FrameSize = UDim2.new(1, -28, 0, 20) })

    Tween(notif, TI_MED, { Position = UDim2.new(0, 0, 0, 0) })
    task.delay(duration or 3.5, function()
        Tween(notif, TI_MED, { Position = UDim2.new(0, 0, 0, -70) })
        task.delay(0.35, function() notif:Destroy() end)
    end)
end

function Library.new()
    local self = setmetatable({}, Library)

    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name           = "AeroUI"
    self.ScreenGui.ResetOnSpawn   = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent         = PARENT
    TrackTheme(self.ScreenGui)

    local glowRing = Instance.new("Frame")
    glowRing.BackgroundTransparency = 1
    glowRing.BorderSizePixel        = 0
    glowRing.Size                   = Config.Size
    glowRing.Position               = UDim2.new(0.5, -190, 0.5, -240)
    glowRing.ZIndex                 = 0
    glowRing.Name                   = "GlowRing"
    glowRing.Parent                 = self.ScreenGui
    Corner(glowRing, 14)

    local g1 = Instance.new("Frame")
    g1.BackgroundColor3       = Config.Theme.Accent
    g1.BackgroundTransparency = 0.6
    g1.BorderSizePixel        = 0
    g1.Size                   = UDim2.new(1, 8, 1, 8)
    g1.Position               = UDim2.new(0, -4, 0, -4)
    g1.ZIndex                 = 0
    g1.Parent                 = glowRing
    Corner(g1, 16)

    local g2 = Instance.new("Frame")
    g2.BackgroundColor3       = Config.Theme.Accent
    g2.BackgroundTransparency = 0.78
    g2.BorderSizePixel        = 0
    g2.Size                   = UDim2.new(1, 20, 1, 20)
    g2.Position               = UDim2.new(0, -10, 0, -10)
    g2.ZIndex                 = 0
    g2.Parent                 = glowRing
    Corner(g2, 22)

    local g3 = Instance.new("Frame")
    g3.BackgroundColor3       = Config.Theme.Accent
    g3.BackgroundTransparency = 0.90
    g3.BorderSizePixel        = 0
    g3.Size                   = UDim2.new(1, 40, 1, 40)
    g3.Position               = UDim2.new(0, -20, 0, -20)
    g3.ZIndex                 = 0
    g3.Parent                 = glowRing
    Corner(g3, 30)

    self.Window = Instance.new("Frame")
    self.Window.BackgroundTransparency = 1
    self.Window.BorderSizePixel  = 0
    self.Window.Size             = Config.Size
    self.Window.Position         = UDim2.new(0.5, -190, 0.5, -240)
    self.Window.Name             = "Window"
    self.Window.Parent           = self.ScreenGui
    local windowCorner = Corner(self.Window, 12)
    Stroke(self.Window, Config.Theme.Accent, 1.5)

    local winBg = Instance.new("Frame")
    winBg.BackgroundColor3 = Config.Theme.Secondary
    winBg.BorderSizePixel  = 0
    winBg.Size             = UDim2.new(1, 0, 1, 0)
    winBg.Parent           = self.Window
    local winBgCorner = Corner(winBg, 12)

    local titleBar = Instance.new("Frame")
    titleBar.BackgroundColor3 = Config.Theme.Primary
    titleBar.BorderSizePixel  = 0
    titleBar.Size             = UDim2.new(1, 0, 0, 38)
    titleBar.Name             = "TitleBar"
    titleBar.Parent           = self.Window
    local titleCorner = Corner(titleBar, 12)

    local titleFill = Instance.new("Frame")
    titleFill.BackgroundColor3 = Config.Theme.Primary
    titleFill.BorderSizePixel  = 0
    titleFill.Size             = UDim2.new(1, 0, 0, 12)
    titleFill.Position         = UDim2.new(0, 0, 1, -12)
    titleFill.Parent           = titleBar
    local titleFillCorner = Instance.new("UICorner")
    titleFillCorner.Parent = titleFill
    titleFillCorner.CornerRadius = UDim.new(0, 0)
    local titleFillOriginalSize = titleFill.Size

    local dot = Instance.new("Frame")
    dot.BackgroundColor3 = Config.Theme.Accent
    dot.BorderSizePixel  = 0
    dot.Size             = UDim2.new(0, 6, 0, 6)
    dot.Position         = UDim2.new(0, 14, 0.5, -3)
    dot.Parent           = titleBar
    Corner(dot, 3)

    Label(titleBar, { Text = Config.Title, Color = Config.Theme.Text, Size = 13, Pos = UDim2.new(0, 28, 0, 0) })

    self.IsMinimized = false
    self.ExpandedHeight = Config.Size.Y.Offset
    self.ExpandedWidth = Config.Size.X.Offset

    local minBtn = Instance.new("TextButton")
    minBtn.BackgroundColor3 = Config.Theme.Elevated
    minBtn.BorderSizePixel  = 0
    minBtn.Size             = UDim2.new(0, 18, 0, 18)
    minBtn.Position         = UDim2.new(1, -50, 0.5, -9)
    minBtn.Text             = "–"
    minBtn.TextColor3       = Config.Theme.CloseText
    minBtn.TextSize         = 14
    minBtn.Font             = Enum.Font.GothamBold
    minBtn.Name             = "MinBtn"
    minBtn.Parent           = titleBar
    Corner(minBtn, 5)
    minBtn.MouseEnter:Connect(function() Tween(minBtn, TI_FAST, { BackgroundColor3 = Config.Theme.Accent }) end)
    minBtn.MouseLeave:Connect(function() Tween(minBtn, TI_FAST, { BackgroundColor3 = Config.Theme.Elevated }) end)

    local closeBtn = Instance.new("TextButton")
    closeBtn.BackgroundColor3 = Config.Theme.Elevated
    closeBtn.BorderSizePixel  = 0
    closeBtn.Size             = UDim2.new(0, 18, 0, 18)
    closeBtn.Position         = UDim2.new(1, -26, 0.5, -9)
    closeBtn.Text             = "X"
    closeBtn.TextColor3       = Config.Theme.CloseText
    closeBtn.TextSize         = 10
    closeBtn.Font             = Enum.Font.GothamBold
    closeBtn.Name             = "CloseBtn"
    closeBtn.Parent           = titleBar
    Corner(closeBtn, 5)
    closeBtn.MouseEnter:Connect(function() Tween(closeBtn, TI_FAST, { BackgroundColor3 = Config.Theme.Accent }) end)
    closeBtn.MouseLeave:Connect(function() Tween(closeBtn, TI_FAST, { BackgroundColor3 = Config.Theme.Elevated }) end)
    closeBtn.MouseButton1Click:Connect(function() self:Destroy() end)

    local minW = Config.Size.X.Offset
    local minH = Config.Size.Y.Offset
    local resizing = false

    local resizeHandle = Instance.new("Frame")
    resizeHandle.Name = "ResizeHandle"
    resizeHandle.BackgroundColor3 = Config.Theme.Accent
    resizeHandle.BackgroundTransparency = 0.15
    resizeHandle.BorderSizePixel = 0
    resizeHandle.Size = UDim2.new(0, 16, 0, 16)
    resizeHandle.Position = UDim2.new(1, -18, 1, -18)
    resizeHandle.ZIndex = 5
    resizeHandle.Parent = self.Window
    Corner(resizeHandle, 4)
    Stroke(resizeHandle, Config.Theme.Edge, 1)

    local resizeBtn = Instance.new("TextButton")
    resizeBtn.BackgroundTransparency = 1
    resizeBtn.Size = UDim2.new(1, 0, 1, 0)
    resizeBtn.Text = ""
    resizeBtn.Parent = resizeHandle

    local resizeStartMouse, resizeStartSize

    resizeBtn.MouseButton1Down:Connect(function()
        resizing = true
        local startMouse = UserInputService:GetMouseLocation()
        resizeStartMouse = Vector2.new(startMouse.X, startMouse.Y)
        resizeStartSize = self.Window.Size
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local currentMouse = UserInputService:GetMouseLocation()
            local deltaX = currentMouse.X - resizeStartMouse.X
            local deltaY = currentMouse.Y - resizeStartMouse.Y

            local newW = math.max(minW, resizeStartSize.X.Offset + deltaX)
            local newH = math.max(minH, resizeStartSize.Y.Offset + deltaY)

            self.Window.Size = UDim2.new(0, newW, 0, newH)
            glowRing.Size    = UDim2.new(0, newW, 0, newH)
        end
    end)

    local dragging, dragInput, mousePos, framePos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and not resizing then
            dragging = true; mousePos = input.Position; framePos = self.Window.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging and not resizing then
            local d = input.Position - mousePos
            local newPos = UDim2.new(framePos.X.Scale, framePos.X.Offset + d.X, framePos.Y.Scale, framePos.Y.Offset + d.Y)
            self.Window.Position = newPos
            glowRing.Position    = newPos
        end
    end)

    self.TabBar = Instance.new("Frame")
    self.TabBar.BackgroundColor3 = Config.Theme.Primary
    self.TabBar.BorderSizePixel  = 0
    self.TabBar.Size             = UDim2.new(0, 110, 1, -38)
    self.TabBar.Position         = UDim2.new(0, 0, 0, 38)
    self.TabBar.Name             = "TabBar"
    self.TabBar.Parent           = self.Window
    Corner(self.TabBar, 12)

    local tabBarTopFill = Instance.new("Frame")
    tabBarTopFill.BackgroundColor3 = Config.Theme.Primary
    tabBarTopFill.BorderSizePixel  = 0
    tabBarTopFill.Size             = UDim2.new(1, 0, 0, 12)
    tabBarTopFill.Position         = UDim2.new(0, 0, 0, 0)
    tabBarTopFill.Parent           = self.TabBar

    local tabBarRightFill = Instance.new("Frame")
    tabBarRightFill.BackgroundColor3 = Config.Theme.Primary
    tabBarRightFill.BorderSizePixel  = 0
    tabBarRightFill.Size             = UDim2.new(0, 12, 1, 0)
    tabBarRightFill.Position         = UDim2.new(1, -12, 0, 0)
    tabBarRightFill.Parent           = self.TabBar

    local divider = Instance.new("Frame")
    divider.BackgroundColor3 = Config.Theme.Edge
    divider.BorderSizePixel  = 0
    divider.Size             = UDim2.new(0, 1, 1, -38)
    divider.Position         = UDim2.new(0, 110, 0, 38)
    divider.Parent           = self.Window

    self.Content = Instance.new("Frame")
    self.Content.BackgroundTransparency = 1
    self.Content.Size     = UDim2.new(1, -111, 1, -38)
    self.Content.Position = UDim2.new(0, 111, 0, 38)
    self.Content.Name     = "Content"
    self.Content.Parent   = self.Window

    self.TabYOffset = 8
    self.CurrentTab = nil

    local function setMinimized(minimized)
        if minimized == self.IsMinimized then return end
        self.IsMinimized = minimized

        local currentW = self.Window.Size.X.Offset
        local titleH = titleBar.Size.Y.Offset

        if minimized then
            self.ExpandedHeight = math.max(titleH, self.Window.Size.Y.Offset)
            self.ExpandedWidth = math.max(minW, self.Window.Size.X.Offset)
            self.TabBar.Visible = false
            self.Content.Visible = false
            divider.Visible = false
            resizeHandle.Visible = false

            local minimizedRadius = math.floor(titleH / 2)
            windowCorner.CornerRadius = UDim.new(0, minimizedRadius)
            titleCorner.CornerRadius = UDim.new(0, minimizedRadius)
            winBgCorner.CornerRadius = UDim.new(0, minimizedRadius)
            titleFill.Visible = false
            titleFill.Size = UDim2.new(1, 0, 0, 0)
            titleBar.ClipsDescendants = true
            titleFillCorner.CornerRadius = UDim.new(0, 0)

            local minimizedW = Config.Size.X.Offset
            self.Window.Size = UDim2.new(0, minimizedW, 0, self.Window.Size.Y.Offset)
            glowRing.Size = UDim2.new(0, minimizedW, 0, glowRing.Size.Y.Offset)

            Tween(self.Window, TI_MED, { Size = UDim2.new(0, minimizedW, 0, titleH) })
            Tween(glowRing, TI_MED, { Size = UDim2.new(0, minimizedW, 0, titleH) })
            minBtn.Text = "+"
        else
            local restoreH = math.max(minH, self.ExpandedHeight or minH)
            local restoreW = Config.Size.X.Offset
            self.TabBar.Visible = true
            self.Content.Visible = true
            divider.Visible = true
            resizeHandle.Visible = true

            windowCorner.CornerRadius = UDim.new(0, 12)
            titleCorner.CornerRadius = UDim.new(0, 12)
            winBgCorner.CornerRadius = UDim.new(0, 12)
            titleFill.Visible = true
            titleFill.Size = titleFillOriginalSize
            titleBar.ClipsDescendants = false
            titleFillCorner.CornerRadius = UDim.new(0, 0)

            Tween(self.Window, TI_MED, { Size = UDim2.new(0, restoreW, 0, restoreH) })
            Tween(glowRing, TI_MED, { Size = UDim2.new(0, restoreW, 0, restoreH) })
            minBtn.Text = "–"
        end
    end

    minBtn.MouseButton1Click:Connect(function()
        setMinimized(not self.IsMinimized)
    end)

    self.ToggleKey = Enum.KeyCode.LeftShift

    function self:SetToggleKey(key)
        self.ToggleKey = key
    end

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end

        if input.KeyCode == self.ToggleKey then
            print("Toggle key pressed")

            self.Window.Visible = not self.Window.Visible

            local glow = self.ScreenGui:FindFirstChild("GlowRing")
            if glow then
                glow.Visible = self.Window.Visible
            end
        end
    end)
    return self
end

function Library:Destroy()
    if self.ScreenGui then self.ScreenGui:Destroy() end
end


function Library:NewSection(name)
    local section = {}

    local tabBtn = Instance.new("TextButton")
    tabBtn.BackgroundColor3       = Color3.fromRGB(0,0,0)
    tabBtn.BackgroundTransparency = 1
    tabBtn.BorderSizePixel        = 0
    tabBtn.Size                   = UDim2.new(1, -16, 0, 32)
    tabBtn.Position               = UDim2.new(0, 8, 0, self.TabYOffset)
    tabBtn.Text                   = name
    tabBtn.TextColor3             = Config.Theme.TextDim
    tabBtn.TextSize               = 12
    tabBtn.Font                   = Enum.Font.GothamMedium
    tabBtn.Name                   = "TabButton"
    tabBtn.Parent                 = self.TabBar
    Corner(tabBtn, 7)
    self.TabYOffset = self.TabYOffset + 36

    local indicator = Instance.new("Frame")
    indicator.BackgroundColor3     = Config.Theme.Accent
    indicator.BackgroundTransparency = 1
    indicator.BorderSizePixel      = 0
    indicator.Size                 = UDim2.new(0, 3, 0.6, 0)
    indicator.Position             = UDim2.new(0, 0, 0.2, 0)
    indicator.Parent               = tabBtn
    Corner(indicator, 2)

    tabBtn.MouseEnter:Connect(function()
        if tabBtn.BackgroundTransparency ~= 0 then
            Tween(tabBtn, TI_FAST, { BackgroundTransparency = 0.85, TextColor3 = Config.Theme.Text })
        end
    end)
    tabBtn.MouseLeave:Connect(function()
        if tabBtn.BackgroundTransparency ~= 0 then
            Tween(tabBtn, TI_FAST, { BackgroundTransparency = 1, TextColor3 = Config.Theme.TextDim })
        end
    end)

    local scroll = Instance.new("ScrollingFrame")
    scroll.BackgroundTransparency = 1
    scroll.Size                   = UDim2.new(1, 0, 1, 0)
    scroll.CanvasSize             = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize    = Enum.AutomaticSize.Y
    scroll.ScrollBarThickness     = 3
    scroll.ScrollBarImageColor3   = Config.Theme.Accent
    scroll.ScrollingDirection     = Enum.ScrollingDirection.Y
    scroll.Name                   = "Section"
    scroll.Visible                = false
    scroll.Parent                 = self.Content

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding   = UDim.new(0, ITEM_PAD)
    layout.Parent    = scroll

    local pad = Instance.new("UIPadding")
    pad.PaddingTop   = UDim.new(0, 8)
    pad.PaddingLeft  = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)
    pad.Parent       = scroll

    local order = 0
    local function nextOrder() order = order + 1; return order end

    local function activateTab()
        for _, c in ipairs(self.TabBar:GetChildren()) do
            if c:IsA("TextButton") then
                Tween(c, TI_FAST, { BackgroundTransparency = 1, TextColor3 = Config.Theme.TextDim })
                local ind = c:FindFirstChild("Frame")
                if ind then Tween(ind, TI_FAST, { BackgroundTransparency = 1 }) end
            end
        end
        for _, c in ipairs(self.Content:GetChildren()) do
            if c.Name == "Section" then c.Visible = false end
        end
        Tween(tabBtn, TI_FAST, { BackgroundTransparency = 0.75, TextColor3 = Config.Theme.Text })
        Tween(indicator, TI_FAST, { BackgroundTransparency = 0 })
        scroll.Visible  = true
        self.CurrentTab = section
    end

    tabBtn.MouseButton1Click:Connect(activateTab)

    if self.TabYOffset == 44 then activateTab() end

    local function makeRow(h)
        local row = Instance.new("Frame")
        row.BackgroundColor3 = Config.Theme.Elevated
        row.BorderSizePixel  = 0
        row.Size             = UDim2.new(1, 0, 0, h)
        row.LayoutOrder      = nextOrder()
        row.Parent           = scroll
        Corner(row, 7)
        return row
    end

    local function rowStroke(row)
        local s = Stroke(row, Config.Theme.Edge, 1)
        HoverGlow(row, s)
        return s
    end

    function section.NewButton(props)
        local row = makeRow(32)
        rowStroke(row)

        local btn = Instance.new("TextButton")
        btn.BackgroundTransparency = 1
        btn.Size          = UDim2.new(1, 0, 1, 0)
        btn.Text          = ""
        btn.Parent        = row

        local stripe = Instance.new("Frame")
        stripe.BackgroundColor3     = Config.Theme.Accent
        stripe.BackgroundTransparency = 0.5
        stripe.BorderSizePixel      = 0
        stripe.Size                 = UDim2.new(0, 3, 0.55, 0)
        stripe.Position             = UDim2.new(0, 8, 0.225, 0)
        stripe.Parent               = row
        Corner(stripe, 2)

        local lbl = Label(row, { Text = props.Text or "Button", Color = Config.Theme.Text, Size = 13, Pos = UDim2.new(0, 20, 0, 0) })

        btn.MouseEnter:Connect(function()
            Tween(row,    TI_FAST, { BackgroundColor3 = Config.Theme.Primary })
            Tween(stripe, TI_FAST, { BackgroundTransparency = 0, BackgroundColor3 = Config.Theme.AccentHover })
            Tween(lbl,    TI_FAST, { TextColor3 = Config.Theme.AccentHover })
        end)
        btn.MouseLeave:Connect(function()
            Tween(row,    TI_FAST, { BackgroundColor3 = Config.Theme.Elevated })
            Tween(stripe, TI_FAST, { BackgroundTransparency = 0.5, BackgroundColor3 = Config.Theme.Accent })
            Tween(lbl,    TI_FAST, { TextColor3 = Config.Theme.Text })
        end)
        btn.MouseButton1Down:Connect(function()
            Tween(row, TI_FAST, { BackgroundColor3 = Config.Theme.Secondary })
        end)
        btn.MouseButton1Up:Connect(function()
            Tween(row, TI_FAST, { BackgroundColor3 = Config.Theme.Primary })
        end)
        btn.MouseButton1Click:Connect(function()
            if props.Callback then props.Callback() end
        end)
        return row
    end

    function section.NewToggle(props)
        local row   = makeRow(34)
        local state = false
        local s     = rowStroke(row)

        Label(row, { Text = props.Text or "Toggle", Color = Config.Theme.Text, Size = 13, Pos = UDim2.new(0, 12, 0, 0), FrameSize = UDim2.new(1, -80, 1, 0) })

        local track = Instance.new("Frame")
        track.BackgroundColor3 = Config.Theme.Secondary
        track.BorderSizePixel  = 0
        track.Size             = UDim2.new(0, 36, 0, 20)
        track.Position         = UDim2.new(1, -48, 0.5, -10)
        track.ClipsDescendants = true
        track.Parent           = row
        Corner(track, 10)
        Stroke(track, Config.Theme.Edge, 1)

        local knob = Instance.new("Frame")
        knob.BackgroundColor3 = Config.Theme.TextDim
        knob.BorderSizePixel  = 0
        knob.Size             = UDim2.new(0, 14, 0, 14)
        knob.Position         = UDim2.new(0, 3, 0.5, -7)
        knob.Parent           = track
        Corner(knob, 7)

        local btn = Instance.new("TextButton")
        btn.BackgroundTransparency = 1
        btn.Size   = UDim2.new(1, 0, 1, 0)
        btn.Text   = ""
        btn.Parent = row

        btn.MouseEnter:Connect(function()
            Tween(s, TI_FAST, { Color = Config.Theme.Accent, Thickness = 1.5 })
        end)
        btn.MouseLeave:Connect(function()
            Tween(s, TI_FAST, { Color = Config.Theme.Edge, Thickness = 1 })
        end)
        btn.MouseButton1Click:Connect(function()
            state = not state
            if state then
                Tween(track, TI_MED, { BackgroundColor3 = Config.Theme.Accent })
                Tween(knob,  TI_MED, { Position = UDim2.new(0, 19, 0.5, -7), BackgroundColor3 = Config.Theme.Text })
            else
                Tween(track, TI_MED, { BackgroundColor3 = Config.Theme.Secondary })
                Tween(knob,  TI_MED, { Position = UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = Config.Theme.TextDim })
            end
            if props.Callback then props.Callback(state) end
        end)
        return row
    end

    function section.NewSlider(props)
        local row    = makeRow(44)
        local minVal = props.Min or 0
        local maxVal = props.Max or 100
        rowStroke(row)

        Label(row, { Text = props.Text or "Slider", Color = Config.Theme.Text, Size = 13, Pos = UDim2.new(0, 12, 0, 4), FrameSize = UDim2.new(0.7, 0, 0, 18) })
        local valLbl = Label(row, { Text = tostring(props.Value or minVal), Color = Config.Theme.Accent, Size = 12, AlignX = Enum.TextXAlignment.Right, Pos = UDim2.new(0, 0, 0, 4), FrameSize = UDim2.new(1, -12, 0, 18) })

        local track = Instance.new("Frame")
        track.BackgroundColor3 = Config.Theme.Secondary
        track.BorderSizePixel  = 0
        track.Active           = true
        track.Size             = UDim2.new(1, -24, 0, 6)
        track.Position         = UDim2.new(0, 12, 0, 30)
        track.Parent           = row
        Corner(track, 3)

        local fill = Instance.new("Frame")
        fill.BackgroundColor3 = Config.Theme.Accent
        fill.BorderSizePixel  = 0
        fill.Size             = UDim2.new(0, 0, 1, 0)
        fill.Parent           = track
        Corner(fill, 3)

        local handle = Instance.new("Frame")
        handle.BackgroundColor3 = Config.Theme.Text
        handle.BorderSizePixel  = 0
        handle.Size             = UDim2.new(0, 14, 0, 14)
        handle.AnchorPoint      = Vector2.new(0.5, 0.5)
        handle.Position         = UDim2.new(0, 12, 0, 33)
        handle.Parent           = row
        Corner(handle, 7)
        Stroke(handle, Config.Theme.Accent, 1)

        local trackLeft = 12
        local currentValue = math.clamp(props.Value or minVal, minVal, maxVal)

        local function valueToRel(value)
            if maxVal <= minVal then return 0 end
            return math.clamp((value - minVal) / (maxVal - minVal), 0, 1)
        end

        local function syncSliderVisuals()
            local tWidth = track.AbsoluteSize.X
            local relX = valueToRel(currentValue)
            fill.Size = UDim2.new(relX, 0, 1, 0)
            handle.Position = UDim2.new(0, trackLeft + relX * tWidth, 0, 33)
            valLbl.Text = tostring(currentValue)
        end

        local dragging = false
        local function update(screenX)
            local tLeft  = track.AbsolutePosition.X
            local tWidth = track.AbsoluteSize.X
            if tWidth == 0 then return end

            local relX = math.clamp((screenX - tLeft) / tWidth, 0, 1)
            currentValue = math.floor(minVal + relX * (maxVal - minVal))
            syncSliderVisuals()

            if props.Callback then props.Callback(currentValue) end
        end

        task.defer(syncSliderVisuals)
        track:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncSliderVisuals)

        local hitArea = Instance.new("TextButton")
        hitArea.BackgroundTransparency = 1
        hitArea.Size     = UDim2.new(1, -24, 0, 20)
        hitArea.Position = UDim2.new(0, 12, 0, 22)
        hitArea.Text     = ""
        hitArea.ZIndex   = 10
        hitArea.Parent   = row

        hitArea.MouseButton1Down:Connect(function()
            dragging = true
            update(UserInputService:GetMouseLocation().X)
        end)

        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
                dragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                update(i.Position.X)
            end
        end)
        local obj = { Row = row }
        function obj.SetValue(v)
            currentValue = math.clamp(math.floor(v), minVal, maxVal)
            syncSliderVisuals()
        end
        return obj
    end

    function section.NewDropdown(props)
        local itemH    = 30
        local headerH  = 32
        local maxListH = props.MaxHeight or 150
        local isOpen   = false

        local options, seen = {}, {}
        for _, opt in ipairs(props.Options or {}) do
            if not seen[opt] then
                seen[opt] = true
                table.insert(options, opt)
            end
        end

        local searchable = props.Searchable
        if searchable == nil then searchable = #options > 8 end

        local listTop      = headerH + 1 + (searchable and 32 or 0)
        local visibleCount = #options

        local function listHeight()
            return math.min(maxListH, math.max(visibleCount, 1) * itemH)
        end
        local function openHeight()
            return listTop + listHeight() + 4
        end

        local dd = Instance.new("Frame")
        dd.BackgroundColor3 = Config.Theme.Elevated
        dd.BorderSizePixel  = 0
        dd.Size             = UDim2.new(1, 0, 0, headerH)
        dd.ClipsDescendants = true
        dd.LayoutOrder      = nextOrder()
        dd.Name             = "Dropdown"
        dd.Parent           = scroll
        Corner(dd, 7)
        local ddStroke = Stroke(dd, Config.Theme.Edge, 1)

        Label(dd, { Text = props.Text or "Dropdown", Color = Config.Theme.Text, Size = 13, Pos = UDim2.new(0, 12, 0, 0), FrameSize = UDim2.new(0.65, 0, 0, 32) })
        local valLbl = Label(dd, { Text = props.Default or "Select", Color = Config.Theme.TextDim, Size = 12, AlignX = Enum.TextXAlignment.Right, Pos = UDim2.new(0, 0, 0, 0), FrameSize = UDim2.new(1, -32, 0, 32) })
        local arrow  = Label(dd, { Text = "v", Color = Config.Theme.TextDim, Size = 11, AlignX = Enum.TextXAlignment.Center, Pos = UDim2.new(1, -26, 0, 0), FrameSize = UDim2.new(0, 22, 0, 32) })

        local sep = Instance.new("Frame")
        sep.BackgroundColor3 = Config.Theme.Edge
        sep.BorderSizePixel  = 0
        sep.Size             = UDim2.new(1, -24, 0, 1)
        sep.Position         = UDim2.new(0, 12, 0, headerH)
        sep.Parent           = dd

        local searchBox
        if searchable then
            local sbBg = Instance.new("Frame")
            sbBg.BackgroundColor3 = Config.Theme.Secondary
            sbBg.BorderSizePixel  = 0
            sbBg.Size             = UDim2.new(1, -16, 0, 24)
            sbBg.Position         = UDim2.new(0, 8, 0, headerH + 6)
            sbBg.Parent           = dd
            Corner(sbBg, 5)
            local sbStroke = Stroke(sbBg, Config.Theme.Edge, 1)

            searchBox = Instance.new("TextBox")
            searchBox.BackgroundTransparency = 1
            searchBox.Text              = ""
            searchBox.PlaceholderText   = "Search..."
            searchBox.PlaceholderColor3 = Config.Theme.TextDim
            searchBox.TextColor3        = Config.Theme.Text
            searchBox.TextSize          = 12
            searchBox.Font              = Enum.Font.Gotham
            searchBox.ClearTextOnFocus  = false
            searchBox.TextXAlignment    = Enum.TextXAlignment.Left
            searchBox.Size              = UDim2.new(1, -12, 1, 0)
            searchBox.Position          = UDim2.new(0, 6, 0, 0)
            searchBox.Parent            = sbBg

            searchBox.Focused:Connect(function()
                Tween(sbStroke, TI_FAST, { Color = Config.Theme.Accent, Thickness = 1.5 })
            end)
            searchBox.FocusLost:Connect(function()
                Tween(sbStroke, TI_FAST, { Color = Config.Theme.Edge, Thickness = 1 })
            end)
        end

        local list = Instance.new("ScrollingFrame")
        list.BackgroundTransparency = 1
        list.BorderSizePixel        = 0
        list.Size                   = UDim2.new(1, 0, 0, listHeight())
        list.Position               = UDim2.new(0, 0, 0, listTop)
        list.CanvasSize             = UDim2.new(0, 0, 0, 0)
        list.AutomaticCanvasSize    = Enum.AutomaticSize.Y
        list.ScrollBarThickness     = 3
        list.ScrollBarImageColor3   = Config.Theme.Accent
        list.ScrollingDirection     = Enum.ScrollingDirection.Y
        list.Parent                 = dd

        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent    = list

        local noResults = Label(list, { Text = "No results", Color = Config.Theme.TextDim, Size = 12,
            AlignX = Enum.TextXAlignment.Center, FrameSize = UDim2.new(1, 0, 0, itemH) })
        noResults.LayoutOrder = 0
        noResults.Visible     = false

        local items = {}

        local function applyFilter()
            local q = searchBox and string.lower((searchBox.Text:gsub("^%s+", ""):gsub("%s+$", ""))) or ""
            visibleCount = 0
            for _, item in ipairs(items) do
                local match = q == "" or string.find(item.key, q, 1, true) ~= nil
                item.btn.Visible = match
                if match then visibleCount = visibleCount + 1 end
            end
            noResults.Visible = searchable and visibleCount == 0
            list.CanvasPosition = Vector2.new(0, 0)
            list.Size = UDim2.new(1, 0, 0, listHeight())
            if isOpen then
                Tween(dd, TI_FAST, { Size = UDim2.new(1, 0, 0, openHeight()) })
            end
        end

        if searchBox then
            searchBox:GetPropertyChangedSignal("Text"):Connect(applyFilter)
        end

        local function setOpen(open)
            isOpen = open
            if not open and searchBox then
                searchBox.Text = ""
                applyFilter()
            end
            Tween(arrow, TI_MED, { Rotation = open and 180 or 0 })
            Tween(dd, TI_MED, { Size = UDim2.new(1, 0, 0, open and openHeight() or headerH) })
            Tween(ddStroke, TI_FAST, {
                Color = open and Config.Theme.Accent or Config.Theme.Edge,
                Thickness = open and 1.5 or 1,
            })
        end

        for i, opt in ipairs(options) do
            local ob = Instance.new("TextButton")
            ob.BackgroundColor3       = Config.Theme.Elevated
            ob.BackgroundTransparency = 1
            ob.BorderSizePixel        = 0
            ob.Size                   = UDim2.new(1, 0, 0, itemH)
            ob.LayoutOrder            = i
            ob.Text                   = opt
            ob.TextColor3             = Config.Theme.TextDim
            ob.TextSize               = 12
            ob.Font                   = Enum.Font.Gotham
            ob.TextXAlignment         = Enum.TextXAlignment.Left
            ob.Parent                 = list
            local p = Instance.new("UIPadding"); p.PaddingLeft = UDim.new(0, 14); p.Parent = ob

            table.insert(items, { btn = ob, key = string.lower(opt) })

            ob.MouseEnter:Connect(function()
                Tween(ob, TI_FAST, { BackgroundTransparency = 0.7, TextColor3 = Config.Theme.Text })
            end)
            ob.MouseLeave:Connect(function()
                Tween(ob, TI_FAST, { BackgroundTransparency = 1, TextColor3 = Config.Theme.TextDim })
            end)
            ob.MouseButton1Click:Connect(function()
                valLbl.Text = opt
                setOpen(false)
                if props.Callback then props.Callback(opt) end
            end)
        end

        local hdrBtn = Instance.new("TextButton")
        hdrBtn.BackgroundTransparency = 1
        hdrBtn.Size   = UDim2.new(1, 0, 0, headerH)
        hdrBtn.Text   = ""
        hdrBtn.Parent = dd

        hdrBtn.MouseEnter:Connect(function()
            Tween(ddStroke, TI_FAST, { Color = Config.Theme.Accent, Thickness = 1.5 })
        end)
        hdrBtn.MouseLeave:Connect(function()
            if not isOpen then Tween(ddStroke, TI_FAST, { Color = Config.Theme.Edge, Thickness = 1 }) end
        end)
        hdrBtn.MouseButton1Click:Connect(function()
            setOpen(not isOpen)
        end)

        return dd
    end

    function section.NewTextBox(props)
        local row = makeRow(32)
        local s   = rowStroke(row)

        Label(row, { Text = props.Text or "Input", Color = Config.Theme.Text, Size = 13, Pos = UDim2.new(0, 12, 0, 0), FrameSize = UDim2.new(0.45, 0, 1, 0) })

        local tbBg = Instance.new("Frame")
        tbBg.BackgroundColor3 = Config.Theme.Secondary
        tbBg.BorderSizePixel  = 0
        tbBg.Size             = UDim2.new(0.5, -12, 0, 22)
        tbBg.Position         = UDim2.new(0.5, 0, 0.5, -11)
        tbBg.Parent           = row
        Corner(tbBg, 5)
        local tbStroke = Stroke(tbBg, Config.Theme.Edge, 1)

        local tb = Instance.new("TextBox")
        tb.BackgroundTransparency = 1
        tb.Text              = props.Default or ""
        tb.TextColor3        = Config.Theme.Text
        tb.TextSize          = 12
        tb.Font              = Enum.Font.Gotham
        tb.Size              = UDim2.new(1, -10, 1, 0)
        tb.Position          = UDim2.new(0, 5, 0, 0)
        tb.PlaceholderText   = "..."
        tb.PlaceholderColor3 = Config.Theme.TextDim
        tb.ClearTextOnFocus  = false
        tb.TextXAlignment    = Enum.TextXAlignment.Left
        tb.Parent            = tbBg

        tb.Focused:Connect(function()
            Tween(tbStroke, TI_FAST, { Color = Config.Theme.Accent, Thickness = 1.5 })
            Tween(s, TI_FAST, { Color = Config.Theme.Accent })
        end)
        tb.FocusLost:Connect(function(enter)
            Tween(tbStroke, TI_FAST, { Color = Config.Theme.Edge, Thickness = 1 })
            Tween(s, TI_FAST, { Color = Config.Theme.Edge })
            if props.Callback then props.Callback(tb.Text, enter) end
        end)
        return row
    end

    function section.NewLabel(props)
        if type(props) == "string" then
            props = { Text = props }
        end
        props = props or {}

        local row = makeRow(32)
        rowStroke(row)

        local lbl = Label(row, {
            Text      = props.Text or "Label",
            Color     = props.Color or Config.Theme.Text,
            Size      = 13,
            Pos       = UDim2.new(0, 12, 0, 0),
            FrameSize = UDim2.new(1, -24, 1, 0),
        })

        local obj = {}
        function obj.SetText(text) lbl.Text = text end
        obj.Row = row
        return obj
    end
    function section.NewParagraph(props)
        -- accepts a string, or a table of lines
        if type(props) == "string" then
            props = { Text = props }
        elseif type(props) == "table" and props.Text == nil then
            props = { Text = table.concat(props, "\n") }
        end
        props = props or {}

        local row = makeRow(0)
        row.AutomaticSize = Enum.AutomaticSize.Y
        row.Size = UDim2.new(1, 0, 0, 0)
        Stroke(row, Config.Theme.Edge, 1) -- static border, no hover glow

        local pad = Instance.new("UIPadding")
        pad.PaddingTop    = UDim.new(0, 8)
        pad.PaddingBottom = UDim.new(0, 8)
        pad.PaddingLeft   = UDim.new(0, 12)
        pad.PaddingRight  = UDim.new(0, 12)
        pad.Parent = row

        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.AutomaticSize    = Enum.AutomaticSize.Y
        lbl.Size             = UDim2.new(1, 0, 0, 0)
        lbl.Text             = props.Text or ""
        lbl.TextColor3       = props.Color or Config.Theme.Text
        lbl.TextSize         = 13
        lbl.Font             = Enum.Font.GothamMedium
        lbl.LineHeight       = 1.3
        lbl.TextWrapped      = true
        lbl.TextXAlignment   = Enum.TextXAlignment.Left
        lbl.TextYAlignment   = Enum.TextYAlignment.Top
        lbl.Parent           = row

        local obj = { Row = row }
        function obj.SetText(text) lbl.Text = text end
        return obj
    end

    function section.NewKeybind(props)
        local row       = makeRow(32)
        local isBinding = false
        local boundKey = nil

        if props.Default and Enum.KeyCode[props.Default] then
            boundKey = Enum.KeyCode[props.Default]
        end
        local s         = rowStroke(row)

        Label(row, { Text = props.Text or "Keybind", Color = Config.Theme.Text, Size = 13, Pos = UDim2.new(0, 12, 0, 0), FrameSize = UDim2.new(0.6, 0, 1, 0) })

        local badge = Instance.new("Frame")
        badge.BackgroundColor3 = Config.Theme.Secondary
        badge.BorderSizePixel  = 0
        badge.Size             = UDim2.new(0, 60, 0, 22)
        badge.Position         = UDim2.new(1, -68, 0.5, -11)
        badge.Parent           = row
        Corner(badge, 5)
        local badgeStroke = Stroke(badge, Config.Theme.Edge, 1)

        local kbLbl = Label(badge, { Text = props.Default or "None", Color = Config.Theme.TextDim, Size = 11, AlignX = Enum.TextXAlignment.Center })

        local btn = Instance.new("TextButton")
        btn.BackgroundTransparency = 1
        btn.Size   = UDim2.new(1, 0, 1, 0)
        btn.Text   = ""
        btn.Parent = row

        btn.MouseEnter:Connect(function()
            Tween(s, TI_FAST, { Color = Config.Theme.Accent, Thickness = 1.5 })
        end)
        btn.MouseLeave:Connect(function()
            if not isBinding then Tween(s, TI_FAST, { Color = Config.Theme.Edge, Thickness = 1 }) end
        end)
        btn.MouseButton1Click:Connect(function()
            isBinding = not isBinding
            if isBinding then
                Tween(badge, TI_FAST, { BackgroundColor3 = Config.Theme.Accent })
                Tween(badgeStroke, TI_FAST, { Color = Config.Theme.AccentHover })
                kbLbl.Text      = "..."
                kbLbl.TextColor3 = Config.Theme.Text
            else
                Tween(badge, TI_FAST, { BackgroundColor3 = Config.Theme.Secondary })
                Tween(badgeStroke, TI_FAST, { Color = Config.Theme.Edge })
                kbLbl.Text       = props.Default or "None"
                kbLbl.TextColor3 = Config.Theme.TextDim
                Tween(s, TI_FAST, { Color = Config.Theme.Edge, Thickness = 1 })
            end
        end)

        UserInputService.InputBegan:Connect(function(input, gp)
            
            if gp then return end

            if isBinding and input.UserInputType == Enum.UserInputType.Keyboard then
                isBinding = false
                boundKey = input.KeyCode

                kbLbl.Text = input.KeyCode.Name
                kbLbl.TextColor3 = Config.Theme.TextDim

                Tween(badge, TI_FAST, {
                    BackgroundColor3 = Config.Theme.Secondary
                })

                Tween(badgeStroke, TI_FAST, {
                    Color = Config.Theme.Edge
                })

                Tween(s, TI_FAST, {
                Color = Config.Theme.Edge,
                    Thickness = 1
                })

                return
            end

            if boundKey and input.KeyCode == boundKey then
                if props.Callback then
                    props.Callback(boundKey)
                end
            end
        end)
    return row
    end

    function section.NewColorPicker(props)
        props = props or {}
        local color = props.Default or Config.Theme.Accent
        local h, s, v = color:ToHSV()

        local row = makeRow(184)
        Stroke(row, Config.Theme.Edge, 1)

        Label(row, { Text = props.Text or "Color", Size = 13, Pos = UDim2.new(0, 12, 0, 4), FrameSize = UDim2.new(0.6, 0, 0, 18) })

        -- preview swatch
        local swatch = Raw(Instance.new("Frame"))
        swatch.BorderSizePixel  = 0
        swatch.BackgroundColor3 = color
        swatch.Size             = UDim2.new(0, 40, 0, 16)
        swatch.Position         = UDim2.new(1, -52, 0, 5)
        swatch.Parent           = row
        Corner(swatch, 4)
        Stroke(swatch, Config.Theme.Edge, 1)

        -- saturation / brightness square
        local sv = Raw(Instance.new("Frame"))
        sv.BorderSizePixel  = 0
        sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        sv.Size             = UDim2.new(1, -52, 0, 100)
        sv.Position         = UDim2.new(0, 12, 0, 28)
        sv.Parent           = row
        Corner(sv, 5)

        local white = Raw(Instance.new("Frame"))
        white.BorderSizePixel  = 0
        white.BackgroundColor3 = Color3.new(1, 1, 1)
        white.Size             = UDim2.new(1, 0, 1, 0)
        white.Parent           = sv
        Corner(white, 5)
        local wg = Instance.new("UIGradient")
        wg.Transparency = NumberSequence.new(0, 1)      -- left: opaque white -> right: clear
        wg.Parent = white

        local black = Raw(Instance.new("Frame"))
        black.BorderSizePixel  = 0
        black.BackgroundColor3 = Color3.new(0, 0, 0)
        black.Size             = UDim2.new(1, 0, 1, 0)
        black.Parent           = sv
        Corner(black, 5)
        local bg = Instance.new("UIGradient")
        bg.Rotation     = 90
        bg.Transparency = NumberSequence.new(1, 0)      -- top: clear -> bottom: opaque black
        bg.Parent = black

        local svCur = Instance.new("Frame")
        svCur.BackgroundTransparency = 1
        svCur.Size        = UDim2.new(0, 10, 0, 10)
        svCur.AnchorPoint = Vector2.new(0.5, 0.5)
        svCur.ZIndex      = 3
        svCur.Parent      = sv
        Corner(svCur, 5)
        Raw(Stroke(svCur, Color3.new(1, 1, 1), 2))

        local svHit = Instance.new("Frame")
        svHit.BackgroundTransparency = 1
        svHit.Size   = UDim2.new(1, 0, 1, 0)
        svHit.ZIndex = 4
        svHit.Active = true
        svHit.Parent = sv

        -- hue bar
        local hue = Raw(Instance.new("Frame"))
        hue.BorderSizePixel  = 0
        hue.BackgroundColor3 = Color3.new(1, 1, 1)
        hue.Size             = UDim2.new(0, 18, 0, 100)
        hue.Position         = UDim2.new(1, -30, 0, 28)
        hue.Parent           = row
        Corner(hue, 5)
        local hg = Instance.new("UIGradient")
        hg.Rotation = 90
        local keys = {}
        for i = 0, 6 do
            keys[#keys + 1] = ColorSequenceKeypoint.new(i / 6, Color3.fromHSV((i / 6) % 1, 1, 1))
        end
        hg.Color = ColorSequence.new(keys)
        hg.Parent = hue

        local hueCur = Instance.new("Frame")
        hueCur.BackgroundTransparency = 1
        hueCur.Size        = UDim2.new(1, 4, 0, 6)
        hueCur.AnchorPoint = Vector2.new(0.5, 0.5)
        hueCur.ZIndex      = 3
        hueCur.Parent      = hue
        Corner(hueCur, 3)
        Raw(Stroke(hueCur, Color3.new(1, 1, 1), 2))

        local hueHit = Instance.new("Frame")
        hueHit.BackgroundTransparency = 1
        hueHit.Size   = UDim2.new(1, 0, 1, 0)
        hueHit.ZIndex = 4
        hueHit.Active = true
        hueHit.Parent = hue

        -- R / G / B / HEX boxes
        local boxes = Instance.new("Frame")
        boxes.BackgroundTransparency = 1
        boxes.Size     = UDim2.new(1, -18, 0, 22)
        boxes.Position = UDim2.new(0, 12, 0, 136)
        boxes.Parent   = row

        local caps = Instance.new("Frame")
        caps.BackgroundTransparency = 1
        caps.Size     = UDim2.new(1, -18, 0, 14)
        caps.Position = UDim2.new(0, 12, 0, 160)
        caps.Parent   = row

        local function makeBox(xScale, wScale, caption)
            local bgf = Instance.new("Frame")
            bgf.BackgroundColor3 = Config.Theme.Secondary
            bgf.BorderSizePixel  = 0
            bgf.Size             = UDim2.new(wScale, -6, 1, 0)
            bgf.Position         = UDim2.new(xScale, 0, 0, 0)
            bgf.Parent           = boxes
            Corner(bgf, 5)
            local st = Stroke(bgf, Config.Theme.Edge, 1)

            local tb = Instance.new("TextBox")
            tb.BackgroundTransparency = 1
            tb.Size             = UDim2.new(1, -8, 1, 0)
            tb.Position         = UDim2.new(0, 4, 0, 0)
            tb.TextColor3       = Config.Theme.Text
            tb.TextSize         = 12
            tb.Font             = Enum.Font.Gotham
            tb.ClearTextOnFocus = false
            tb.Text             = ""
            tb.Parent           = bgf

            tb.Focused:Connect(function() Tween(st, TI_FAST, { Color = Config.Theme.Accent }) end)
            tb.FocusLost:Connect(function() Tween(st, TI_FAST, { Color = Config.Theme.Edge }) end)

            Label(caps, { Text = caption, Color = Config.Theme.TextDim, Size = 10, AlignX = Enum.TextXAlignment.Center,
                          Pos = UDim2.new(xScale, 0, 0, 0), FrameSize = UDim2.new(wScale, -6, 1, 0) })
            return tb
        end

        local boxR = makeBox(0,   0.2, "R")
        local boxG = makeBox(0.2, 0.2, "G")
        local boxB = makeBox(0.4, 0.2, "B")
        local boxH = makeBox(0.6, 0.4, "HEX")

        -- state / rendering
        local function render()
            sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            svCur.Position      = UDim2.new(s, 0, 1 - v, 0)
            hueCur.Position     = UDim2.new(0.5, 0, h, 0)
            swatch.BackgroundColor3 = color
            local r = math.floor(color.R * 255 + 0.5)
            local g = math.floor(color.G * 255 + 0.5)
            local b = math.floor(color.B * 255 + 0.5)
            boxR.Text = tostring(r)
            boxG.Text = tostring(g)
            boxB.Text = tostring(b)
            boxH.Text = string.format("#%02X%02X%02X", r, g, b)
        end

        local function emit()
            if props.Callback then props.Callback(color) end
        end

        local function fromHSVState()
            color = Color3.fromHSV(h, s, v)
            render()
            emit()
        end

        local function fromColor(c, shouldEmit)
            color = c
            local nh, ns, nv = c:ToHSV()
            if ns > 0 and nv > 0 then h = nh end -- keep hue when the color is grey/black
            s, v = ns, nv
            render()
            if shouldEmit then emit() end
        end

        -- dragging
        local dragMode = nil
        local function updateSV(pos)
            local ap, as = sv.AbsolutePosition, sv.AbsoluteSize
            if as.X == 0 or as.Y == 0 then return end
            s = math.clamp((pos.X - ap.X) / as.X, 0, 1)
            v = 1 - math.clamp((pos.Y - ap.Y) / as.Y, 0, 1)
            fromHSVState()
        end
        local function updateHue(pos)
            local ap, as = hue.AbsolutePosition, hue.AbsoluteSize
            if as.Y == 0 then return end
            h = math.clamp((pos.Y - ap.Y) / as.Y, 0, 0.999)
            fromHSVState()
        end
        local function isPress(i)
            return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
        end

        svHit.InputBegan:Connect(function(i)
            if isPress(i) then dragMode = "sv"; updateSV(i.Position) end
        end)
        hueHit.InputBegan:Connect(function(i)
            if isPress(i) then dragMode = "hue"; updateHue(i.Position) end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if not dragMode then return end
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                if dragMode == "sv" then updateSV(i.Position) else updateHue(i.Position) end
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if isPress(i) then dragMode = nil end
        end)

        -- typed input
        local function channel(tb, current)
            local n = tonumber(tb.Text)
            if n then return math.clamp(math.floor(n + 0.5), 0, 255) end
            return math.floor(current * 255 + 0.5)
        end
        local function commitRGB()
            fromColor(Color3.fromRGB(channel(boxR, color.R), channel(boxG, color.G), channel(boxB, color.B)), true)
        end
        boxR.FocusLost:Connect(commitRGB)
        boxG.FocusLost:Connect(commitRGB)
        boxB.FocusLost:Connect(commitRGB)
        boxH.FocusLost:Connect(function()
            local hex = string.gsub(boxH.Text, "[#%s]", "")
            if hex:match("^%x%x%x%x%x%x$") then
                fromColor(Color3.fromRGB(
                    tonumber(hex:sub(1, 2), 16),
                    tonumber(hex:sub(3, 4), 16),
                    tonumber(hex:sub(5, 6), 16)
                ), true)
            else
                render() -- invalid hex: restore the previous value
            end
        end)

        render()

        local obj = { Row = row }
        function obj.SetColor(c) fromColor(c, false) end  -- no callback, safe to call from code
        function obj.GetColor() return color end
        return obj
    end

    return section
end

return Library
