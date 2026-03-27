-- Aero UI Library
-- A professional, feature-rich UI library for Roblox

local Library = {}
Library.__index = Library

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

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

-- Cached TweenInfos
local TWEEN_FAST   = TweenInfo.new(0.2)
local TWEEN_NORMAL = TweenInfo.new(0.3)

-- Parent resolution
local PARENT = (game:GetService("RunService"):IsStudio())
    and Player:FindFirstChild("PlayerGui")
    or CoreGui

-- Clean up existing instances
for _, v in next, PARENT:GetChildren() do
    if v.Name == "AeroUI" then v:Destroy() end
end

-- Helper Functions
local function CreateFrame(parent, props)
    local frame = Instance.new("Frame")
    frame.BackgroundTransparency = 1
    frame.Size     = props.Size     or UDim2.new(1, 0, 1, 0)
    frame.Position = props.Position or UDim2.new(0, 0, 0, 0)
    frame.Parent   = parent
    return frame
end

local function CreateLabel(parent, props)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text           = props.Text      or ""
    label.TextColor3     = props.TextColor or Config.Theme.Text
    label.TextSize       = props.TextSize  or 14
    label.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.Size           = props.Size     or UDim2.new(1, 0, 0, 20)
    label.Position       = props.Position or UDim2.new(0, 0, 0, 0)
    label.Parent         = parent
    return label
end

local function CreateButton(parent, props)
    local button = CreateFrame(parent, { Size = props.Size or UDim2.new(1, 0, 0, 30) })
    button.Name = "Button"

    local bg = Instance.new("Frame")
    bg.BackgroundTransparency = 1
    bg.Size   = UDim2.new(1, 0, 1, 0)
    bg.Name   = "Background"
    bg.Active = false
    bg.Parent = button

    local text = CreateLabel(button, { Text = props.Text, TextColor = Config.Theme.Text, TextSize = 14 })
    text.Size     = UDim2.new(1, -10, 1, 0)
    text.Position = UDim2.new(0, 5, 0, 0)

    button.MouseEnter:Connect(function()
        TweenService:Create(bg, TWEEN_FAST, { BackgroundTransparency = 0.5, BackgroundColor3 = Config.Theme.Primary }):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(bg, TWEEN_FAST, { BackgroundTransparency = 1 }):Play()
    end)
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and props.Callback then
            props.Callback()
        end
    end)

    return button
end

-- Notification System
local NotificationContainer

local function GetNotificationContainer()
    if NotificationContainer then return NotificationContainer end
    NotificationContainer = CreateFrame(CoreGui, {
        Size     = UDim2.new(0, 300, 0, 0),
        Position = UDim2.new(0.5, -150, 0, 50),
    })
    NotificationContainer.ZIndex = 9999
    NotificationContainer.Name  = "AeroNotifications"
    return NotificationContainer
end

function Library:Notify(title, message, duration)
    local container = GetNotificationContainer()
    local notif = CreateFrame(container, { Size = UDim2.new(1, 0, 0, 60) })
    notif.Position = UDim2.new(0, 0, 0, -60)

    local bg = Instance.new("Frame")
    bg.BackgroundColor3     = Config.Theme.Primary
    bg.BackgroundTransparency = 0
    bg.BorderSizePixel      = 0
    bg.Size   = UDim2.new(1, 0, 1, 0)
    bg.Name   = "Background"
    bg.Parent = notif

    local titleLabel = CreateLabel(notif, { Text = title,   TextColor = Config.Theme.Text,    TextSize = 14 })
    titleLabel.Position = UDim2.new(0, 10, 0, 10)

    local msgLabel = CreateLabel(notif, { Text = message, TextColor = Config.Theme.TextDim, TextSize = 12 })
    msgLabel.Position = UDim2.new(0, 10, 0, 30)
    msgLabel.Size     = UDim2.new(1, -20, 0, 20)

    notif.Parent = container

    TweenService:Create(notif, TWEEN_NORMAL, { Position = UDim2.new(0, 0, 0, 0) }):Play()

    task.delay(duration or 3, function()
        local out = TweenService:Create(notif, TWEEN_NORMAL, { Position = UDim2.new(0, 0, 0, -60) })
        out:Play()
        out.Completed:Once(function() notif:Destroy() end)
    end)
end

