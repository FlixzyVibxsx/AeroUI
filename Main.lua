-- Aero UI Library
-- A professional, feature-rich UI library for Roblox

local Library = {}
Library.__index = Library

-- Services
local Players        = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService   = game:GetService("TweenService")
local CoreGui        = game:GetService("CoreGui")

local Player = Players.LocalPlayer

-- Configuration
local Config = {
    Theme = {
        Primary   = Color3.fromRGB(60, 60, 60),
        Secondary = Color3.fromRGB(40, 40, 40),
        Accent    = Color3.fromRGB(100, 100, 255),
        Text      = Color3.fromRGB(255, 255, 255),
        TextDim   = Color3.fromRGB(180, 180, 180),
        Success   = Color3.fromRGB(50, 205, 50),
        Error     = Color3.fromRGB(255, 50, 50),
    },
    Size  = UDim2.new(0, 350, 0, 450),
    Title = "Aero UI",
}

local TWEEN_FAST   = TweenInfo.new(0.2)
local TWEEN_NORMAL = TweenInfo.new(0.3)
local ITEM_PAD     = 5  -- gap between elements

local PARENT = game:GetService("RunService"):IsStudio()
    and Player:FindFirstChild("PlayerGui")
    or CoreGui

for _, v in next, PARENT:GetChildren() do
    if v.Name == "AeroUI" then v:Destroy() end
end

-- Helpers
local function Label(parent, props)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text           = props.Text      or ""
    l.TextColor3     = props.Color     or Config.Theme.Text
    l.TextSize       = props.Size      or 14
    l.Font           = Enum.Font.Gotham
    l.TextXAlignment = props.AlignX    or Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.Size           = props.FrameSize or UDim2.new(1, 0, 1, 0)
    l.Position       = props.Pos       or UDim2.new(0, 0, 0, 0)
    l.Parent         = parent
    return l
end

local function Bg(parent, color, active)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = color
    f.BorderSizePixel  = 0
    f.Size             = UDim2.new(1, 0, 1, 0)
    f.Active           = active or false
    f.Parent           = parent
    return f
end

-- Notification System
local NotifContainer
local function GetNotifContainer()
    if NotifContainer then return NotifContainer end
    NotifContainer = Instance.new("Frame")
    NotifContainer.BackgroundTransparency = 1
    NotifContainer.Size     = UDim2.new(0, 300, 0, 0)
    NotifContainer.Position = UDim2.new(0.5, -150, 0, 50)
    NotifContainer.ZIndex   = 9999
    NotifContainer.Name     = "AeroNotifications"
    NotifContainer.Parent   = CoreGui
    return NotifContainer
end

function Library:Notify(title, message, duration)
    local c     = GetNotifContainer()
    local notif = Instance.new("Frame")
    notif.BackgroundTransparency = 1
    notif.Size     = UDim2.new(1, 0, 0, 60)
    notif.Position = UDim2.new(0, 0, 0, -60)
    notif.Parent   = c

    Bg(notif, Config.Theme.Primary)
    Label(notif, { Text = title,   Color = Config.Theme.Text,   Size = 14, Pos = UDim2.new(0, 10, 0, 8),  FrameSize = UDim2.new(1, -20, 0, 20) })
    Label(notif, { Text = message, Color = Config.Theme.TextDim, Size = 12, Pos = UDim2.new(0, 10, 0, 30), FrameSize = UDim2.new(1, -20, 0, 20) })

    TweenService:Create(notif, TWEEN_NORMAL, { Position = UDim2.new(0, 0, 0, 0) }):Play()
    task.delay(duration or 3, function()
        local t = TweenService:Create(notif, TWEEN_NORMAL, { Position = UDim2.new(0, 0, 0, -60) })
        t:Play()
        t.Completed:Once(function() notif:Destroy() end)
    end)
end

