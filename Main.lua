-- Aero UI Library
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
    },
    Size  = UDim2.new(0, 380, 0, 480),
    Title = "Aero UI",
}

local TI_FAST   = TweenInfo.new(0.18, Enum.EasingStyle.Quint)
local TI_MED    = TweenInfo.new(0.28, Enum.EasingStyle.Quint)
local TI_SLOW   = TweenInfo.new(0.4,  Enum.EasingStyle.Quint)
local ITEM_PAD  = 6
local CORNER    = 8   -- global corner radius

local PARENT = game:GetService("RunService"):IsStudio()
    and Player:FindFirstChild("PlayerGui") or CoreGui

for _, v in next, PARENT:GetChildren() do
    if v.Name == "AeroUI" then v:Destroy() end
end

-- ── Helpers ──────────────────────────────────────────────────────────────────

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

-- Hover glow effect on a frame
local function HoverGlow(frame, stroke)
    frame.MouseEnter:Connect(function()
        Tween(stroke, TI_FAST, { Color = Config.Theme.Accent, Thickness = 1.5 })
    end)
    frame.MouseLeave:Connect(function()
        Tween(stroke, TI_FAST, { Color = Config.Theme.Edge, Thickness = 1 })
    end)
end

-- ── Notifications ─────────────────────────────────────────────────────────────

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

    -- Accent left bar
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

-- ── Library.new ───────────────────────────────────────────────────────────────

function Library.new()
    local self = setmetatable({}, Library)

    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name           = "AeroUI"
    self.ScreenGui.ResetOnSpawn   = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent         = PARENT

    -- Neon glow container parented to ScreenGui, positioned behind the window
    local glowContainer = Instance.new("Frame")
    glowContainer.BackgroundTransparency = 1
    glowContainer.Size     = Config.Size
    glowContainer.Position = UDim2.new(0.5, -190, 0.5, -240)
    glowContainer.ZIndex   = 0
    glowContainer.Name     = "GlowContainer"
    glowContainer.Parent   = self.ScreenGui

    local glowColor = Config.Theme.Accent
    local glowLayers = {
        { pad = 3,  alpha = 0.55, radius = 14 },
        { pad = 7,  alpha = 0.72, radius = 17 },
        { pad = 13, alpha = 0.82, radius = 21 },
        { pad = 20, alpha = 0.90, radius = 26 },
        { pad = 30, alpha = 0.95, radius = 32 },
    }
    for _, g in ipairs(glowLayers) do
        local glow = Instance.new("Frame")
        glow.BackgroundColor3       = glowColor
        glow.BackgroundTransparency = g.alpha
        glow.BorderSizePixel        = 0
        glow.Size                   = UDim2.new(1, g.pad * 2, 1, g.pad * 2)
        glow.Position               = UDim2.new(0, -g.pad, 0, -g.pad)
        glow.Parent                 = glowContainer
        Corner(glow, g.radius)
    end

    -- Window
    self.Window = Instance.new("Frame")
    self.Window.BackgroundColor3 = Config.Theme.Secondary
    self.Window.BorderSizePixel  = 0
    self.Window.Size             = Config.Size
    self.Window.Position         = UDim2.new(0.5, -190, 0.5, -240)
    self.Window.Name             = "Window"
    self.Window.Parent           = self.ScreenGui
    Corner(self.Window, 12)
    Stroke(self.Window, Config.Theme.Accent, 1)

    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.BackgroundColor3 = Config.Theme.Primary
    titleBar.BorderSizePixel  = 0
    titleBar.Size             = UDim2.new(1, 0, 0, 38)
    titleBar.Name             = "TitleBar"
    titleBar.Parent           = self.Window
    Corner(titleBar, 12)

    -- Square off bottom corners of title bar
    local titleFill = Instance.new("Frame")
    titleFill.BackgroundColor3 = Config.Theme.Primary
    titleFill.BorderSizePixel  = 0
    titleFill.Size             = UDim2.new(1, 0, 0, 12)
    titleFill.Position         = UDim2.new(0, 0, 1, -12)
    titleFill.Parent           = titleBar

    -- Title icon dot
    local dot = Instance.new("Frame")
    dot.BackgroundColor3 = Config.Theme.Accent
    dot.BorderSizePixel  = 0
    dot.Size             = UDim2.new(0, 6, 0, 6)
    dot.Position         = UDim2.new(0, 14, 0.5, -3)
    dot.Parent           = titleBar
    Corner(dot, 3)

    Label(titleBar, { Text = Config.Title, Color = Config.Theme.Text, Size = 13, Pos = UDim2.new(0, 28, 0, 0) })

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.BackgroundColor3 = Config.Theme.Error
    closeBtn.BorderSizePixel  = 0
    closeBtn.Size             = UDim2.new(0, 18, 0, 18)
    closeBtn.Position         = UDim2.new(1, -26, 0.5, -9)
    closeBtn.Text             = "✕"
    closeBtn.TextColor3       = Config.Theme.Text
    closeBtn.TextSize         = 10
    closeBtn.Font             = Enum.Font.GothamBold
    closeBtn.Name             = "CloseBtn"
    closeBtn.Parent           = titleBar
    Corner(closeBtn, 5)
    closeBtn.MouseEnter:Connect(function() Tween(closeBtn, TI_FAST, { BackgroundColor3 = Color3.fromRGB(255, 110, 110) }) end)
    closeBtn.MouseLeave:Connect(function() Tween(closeBtn, TI_FAST, { BackgroundColor3 = Config.Theme.Error }) end)
    closeBtn.MouseButton1Click:Connect(function() self:Destroy() end)

    -- Drag
    local dragging, dragInput, mousePos, framePos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if input == dragInput and dragging then
            local d = input.Position - mousePos
            local newPos = UDim2.new(framePos.X.Scale, framePos.X.Offset + d.X, framePos.Y.Scale, framePos.Y.Offset + d.Y)
            self.Window.Position    = newPos
            glowContainer.Position  = newPos
        end
    end)

    -- Tab sidebar
    self.TabBar = Instance.new("Frame")
    self.TabBar.BackgroundColor3 = Config.Theme.Primary
    self.TabBar.BorderSizePixel  = 0
    self.TabBar.Size             = UDim2.new(0, 110, 1, -38)
    self.TabBar.Position         = UDim2.new(0, 0, 0, 38)
    self.TabBar.Name             = "TabBar"
    self.TabBar.Parent           = self.Window

    -- Divider line between sidebar and content
    local divider = Instance.new("Frame")
    divider.BackgroundColor3 = Config.Theme.Edge
    divider.BorderSizePixel  = 0
    divider.Size             = UDim2.new(0, 1, 1, -38)
    divider.Position         = UDim2.new(0, 110, 0, 38)
    divider.Parent           = self.Window

    -- Content area
    self.Content = Instance.new("Frame")
    self.Content.BackgroundTransparency = 1
    self.Content.Size     = UDim2.new(1, -111, 1, -38)
    self.Content.Position = UDim2.new(0, 111, 0, 38)
    self.Content.Name     = "Content"
    self.Content.Parent   = self.Window

    self.TabYOffset = 8
    self.CurrentTab = nil
    return self