-- UI Class
function Library.new()
    local self = setmetatable({}, Library)

    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name            = "AeroUI"
    self.ScreenGui.ResetOnSpawn    = false
    self.ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent          = PARENT

    self.Window = CreateFrame(self.ScreenGui, {
        Size     = Config.Size,
        Position = UDim2.new(0.5, -175, 0.5, -225),
    })
    self.Window.Name   = "Window"
    self.Window.ZIndex = 100

    local winBg = Instance.new("Frame")
    winBg.BackgroundColor3 = Config.Theme.Secondary
    winBg.BorderSizePixel  = 0
    winBg.Size   = UDim2.new(1, 0, 1, 0)
    winBg.Name   = "Background"
    winBg.Active = false  -- don't consume input
    winBg.ZIndex = 0
    winBg.Parent = self.Window

    -- Title Bar
    local titleBar = CreateFrame(self.Window, { Size = UDim2.new(1, 0, 0, 35) })
    titleBar.Name   = "TitleBar"
    titleBar.ZIndex = 101

    local titleBg = Instance.new("Frame")
    titleBg.BackgroundColor3 = Config.Theme.Primary
    titleBg.BorderSizePixel  = 0
    titleBg.Size   = UDim2.new(1, 0, 0, 35)
    titleBg.Name   = "Background"
    titleBg.Active = false
    titleBg.ZIndex = 0
    titleBg.Parent = titleBar

    local titleLabel = CreateLabel(titleBar, { Text = Config.Title, TextColor = Config.Theme.Text, TextSize = 14 })
    titleLabel.Position = UDim2.new(0, 10, 0, 0)

    -- Close Button
    local closeBtn = CreateFrame(titleBar, { Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -25, 0, 5) })
    closeBtn.Name = "CloseBtn"
    local closeBg = Instance.new("Frame")
    closeBg.BackgroundColor3 = Config.Theme.Error
    closeBg.BorderSizePixel  = 0
    closeBg.Size   = UDim2.new(1, 0, 1, 0)
    closeBg.Name   = "Background"
    closeBg.Active = false
    closeBg.Parent = closeBtn
    closeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:Destroy()
        end
    end)

    -- Dragging
    local dragging, dragInput, mousePos, framePos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            mousePos  = input.Position
            framePos  = self.Window.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            self.Window.Position = UDim2.new(
                framePos.X.Scale, framePos.X.Offset + delta.X,
                framePos.Y.Scale, framePos.Y.Offset + delta.Y
            )
        end
    end)

        -- Tab sidebar (left column, 100px wide)
    self.TabBar = Instance.new("Frame")
    self.TabBar.BackgroundColor3 = Config.Theme.Primary
    self.TabBar.BorderSizePixel  = 0
    self.TabBar.Size             = UDim2.new(0, 100, 1, -35)
    self.TabBar.Position         = UDim2.new(0, 0, 0, 35)
    self.TabBar.Name             = "TabBar"
    self.TabBar.Parent           = self.Window

    -- Content area (right of tab bar)
    self.Content = Instance.new("Frame")
    self.Content.BackgroundTransparency = 1
    self.Content.Size     = UDim2.new(1, -100, 1, -35)
    self.Content.Position = UDim2.new(0, 100, 0, 35)
    self.Content.Name     = "Content"
    self.Content.Parent   = self.Window

    self.TabYOffset  = 0
    self.CurrentTab  = nil

    return self
end

function Library:Destroy()
    if self.ScreenGui then self.ScreenGui:Destroy() end
end