-- Library constructor
function Library.new()
    local self = setmetatable({}, Library)

    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name           = "AeroUI"
    self.ScreenGui.ResetOnSpawn   = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent         = PARENT

    -- Root window frame
    self.Window = Instance.new("Frame")
    self.Window.BackgroundTransparency = 1
    self.Window.Size     = Config.Size
    self.Window.Position = UDim2.new(0.5, -175, 0.5, -225)
    self.Window.Name     = "Window"
    self.Window.Parent   = self.ScreenGui

    Bg(self.Window, Config.Theme.Secondary)

    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.BackgroundTransparency = 1
    titleBar.Size   = UDim2.new(1, 0, 0, 35)
    titleBar.Name   = "TitleBar"
    titleBar.Parent = self.Window

    Bg(titleBar, Config.Theme.Primary)
    Label(titleBar, { Text = Config.Title, Size = 14, Pos = UDim2.new(0, 10, 0, 0) })

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.BackgroundColor3 = Config.Theme.Error
    closeBtn.BorderSizePixel  = 0
    closeBtn.Size             = UDim2.new(0, 20, 0, 20)
    closeBtn.Position         = UDim2.new(1, -25, 0, 7)
    closeBtn.Text             = ""
    closeBtn.Name             = "CloseBtn"
    closeBtn.Parent           = titleBar
    closeBtn.MouseButton1Click:Connect(function() self:Destroy() end)

    -- Drag
    local dragging, dragInput, mousePos, framePos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = self.Window.Position
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
            self.Window.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + d.X, framePos.Y.Scale, framePos.Y.Offset + d.Y)
        end
    end)

    -- Tab sidebar
    self.TabBar = Instance.new("Frame")
    self.TabBar.BackgroundColor3 = Config.Theme.Primary
    self.TabBar.BorderSizePixel  = 0
    self.TabBar.Size             = UDim2.new(0, 100, 1, -35)
    self.TabBar.Position         = UDim2.new(0, 0, 0, 35)
    self.TabBar.Name             = "TabBar"
    self.TabBar.Parent           = self.Window

    -- Content area
    self.Content = Instance.new("Frame")
    self.Content.BackgroundTransparency = 1
    self.Content.Size     = UDim2.new(1, -100, 1, -35)
    self.Content.Position = UDim2.new(0, 100, 0, 35)
    self.Content.Name     = "Content"
    self.Content.Parent   = self.Window

    self.TabYOffset = 0
    self.CurrentTab = nil
    return self
end

function Library:Destroy()
    if self.ScreenGui then self.ScreenGui:Destroy() end
end