end

function Library:Destroy()
    if self.ScreenGui then self.ScreenGui:Destroy() end
end

-- ── NewSection ────────────────────────────────────────────────────────────────

function Library:NewSection(name)
    local section = {}

    -- Sidebar tab button
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

    -- Active indicator bar on left edge of tab
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

    -- Scrolling content
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

    if self.TabYOffset == 44 then activateTab() end  -- first tab auto-opens

    -- ── Row factory ──────────────────────────────────────────────────────────
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

    -- ── Button ───────────────────────────────────────────────────────────────
    function section.NewButton(props)
        local row = makeRow(32)
        rowStroke(row)

        local btn = Instance.new("TextButton")
        btn.BackgroundTransparency = 1
        btn.Size          = UDim2.new(1, 0, 1, 0)
        btn.Text          = ""
        btn.Parent        = row

        -- Accent left stripe
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

    -- ── Toggle ───────────────────────────────────────────────────────────────
    function section.NewToggle(props)
        local row   = makeRow(34)
        local state = false
        local s     = rowStroke(row)

        Label(row, { Text = props.Text or "Toggle", Color = Config.Theme.Text, Size = 13, Pos = UDim2.new(0, 12, 0, 0), FrameSize = UDim2.new(1, -80, 1, 0) })

        -- Track
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

    -- ── Slider ───────────────────────────────────────────────────────────────
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
        handle.Size             = UDim2.new(0, 12, 0, 12)
        handle.Position         = UDim2.new(0, -6, 0.5, -6)
        handle.Parent           = fill
        Corner(handle, 6)
        Stroke(handle, Config.Theme.Accent, 1)

        local dragging = false
        local function update(input)
            local relX  = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local value = math.floor(minVal + relX * (maxVal - minVal))
            fill.Size     = UDim2.new(relX, 0, 1, 0)
            valLbl.Text   = tostring(value)
            if props.Callback then props.Callback(value) end
        end

        -- Set initial fill from props.Value
        local initVal = math.clamp(props.Value or minVal, minVal, maxVal)
        local initRel = (maxVal > minVal) and ((initVal - minVal) / (maxVal - minVal)) or 0
        fill.Size = UDim2.new(initRel, 0, 1, 0)

        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                Tween(handle, TI_FAST, { Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, -7, 0.5, -7) })
                update(i)
            end
        end)
        track.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
                Tween(handle, TI_FAST, { Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0, -6, 0.5, -6) })
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end
        end)
        return row
    end

    -- ── Dropdown ─────────────────────────────────────────────────────────────
    function section.NewDropdown(props)
        local options    = props.Options or {}
        local itemH      = 30
        local listHeight = #options * itemH
        local isOpen     = false

        local dd = Instance.new("Frame")
        dd.BackgroundColor3 = Config.Theme.Elevated
        dd.BorderSizePixel  = 0
        dd.Size             = UDim2.new(1, 0, 0, 32)
        dd.ClipsDescendants = true
        dd.LayoutOrder      = nextOrder()
        dd.Name             = "Dropdown"
        dd.Parent           = scroll
        Corner(dd, 7)
        local ddStroke = Stroke(dd, Config.Theme.Edge, 1)

        -- Header
        Label(dd, { Text = props.Text or "Dropdown", Color = Config.Theme.Text, Size = 13, Pos = UDim2.new(0, 12, 0, 0), FrameSize = UDim2.new(0.65, 0, 0, 32) })
        local valLbl = Label(dd, { Text = props.Default or "Select", Color = Config.Theme.TextDim, Size = 12, AlignX = Enum.TextXAlignment.Right, Pos = UDim2.new(0, 0, 0, 0), FrameSize = UDim2.new(1, -32, 0, 32) })
        local arrow  = Label(dd, { Text = "v", Color = Config.Theme.TextDim, Size = 11, AlignX = Enum.TextXAlignment.Center, Pos = UDim2.new(1, -26, 0, 0), FrameSize = UDim2.new(0, 22, 0, 32) })

        -- Separator line
        local sep = Instance.new("Frame")
        sep.BackgroundColor3     = Config.Theme.Edge
        sep.BackgroundTransparency = 0
        sep.BorderSizePixel      = 0
        sep.Size                 = UDim2.new(1, -24, 0, 1)
        sep.Position             = UDim2.new(0, 12, 0, 32)
        sep.Parent               = dd

        -- List
        local list = Instance.new("Frame")
        list.BackgroundTransparency = 1
        list.BorderSizePixel        = 0
        list.Size                   = UDim2.new(1, 0, 0, listHeight)
        list.Position               = UDim2.new(0, 0, 0, 33)
        list.Parent                 = dd

        for i, opt in ipairs(options) do
            local ob = Instance.new("TextButton")
            ob.BackgroundColor3     = Config.Theme.Elevated
            ob.BackgroundTransparency = 1
            ob.BorderSizePixel      = 0
            ob.Size                 = UDim2.new(1, 0, 0, itemH)
            ob.Position             = UDim2.new(0, 0, 0, (i-1)*itemH)
            ob.Text                 = opt
            ob.TextColor3           = Config.Theme.TextDim
            ob.TextSize             = 12
            ob.Font                 = Enum.Font.Gotham
            ob.TextXAlignment       = Enum.TextXAlignment.Left
            ob.Parent               = list
            local p = Instance.new("UIPadding"); p.PaddingLeft = UDim.new(0, 14); p.Parent = ob

            ob.MouseEnter:Connect(function()
                Tween(ob, TI_FAST, { BackgroundTransparency = 0.7, TextColor3 = Config.Theme.Text })
            end)
            ob.MouseLeave:Connect(function()
                Tween(ob, TI_FAST, { BackgroundTransparency = 1, TextColor3 = Config.Theme.TextDim })
            end)
            ob.MouseButton1Click:Connect(function()
                valLbl.Text = opt
                isOpen = false
                Tween(arrow, TI_FAST, { Rotation = 0 })
                Tween(dd, TI_MED, { Size = UDim2.new(1, 0, 0, 32) })
                Tween(ddStroke, TI_FAST, { Color = Config.Theme.Edge })
                if props.Callback then props.Callback(opt) end
            end)
        end

        local hdrBtn = Instance.new("TextButton")
        hdrBtn.BackgroundTransparency = 1
        hdrBtn.Size   = UDim2.new(1, 0, 0, 32)
        hdrBtn.Text   = ""
        hdrBtn.Parent = dd

        hdrBtn.MouseEnter:Connect(function()
            Tween(ddStroke, TI_FAST, { Color = Config.Theme.Accent, Thickness = 1.5 })
        end)
        hdrBtn.MouseLeave:Connect(function()
            if not isOpen then Tween(ddStroke, TI_FAST, { Color = Config.Theme.Edge, Thickness = 1 }) end
        end)
        hdrBtn.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            Tween(arrow, TI_MED, { Rotation = isOpen and 180 or 0 })
            Tween(dd, TI_MED, { Size = UDim2.new(1, 0, 0, isOpen and 33 + listHeight or 32) })
            Tween(ddStroke, TI_FAST, { Color = isOpen and Config.Theme.Accent or Config.Theme.Edge, Thickness = isOpen and 1.5 or 1 })
        end)

        return dd
    end

    -- ── TextBox ──────────────────────────────────────────────────────────────
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

    -- ── Keybind ──────────────────────────────────────────────────────────────
    function section.NewKeybind(props)
        local row       = makeRow(32)
        local isBinding = false
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
            if isBinding and not gp and input.UserInputType == Enum.UserInputType.Keyboard then
                isBinding = false
                kbLbl.Text       = input.KeyCode.Name
                kbLbl.TextColor3 = Config.Theme.TextDim
                Tween(badge, TI_FAST, { BackgroundColor3 = Config.Theme.Secondary })
                Tween(badgeStroke, TI_FAST, { Color = Config.Theme.Edge })
                Tween(s, TI_FAST, { Color = Config.Theme.Edge, Thickness = 1 })
                if props.Callback then props.Callback(input.KeyCode) end
            end
        end)
        return row
    end

    return section
end

return Library