-- Section / Tab
function Library:NewSection(name)
    local section = { YOffset = 0 }

    -- Tab button in the sidebar
    local tabBtn = Instance.new("TextButton")
    tabBtn.BackgroundColor3     = Config.Theme.Primary
    tabBtn.BackgroundTransparency = 0.4
    tabBtn.BorderSizePixel      = 0
    tabBtn.Size                 = UDim2.new(1, 0, 0, 30)
    tabBtn.Position             = UDim2.new(0, 0, 0, self.TabYOffset)
    tabBtn.Text                 = name
    tabBtn.TextColor3           = Config.Theme.TextDim
    tabBtn.TextSize             = 13
    tabBtn.Font                 = Enum.Font.Gotham
    tabBtn.Name                 = "TabButton"
    tabBtn.Parent               = self.TabBar
    self.TabYOffset             = self.TabYOffset + 30

    -- Section content frame
    local sectionFrame = Instance.new("ScrollingFrame")
    sectionFrame.BackgroundTransparency = 1
    sectionFrame.Size             = UDim2.new(1, 0, 1, 0)
    sectionFrame.Position         = UDim2.new(0, 0, 0, 0)
    sectionFrame.ScrollBarThickness = 3
    sectionFrame.ScrollBarImageColor3 = Config.Theme.Accent
    sectionFrame.CanvasSize       = UDim2.new(0, 0, 0, 0)
    sectionFrame.Name             = "Section"
    sectionFrame.Visible          = false
    sectionFrame.Parent           = self.Content

    tabBtn.MouseButton1Click:Connect(function()
        -- Deactivate all
        for _, child in ipairs(self.TabBar:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundTransparency = 0.4
                child.TextColor3 = Config.Theme.TextDim
            end
        end
        for _, child in ipairs(self.Content:GetChildren()) do
            if child.Name == "Section" then
                child.Visible = false
            end
        end
        -- Activate this one
        tabBtn.BackgroundTransparency = 0
        tabBtn.TextColor3 = Config.Theme.Text
        sectionFrame.Visible = true
        self.CurrentTab = section
    end)

    -- Auto-open first tab
    if self.TabYOffset == 30 then
        tabBtn.BackgroundTransparency = 0
        tabBtn.TextColor3 = Config.Theme.Text
        sectionFrame.Visible = true
        self.CurrentTab = section
    end

    -- Elements
    local function updateCanvas()
        sectionFrame.CanvasSize = UDim2.new(0, 0, 0, section.YOffset + 5)
    end

    function section.NewButton(props)
        local btn = CreateButton(sectionFrame, props)
        btn.Position    = UDim2.new(0, 5, 0, section.YOffset)
        btn.Size        = UDim2.new(1, -10, 0, 30)
        section.YOffset = section.YOffset + 35
        updateCanvas()
        return btn
    end

    function section.NewToggle(props)
        local toggle = CreateFrame(sectionFrame, { Size = UDim2.new(1, 0, 0, 30) })
        toggle.Name     = "Toggle"
        toggle.Position = UDim2.new(0, 5, 0, section.YOffset)

        local state = false

        local toggleBg = Instance.new("Frame")
        toggleBg.BackgroundColor3 = Config.Theme.Primary
        toggleBg.BorderSizePixel  = 0
        toggleBg.Size   = UDim2.new(1, 0, 1, 0)
        toggleBg.Name   = "Background"
        toggleBg.Active = false
        toggleBg.Parent = toggle

        local circle = Instance.new("Frame")
        circle.BackgroundColor3 = Config.Theme.Text
        circle.BorderSizePixel  = 0
        circle.Size     = UDim2.new(0, 15, 0, 15)
        circle.Position = UDim2.new(0, 5, 0, 5)
        circle.Name     = "Circle"
        circle.Parent   = toggle

        local toggleLabel = CreateLabel(toggle, { Text = props.Text or "Toggle", TextColor = Config.Theme.Text, TextSize = 14 })
        toggleLabel.Position = UDim2.new(0, 25, 0, 0)
        toggleLabel.Size     = UDim2.new(1, -25, 1, 0)

        toggle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                state = not state
                circle.Position         = state and UDim2.new(0, 15, 0, 5) or UDim2.new(0, 5, 0, 5)
                circle.BackgroundColor3 = state and Config.Theme.Accent or Config.Theme.Text
                if props.Callback then props.Callback(state) end
            end
        end)

        section.YOffset = section.YOffset + 35
        updateCanvas()
        return toggle
    end

    function section.NewSlider(props)
        local slider = CreateFrame(sectionFrame, { Size = UDim2.new(1, 0, 0, 40) })
        slider.Name     = "Slider"
        slider.Position = UDim2.new(0, 5, 0, section.YOffset)

        local minVal = props.Min or 0
        local maxVal = props.Max or 100

        local label = CreateLabel(slider, { Text = props.Text or "Slider", TextColor = Config.Theme.Text, TextSize = 14 })
        label.Position = UDim2.new(0, 0, 0, 0)

        local sliderBg = Instance.new("Frame")
        sliderBg.BackgroundColor3 = Config.Theme.Primary
        sliderBg.BorderSizePixel  = 0
        sliderBg.Size     = UDim2.new(1, -10, 0, 10)
        sliderBg.Position = UDim2.new(0, 5, 0, 20)
        sliderBg.Name     = "Background"
        sliderBg.Parent   = slider

        local handle = Instance.new("Frame")
        handle.BackgroundColor3 = Config.Theme.Accent
        handle.BorderSizePixel  = 0
        handle.Size     = UDim2.new(0, 10, 0, 10)
        handle.Position = UDim2.new(0, 0, 0, 0)
        handle.Name     = "Handle"
        handle.Parent   = sliderBg

        local valueLabel = CreateLabel(slider, { Text = tostring(props.Value or minVal), TextColor = Config.Theme.TextDim, TextSize = 12 })
        valueLabel.Position       = UDim2.new(1, -30, 0, 20)
        valueLabel.Size           = UDim2.new(0, 30, 0, 10)
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right

        local dragging = false
        local function updateSlider(input)
            local relX  = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            local value = math.floor(minVal + relX * (maxVal - minVal))
            handle.Position  = UDim2.new(relX, -5, 0, 0)
            valueLabel.Text  = tostring(value)
            if props.Callback then props.Callback(value) end
        end

        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateSlider(input)
            end
        end)
        sliderBg.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)

        section.YOffset = section.YOffset + 45
        updateCanvas()
        return slider
    end

    function section.NewDropdown(props)
        local dropdown = CreateFrame(sectionFrame, { Size = UDim2.new(1, 0, 0, 30) })
        dropdown.Name     = "Dropdown"
        dropdown.Position = UDim2.new(0, 5, 0, section.YOffset)

        local dropBg = Instance.new("Frame")
        dropBg.BackgroundColor3 = Config.Theme.Primary
        dropBg.BorderSizePixel  = 0
        dropBg.Size   = UDim2.new(1, 0, 1, 0)
        dropBg.Name   = "Background"
        dropBg.Active = false
        dropBg.Parent = dropdown

        local dropLabel = CreateLabel(dropdown, { Text = props.Text or "Dropdown", TextColor = Config.Theme.Text, TextSize = 14 })
        dropLabel.Position = UDim2.new(0, 10, 0, 0)

        local dropValue = CreateLabel(dropdown, { Text = props.Default or "Select", TextColor = Config.Theme.TextDim, TextSize = 14 })
        dropValue.Position       = UDim2.new(1, -10, 0, 0)
        dropValue.TextXAlignment = Enum.TextXAlignment.Right

        local dropList = CreateFrame(dropdown, { Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 30) })
        dropList.Name    = "List"
        dropList.Visible = false

        local listBg = Instance.new("Frame")
        listBg.BackgroundColor3 = Config.Theme.Primary
        listBg.BorderSizePixel  = 0
        listBg.Size   = UDim2.new(1, 0, 1, 0)
        listBg.Name   = "Background"
        listBg.Active = false
        listBg.Parent = dropList

        dropdown.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dropList.Visible = not dropList.Visible
            end
        end)

        local options = props.Options or {}
        for i, option in ipairs(options) do
            local btn = CreateButton(dropList, { Size = UDim2.new(1, 0, 0, 25), Text = option })
            btn.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dropValue.Text   = option
                    dropList.Visible = false
                    if props.Callback then props.Callback(option) end
                end
            end)
        end

        dropList.Size   = UDim2.new(1, 0, 0, #options * 25)
        section.YOffset = section.YOffset + 35
        updateCanvas()
        return dropdown
    end

    function section.NewTextBox(props)
        local textbox = CreateFrame(sectionFrame, { Size = UDim2.new(1, 0, 0, 30) })
        textbox.Name     = "TextBox"
        textbox.Position = UDim2.new(0, 5, 0, section.YOffset)

        local label = CreateLabel(textbox, { Text = props.Text or "TextBox", TextColor = Config.Theme.Text, TextSize = 14 })
        label.Position = UDim2.new(0, 0, 0, 0)

        local input = Instance.new("TextBox")
        input.BackgroundTransparency = 1
        input.Text             = props.Default or ""
        input.TextColor3       = Config.Theme.Text
        input.TextSize         = 14
        input.Size             = UDim2.new(1, -10, 1, 0)
        input.Position         = UDim2.new(0, 5, 0, 0)
        input.PlaceholderText  = "Enter text..."
        input.PlaceholderColor3 = Config.Theme.TextDim
        input.ClearTextOnFocus = false
        input.Parent           = textbox

        input.FocusLost:Connect(function(enterPressed)
            if props.Callback then props.Callback(input.Text, enterPressed) end
        end)

        section.YOffset = section.YOffset + 35
        updateCanvas()
        return textbox
    end

    function section.NewKeybind(props)
        local keybind = CreateFrame(sectionFrame, { Size = UDim2.new(1, 0, 0, 30) })
        keybind.Name     = "Keybind"
        keybind.Position = UDim2.new(0, 5, 0, section.YOffset)

        local label = CreateLabel(keybind, { Text = props.Text or "Keybind", TextColor = Config.Theme.Text, TextSize = 14 })
        label.Position = UDim2.new(0, 0, 0, 0)

        local keybindValue = CreateLabel(keybind, { Text = props.Default or "None", TextColor = Config.Theme.TextDim, TextSize = 14 })
        keybindValue.Position       = UDim2.new(1, -10, 0, 0)
        keybindValue.TextXAlignment = Enum.TextXAlignment.Right

        local isBinding = false

        keybind.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isBinding          = not isBinding
                keybindValue.Text  = isBinding and "..." or "None"
            end
        end)

        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if isBinding and not gameProcessed then
                isBinding          = false
                keybindValue.Text  = input.KeyCode.Name
                if props.Callback then props.Callback(input.KeyCode) end
            end
        end)

        section.YOffset = section.YOffset + 35
        updateCanvas()
        return keybind
    end

    return section
end

return Library