-- Section
function Library:NewSection(name)
    local section = {}

    -- Sidebar tab button
    local tabBtn = Instance.new("TextButton")
    tabBtn.BackgroundColor3       = Config.Theme.Primary
    tabBtn.BackgroundTransparency = 0.4
    tabBtn.BorderSizePixel        = 0
    tabBtn.Size                   = UDim2.new(1, 0, 0, 30)
    tabBtn.Position               = UDim2.new(0, 0, 0, self.TabYOffset)
    tabBtn.Text                   = name
    tabBtn.TextColor3             = Config.Theme.TextDim
    tabBtn.TextSize               = 13
    tabBtn.Font                   = Enum.Font.Gotham
    tabBtn.Name                   = "TabButton"
    tabBtn.Parent                 = self.TabBar
    self.TabYOffset               = self.TabYOffset + 30

    -- Scrolling content frame
    local scroll = Instance.new("ScrollingFrame")
    scroll.BackgroundTransparency  = 1
    scroll.Size                    = UDim2.new(1, 0, 1, 0)
    scroll.CanvasSize              = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize     = Enum.AutomaticSize.Y
    scroll.ScrollBarThickness      = 3
    scroll.ScrollBarImageColor3    = Config.Theme.Accent
    scroll.ScrollingDirection      = Enum.ScrollingDirection.Y
    scroll.Name                    = "Section"
    scroll.Visible                 = false
    scroll.Parent                  = self.Content

    -- UIListLayout handles ALL vertical stacking automatically
    local layout = Instance.new("UIListLayout")
    layout.SortOrder    = Enum.SortOrder.LayoutOrder
    layout.Padding      = UDim.new(0, ITEM_PAD)
    layout.Parent       = scroll

    local padding = Instance.new("UIPadding")
    padding.PaddingTop    = UDim.new(0, ITEM_PAD)
    padding.PaddingLeft   = UDim.new(0, ITEM_PAD)
    padding.PaddingRight  = UDim.new(0, ITEM_PAD)
    padding.Parent        = scroll

    local order = 0
    local function nextOrder()
        order = order + 1
        return order
    end

    -- Tab switching
    tabBtn.MouseButton1Click:Connect(function()
        for _, c in ipairs(self.TabBar:GetChildren()) do
            if c:IsA("TextButton") then
                c.BackgroundTransparency = 0.4
                c.TextColor3 = Config.Theme.TextDim
            end
        end
        for _, c in ipairs(self.Content:GetChildren()) do
            if c.Name == "Section" then c.Visible = false end
        end
        tabBtn.BackgroundTransparency = 0
        tabBtn.TextColor3 = Config.Theme.Text
        scroll.Visible    = true
        self.CurrentTab   = section
    end)

    -- Auto-open first tab
    if self.TabYOffset == 30 then
        tabBtn.BackgroundTransparency = 0
        tabBtn.TextColor3 = Config.Theme.Text
        scroll.Visible    = true
        self.CurrentTab   = section
    end

    -- Element helpers
    local function makeRow(h)
        local row = Instance.new("Frame")
        row.BackgroundTransparency = 1
        row.Size         = UDim2.new(1, 0, 0, h)
        row.LayoutOrder  = nextOrder()
        row.Parent       = scroll
        return row
    end

    -- Button
    function section.NewButton(props)
        local row = makeRow(30)
        Bg(row, Config.Theme.Primary)

        local btn = Instance.new("TextButton")
        btn.BackgroundTransparency = 1
        btn.Size          = UDim2.new(1, 0, 1, 0)
        btn.Text          = props.Text or "Button"
        btn.TextColor3    = Config.Theme.Text
        btn.TextSize      = 14
        btn.Font          = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent        = row

        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 8)
        pad.Parent = btn

        btn.MouseEnter:Connect(function() row:FindFirstChild("Frame").BackgroundTransparency = 0.5 end)
        btn.MouseLeave:Connect(function() row:FindFirstChild("Frame").BackgroundTransparency = 0 end)
        btn.MouseButton1Click:Connect(function()
            if props.Callback then props.Callback() end
        end)
        return row
    end

    -- Toggle
    function section.NewToggle(props)
        local row   = makeRow(30)
        local state = false
        Bg(row, Config.Theme.Primary)

        local circle = Instance.new("Frame")
        circle.BackgroundColor3 = Config.Theme.Text
        circle.BorderSizePixel  = 0
        circle.Size             = UDim2.new(0, 14, 0, 14)
        circle.Position         = UDim2.new(0, 6, 0.5, -7)
        circle.Name             = "Circle"
        circle.Parent           = row

        Label(row, {
            Text      = props.Text or "Toggle",
            Color     = Config.Theme.Text,
            Size      = 14,
            Pos       = UDim2.new(0, 28, 0, 0),
            FrameSize = UDim2.new(1, -28, 1, 0),
        })

        local btn = Instance.new("TextButton")
        btn.BackgroundTransparency = 1
        btn.Size   = UDim2.new(1, 0, 1, 0)
        btn.Text   = ""
        btn.Parent = row
        btn.MouseButton1Click:Connect(function()
            state = not state
            circle.Position         = state and UDim2.new(0, 16, 0.5, -7) or UDim2.new(0, 6, 0.5, -7)
            circle.BackgroundColor3 = state and Config.Theme.Accent or Config.Theme.Text
            if props.Callback then props.Callback(state) end
        end)
        return row
    end

    -- Slider
    function section.NewSlider(props)
        local row    = makeRow(40)
        local minVal = props.Min or 0
        local maxVal = props.Max or 100
        Bg(row, Config.Theme.Primary)

        Label(row, { Text = props.Text or "Slider", Color = Config.Theme.Text, Size = 13, Pos = UDim2.new(0, 8, 0, 2), FrameSize = UDim2.new(0.6, 0, 0, 18) })

        local valLabel = Label(row, { Text = tostring(props.Value or minVal), Color = Config.Theme.TextDim, Size = 12, AlignX = Enum.TextXAlignment.Right, Pos = UDim2.new(0, 0, 0, 2), FrameSize = UDim2.new(1, -8, 0, 18) })

        local track = Instance.new("Frame")
        track.BackgroundColor3 = Config.Theme.Secondary
        track.BorderSizePixel  = 0
        track.Size             = UDim2.new(1, -16, 0, 8)
        track.Position         = UDim2.new(0, 8, 0, 26)
        track.Parent           = row

        local fill = Instance.new("Frame")
        fill.BackgroundColor3 = Config.Theme.Accent
        fill.BorderSizePixel  = 0
        fill.Size             = UDim2.new(0, 0, 1, 0)
        fill.Parent           = track

        local handle = Instance.new("Frame")
        handle.BackgroundColor3 = Config.Theme.Text
        handle.BorderSizePixel  = 0
        handle.Size             = UDim2.new(0, 10, 0, 10)
        handle.Position         = UDim2.new(0, -5, 0.5, -5)
        handle.Parent           = fill

        local dragging = false
        local function update(input)
            local relX  = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local value = math.floor(minVal + relX * (maxVal - minVal))
            fill.Size      = UDim2.new(relX, 0, 1, 0)
            valLabel.Text  = tostring(value)
            if props.Callback then props.Callback(value) end
        end

        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; update(i) end
        end)
        track.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end
        end)
        return row
    end

    -- Dropdown
    function section.NewDropdown(props)
        local options    = props.Options or {}
        local listHeight = #options * 28
        local isOpen     = false

        -- The dropdown is a frame whose height animates
        local dd = Instance.new("Frame")
        dd.BackgroundTransparency = 1
        dd.Size        = UDim2.new(1, 0, 0, 30)
        dd.ClipsDescendants = true
        dd.LayoutOrder = nextOrder()
        dd.Name        = "Dropdown"
        dd.Parent      = scroll

        -- Header background
        local hdrBg = Bg(dd, Config.Theme.Primary)
        hdrBg.Size = UDim2.new(1, 0, 0, 30)

        Label(dd, { Text = props.Text or "Dropdown", Color = Config.Theme.Text, Size = 13, Pos = UDim2.new(0, 8, 0, 0), FrameSize = UDim2.new(0.6, 0, 0, 30) })

        local valLabel = Label(dd, { Text = props.Default or "Select", Color = Config.Theme.TextDim, Size = 13, AlignX = Enum.TextXAlignment.Right, Pos = UDim2.new(0, 0, 0, 0), FrameSize = UDim2.new(1, -28, 0, 30) })

        local arrow = Label(dd, { Text = "▼", Color = Config.Theme.TextDim, Size = 11, AlignX = Enum.TextXAlignment.Center, Pos = UDim2.new(1, -22, 0, 0), FrameSize = UDim2.new(0, 18, 0, 30) })

        -- List container
        local list = Instance.new("Frame")
        list.BackgroundColor3 = Config.Theme.Secondary
        list.BorderSizePixel  = 0
        list.Size             = UDim2.new(1, 0, 0, listHeight)
        list.Position         = UDim2.new(0, 0, 0, 30)
        list.Parent           = dd

        for i, opt in ipairs(options) do
            local ob = Instance.new("TextButton")
            ob.BackgroundTransparency = 1
            ob.Size          = UDim2.new(1, 0, 0, 28)
            ob.Position      = UDim2.new(0, 0, 0, (i-1)*28)
            ob.Text          = opt
            ob.TextColor3    = Config.Theme.TextDim
            ob.TextSize      = 13
            ob.Font          = Enum.Font.Gotham
            ob.TextXAlignment = Enum.TextXAlignment.Left
            ob.Parent        = list
            local p = Instance.new("UIPadding"); p.PaddingLeft = UDim.new(0,10); p.Parent = ob
            ob.MouseEnter:Connect(function() ob.TextColor3 = Config.Theme.Text end)
            ob.MouseLeave:Connect(function() ob.TextColor3 = Config.Theme.TextDim end)
            ob.MouseButton1Click:Connect(function()
                valLabel.Text = opt
                isOpen = false
                arrow.Text = "▼"
                TweenService:Create(dd, TWEEN_FAST, { Size = UDim2.new(1, 0, 0, 30) }):Play()
                if props.Callback then props.Callback(opt) end
            end)
        end

        -- Header click button (sits on top of header only)
        local hdrBtn = Instance.new("TextButton")
        hdrBtn.BackgroundTransparency = 1
        hdrBtn.Size   = UDim2.new(1, 0, 0, 30)
        hdrBtn.Text   = ""
        hdrBtn.Parent = dd
        hdrBtn.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            arrow.Text = isOpen and "▲" or "▼"
            TweenService:Create(dd, TWEEN_FAST, { Size = UDim2.new(1, 0, 0, isOpen and 30 + listHeight or 30) }):Play()
        end)

        return dd
    end

    -- TextBox
    function section.NewTextBox(props)
        local row = makeRow(30)
        Bg(row, Config.Theme.Primary)

        Label(row, { Text = props.Text or "Input", Color = Config.Theme.Text, Size = 13, Pos = UDim2.new(0, 8, 0, 0), FrameSize = UDim2.new(0.45, 0, 1, 0) })

        local tb = Instance.new("TextBox")
        tb.BackgroundTransparency = 1
        tb.Text             = props.Default or ""
        tb.TextColor3       = Config.Theme.Text
        tb.TextSize         = 13
        tb.Font             = Enum.Font.Gotham
        tb.Size             = UDim2.new(0.5, -8, 1, 0)
        tb.Position         = UDim2.new(0.5, 0, 0, 0)
        tb.PlaceholderText  = "..."
        tb.PlaceholderColor3 = Config.Theme.TextDim
        tb.ClearTextOnFocus = false
        tb.TextXAlignment   = Enum.TextXAlignment.Left
        tb.Parent           = row
        tb.FocusLost:Connect(function(enter)
            if props.Callback then props.Callback(tb.Text, enter) end
        end)
        return row
    end

    -- Keybind
    function section.NewKeybind(props)
        local row       = makeRow(30)
        local isBinding = false
        Bg(row, Config.Theme.Primary)

        Label(row, { Text = props.Text or "Keybind", Color = Config.Theme.Text, Size = 13, Pos = UDim2.new(0, 8, 0, 0), FrameSize = UDim2.new(0.6, 0, 1, 0) })

        local kbLabel = Label(row, { Text = props.Default or "None", Color = Config.Theme.TextDim, Size = 12, AlignX = Enum.TextXAlignment.Right, Pos = UDim2.new(0, 0, 0, 0), FrameSize = UDim2.new(1, -8, 1, 0) })

        local btn = Instance.new("TextButton")
        btn.BackgroundTransparency = 1
        btn.Size   = UDim2.new(1, 0, 1, 0)
        btn.Text   = ""
        btn.Parent = row
        btn.MouseButton1Click:Connect(function()
            isBinding     = not isBinding
            kbLabel.Text  = isBinding and "..." or (props.Default or "None")
            kbLabel.TextColor3 = isBinding and Config.Theme.Accent or Config.Theme.TextDim
        end)

        UserInputService.InputBegan:Connect(function(input, gp)
            if isBinding and not gp and input.UserInputType == Enum.UserInputType.Keyboard then
                isBinding          = false
                kbLabel.Text       = input.KeyCode.Name
                kbLabel.TextColor3 = Config.Theme.TextDim
                if props.Callback then props.Callback(input.KeyCode) end
            end
        end)
        return row
    end

    return section
end

return Library
