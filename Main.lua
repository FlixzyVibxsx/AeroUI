-- Aero UI Library
-- A professional, feature-rich UI library for Roblox

local Library = {}
Library.__index = Library

-- Configuration
local Config = {
    Theme = {
        Primary = Color3.fromRGB(60, 60, 60),
        Secondary = Color3.fromRGB(40, 40, 40),
        Accent = Color3.fromRGB(100, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(180, 180, 180),
        Success = Color3.fromRGB(50, 205, 50),
        Error = Color3.fromRGB(255, 50, 50)
    },
    Size = UDim2.new(0, 350, 0, 450),
    Title = "Aero UI"
}

local PARENT = game:GetService("Players").LocalPlayer:FindFirstChild('PlayerGui')
if not game:GetService("RunService"):IsStudio() then
    PARENT = game:GetService("CoreGui")
end

for i,v in next, PARENT:GetChildren() do
    if v.Name == "AeroUI" then
        v:Destroy()
    end
end

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Helper Functions
local function CreateFrame(parent, props)
    local frame = Instance.new("Frame")
    frame.BackgroundTransparency = 1
    frame.Size = props.Size or UDim2.new(1, 0, 1, 0)
    frame.Position = props.Position or UDim2.new(0, 0, 0, 0)
    frame.Parent = parent
    return frame
end

local function CreateLabel(parent, props)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = props.Text or ""
    label.TextColor3 = props.TextColor or Config.Theme.Text
    label.TextSize = props.TextSize or 14
    label.TextXAlignment = props.TextXAlignment or "Left"
    label.TextYAlignment = "Top"
    label.Size = props.Size or UDim2.new(1, 0, 0, 20)
    label.Position = props.Position or UDim2.new(0, 0, 0, 0)
    label.Parent = parent
    return label
end

local function CreateButton(parent, props)
    local button = CreateFrame(parent, {Size = props.Size or UDim2.new(1, 0, 0, 30)})
    button.BackgroundTransparency = 1
    button.Name = "Button"
    
    local bg = Instance.new("Frame")
    bg.BackgroundTransparency = 1
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.Name = "Background"
    bg.Parent = button
    
    local text = CreateLabel(button, {Text = props.Text, TextColor = Config.Theme.Text, TextSize = 14})
    text.Size = UDim2.new(1, -10, 1, 0)
    text.Position = UDim2.new(0, 5, 0, 0)
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundTransparency = 0.5, BackgroundColor3 = Config.Theme.Primary}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    end)
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if props.Callback then props.Callback() end
        end
    end)
    
    return button
end

-- Notification System
local NotificationContainer = nil
local function CreateNotificationContainer()
    if NotificationContainer then return end
    NotificationContainer = CreateFrame(CoreGui, {Size = UDim2.new(0, 300, 0, 0), Position = UDim2.new(0.5, -150, 0, 50)})
    NotificationContainer.ZIndex = 9999
    NotificationContainer.Name = "AeroNotifications"
end

function Library:Notify(title, message, duration)
    CreateNotificationContainer()
    local notif = CreateFrame(NotificationContainer, {Size = UDim2.new(1, 0, 0, 60)})
    notif.BackgroundTransparency = 1
    notif.Position = UDim2.new(0, 0, 0, -60) -- Start slightly above
    
    local bg = Instance.new("Frame")
    bg.BackgroundTransparency = 1
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.Name = "Background"
    bg.BackgroundColor3 = Config.Theme.Primary
    bg.Parent = notif
    
    local titleLabel = CreateLabel(notif, {Text = title, TextColor = Config.Theme.Text, TextSize = 14})
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    
    local msgLabel = CreateLabel(notif, {Text = message, TextColor = Config.Theme.TextDim, TextSize = 12})
    msgLabel.Position = UDim2.new(0, 10, 0, 30)
    msgLabel.Size = UDim2.new(1, -20, 0, 20)
    
    notif.Parent = NotificationContainer
    
    -- Animate In
    local tween = TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, 0)})
    tween:Play()
    
    -- Animate Out
    task.delay(duration or 3, function()
        local out = TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, -60)})
        out:Play()
        out.Completed:Connect(function()
            notif:Destroy()
        end)
    end)
end

-- UI Class
function Library.new()
    local self = setmetatable({}, Library)
    
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "AeroUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = CoreGui
    
    -- Main Window
    self.Window = CreateFrame(self.ScreenGui, {Size = Config.Size, Position = UDim2.new(0.5, -175, 0.5, -225)})
    self.Window.Name = "Window"
    self.Window.ZIndex = 100
    
    -- Window Background
    local winBg = Instance.new("Frame")
    winBg.BackgroundColor3 = Config.Theme.Secondary
    winBg.BorderSizePixel = 0
    winBg.Size = UDim2.new(1, 0, 1, 0)
    winBg.Name = "Background"
    winBg.Parent = self.Window
    
    -- Title Bar
    local titleBar = CreateFrame(self.Window, {Size = UDim2.new(1, 0, 0, 35)})
    titleBar.Name = "TitleBar"
    titleBar.ZIndex = 101
    
    local titleBg = Instance.new("Frame")
    titleBg.BackgroundColor3 = Config.Theme.Primary
    titleBg.BorderSizePixel = 0
    titleBg.Size = UDim2.new(1, 0, 0, 35)
    titleBg.Name = "Background"
    titleBg.Parent = titleBar
    
    local titleLabel = CreateLabel(titleBar, {Text = Config.Title, TextColor = Config.Theme.Text, TextSize = 14})
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    
    -- Close Button
    local closeBtn = CreateFrame(titleBar, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -25, 0, 5)})
    closeBtn.Name = "CloseBtn"
    local closeBg = Instance.new("Frame")
    closeBg.BackgroundColor3 = Config.Theme.Error
    closeBg.BorderSizePixel = 0
    closeBg.Size = UDim2.new(1, 0, 1, 0)
    closeBg.Name = "Background"
    closeBg.Parent = closeBtn
    closeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:Destroy()
        end
    end)
    
    -- Dragging Logic
    local dragging = false
    local dragInput, mousePos, framePos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = self.Window.Position
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
            self.Window.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
    
    -- Content Area
    self.Content = CreateFrame(self.Window, {Size = UDim2.new(1, 0, 1, -35), Position = UDim2.new(0, 0, 0, 35)})
    self.Content.Name = "Content"
    
    -- Tabs System
    self.Tabs = {}
    self.Sections = {}
    self.CurrentTab = nil
    
    return self
end

-- Section Class
function Library:NewSection(name)
    local section = {}
    section.__index = section
    section.YOffset = 0
    section.Sections = {}
    
    -- Create Tab Button
    local tabBtn = CreateButton(self.Content, {Size = UDim2.new(1, 0, 0, 30), Text = name})
    tabBtn.Name = "TabButton"
    tabBtn.Position = UDim2.new(0, 0, 0, 0)
    
    -- Create Section Frame (Hidden by default)
    local sectionFrame = CreateFrame(self.Content, {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 35)})
    sectionFrame.Name = "Section"
    sectionFrame.Visible = false
    
    -- Tab Switching Logic
    tabBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- Reset all tabs
            for _, btn in ipairs(self.Content:GetChildren()) do
                if btn.Name == "TabButton" then
                    btn.BackgroundTransparency = 1
                end
            end
            for _, sec in ipairs(self.Content:GetChildren()) do
                if sec.Name == "Section" then
                    sec.Visible = false
                end
            end
            
            -- Activate current
            tabBtn.BackgroundTransparency = 0.5
            sectionFrame.Visible = true
            self.CurrentTab = section
        end
    end)
    
    -- Element Creation Methods
    function section.NewButton(props)
        local btn = CreateButton(sectionFrame, props)
        btn.Position = UDim2.new(0, 0, 0, section.YOffset)
        table.insert(section.Sections, btn)
        section.YOffset = section.YOffset + 30
        return btn
    end
    
    function section.NewToggle(props)
        local toggle = CreateFrame(sectionFrame, {Size = UDim2.new(1, 0, 0, 30)})
        toggle.Name = "Toggle"
        toggle.Position = UDim2.new(0, 0, 0, section.YOffset)
        
        local toggleState = false
        local toggleBg = Instance.new("Frame")
        toggleBg.BackgroundColor3 = Config.Theme.Primary
        toggleBg.BorderSizePixel = 0
        toggleBg.Size = UDim2.new(1, 0, 1, 0)
        toggleBg.Name = "Background"
        toggleBg.Parent = toggle
        
        local toggleCircle = Instance.new("Frame")
        toggleCircle.BackgroundColor3 = Config.Theme.Text
        toggleCircle.BorderSizePixel = 0
        toggleCircle.Size = UDim2.new(0, 15, 0, 15)
        toggleCircle.Position = UDim2.new(0, 5, 0, 5)
        toggleCircle.Name = "Circle"
        toggleCircle.Parent = toggle
        
        local toggleLabel = CreateLabel(toggle, {Text = props.Text or "Toggle", TextColor = Config.Theme.Text, TextSize = 14})
        toggleLabel.Position = UDim2.new(0, 25, 0, 0)
        toggleLabel.Size = UDim2.new(1, -25, 1, 0)
        
        toggle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                toggleState = not toggleState
                if toggleState then
                    toggleCircle.Position = UDim2.new(0, 15, 0, 5)
                    toggleCircle.BackgroundColor3 = Config.Theme.Accent
                else
                    toggleCircle.Position = UDim2.new(0, 5, 0, 5)
                    toggleCircle.BackgroundColor3 = Config.Theme.Text
                end
                if props.Callback then props.Callback(toggleState) end
            end
        end)
        
        section.YOffset = section.YOffset + 30
        return toggle
    end
    
    function section.NewSlider(props)
        local slider = CreateFrame(sectionFrame, {Size = UDim2.new(1, 0, 0, 40)})
        slider.Name = "Slider"
        slider.Position = UDim2.new(0, 0, 0, section.YOffset)
        
        local label = CreateLabel(slider, {Text = props.Text or "Slider", TextColor = Config.Theme.Text, TextSize = 14})
        label.Position = UDim2.new(0, 0, 0, 0)
        
        local sliderBg = Instance.new("Frame")
        sliderBg.BackgroundColor3 = Config.Theme.Primary
        sliderBg.BorderSizePixel = 0
        sliderBg.Size = UDim2.new(1, -10, 0, 10)
        sliderBg.Position = UDim2.new(0, 5, 0, 20)
        sliderBg.Name = "Background"
        sliderBg.Parent = slider
        
        local sliderHandle = Instance.new("Frame")
        sliderHandle.BackgroundColor3 = Config.Theme.Accent
        sliderHandle.BorderSizePixel = 0
        sliderHandle.Size = UDim2.new(0, 10, 0, 10)
        sliderHandle.Position = UDim2.new(0, 0, 0, 0)
        sliderHandle.Name = "Handle"
        sliderHandle.Parent = sliderBg
        
        local valueLabel = CreateLabel(slider, {Text = tostring(props.Value or 0), TextColor = Config.Theme.TextDim, TextSize = 12})
        valueLabel.Position = UDim2.new(1, -30, 0, 20)
        valueLabel.Size = UDim2.new(0, 30, 0, 10)
        valueLabel.TextXAlignment = "Right"
        
        local dragging = false
        local function updateSlider(input)
            local relativeX = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
            relativeX = math.clamp(relativeX, 0, 1)
            local value = math.floor(props.Min or 0 + relativeX * (props.Max or 100 - (props.Min or 0)))
            sliderHandle.Position = UDim2.new(relativeX, -5, 0, 0)
            valueLabel.Text = tostring(value)
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
        
        section.YOffset = section.YOffset + 40
        return slider
    end
    
    function section.NewDropdown(props)
        local dropdown = CreateFrame(sectionFrame, {Size = UDim2.new(1, 0, 0, 30)})
        dropdown.Name = "Dropdown"
        dropdown.Position = UDim2.new(0,  0, 0, section.YOffset)
        
        local dropdownBg = Instance.new("Frame")
        dropdownBg.BackgroundColor3 = Config.Theme.Primary
        dropdownBg.BorderSizePixel = 0
        dropdownBg.Size = UDim2.new(1, 0, 1, 0)
        dropdownBg.Name = "Background"
        dropdownBg.Parent = dropdown
        
        local dropdownLabel = CreateLabel(dropdown, {Text = props.Text or "Dropdown", TextColor = Config.Theme.Text, TextSize = 14})
        dropdownLabel.Position = UDim2.new(0, 10, 0, 0)
    
        local dropdownValue = CreateLabel(dropdown, {Text = props.Default or "Select", TextColor = Config.Theme.TextDim, TextSize = 14})
        dropdownValue.Position = UDim2.new(1, -10, 0, 0)
        dropdownValue.TextXAlignment = "Right"
    
        local dropdownList = CreateFrame(dropdown, {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 30)})
        dropdownList.Name = "List"
        dropdownList.Visible = false
        dropdownList.BackgroundTransparency = 1
    
        local listBg = Instance.new("Frame")
        listBg.BackgroundColor3 = Config.Theme.Primary
        listBg.BorderSizePixel = 0
        listBg.Size = UDim2.new(1, 0, 1, 0)
        listBg.Name = "Background"
        listBg.Parent = dropdownList
    
        local function toggleList()
            dropdownList.Visible = not dropdownList.Visible
        end
    
        dropdown.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                toggleList()
            end
        end)
    
        -- Add Options
        local options = props.Options or {}
        local optionButtons = {}
    
        for _, option in ipairs(options) do
            local btn = CreateButton(dropdownList, {Size = UDim2.new(1, 0, 0, 25), Text = option})
            btn.Position = UDim2.new(0, 0, 0, #optionButtons * 25)
            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dropdownValue.Text = option
                    if props.Callback then props.Callback(option) end
                    toggleList()
                end
            end)
            table.insert(optionButtons, btn)
        end
    
        -- Auto-resize list
        dropdownList.Size = UDim2.new(1, 0, 0, math.max(0, #optionButtons * 25))
    
        section.YOffset = section.YOffset + 30
        return dropdown
    end

    function section.NewTextBox(props)
        local textbox = CreateFrame(sectionFrame, {Size = UDim2.new(1, 0, 0, 30)})
        textbox.Name = "TextBox"
        textbox.Position = UDim2.new(0, 0, 0, section.YOffset)
    
        local label = CreateLabel(textbox, {Text = props.Text or "TextBox", TextColor = Config.Theme.Text, TextSize = 14})
        label.Position = UDim2.new(0, 0, 0, 0)
    
        local input = Instance.new("TextBox")
        input.BackgroundTransparency = 1
        input.Text = props.Default or ""
        input.TextColor3 = Config.Theme.Text
        input.TextSize = 14
        input.Size = UDim2.new(1, -10, 1, 0)
        input.Position = UDim2.new(0, 5, 0, 0)
        input.PlaceholderText = "Enter text..."
        input.PlaceholderColor3 = Config.Theme.TextDim
        input.ClearTextOnFocus = false
        input.Parent = textbox
    
        input.FocusLost:Connect(function(enterPressed)
            if props.Callback then props.Callback(input.Text, enterPressed) end
        end)
    
        section.YOffset = section.YOffset + 30
        return textbox
    end

    function section.NewKeybind(props)
        local keybind = CreateFrame(sectionFrame, {Size = UDim2.new(1, 0, 0, 30)})
        keybind.Name = "Keybind"
        keybind.Position = UDim2.new(0, 0, 0, section.YOffset)
    
        local label = CreateLabel(keybind, {Text = props.Text or "Keybind", TextColor = Config.Theme.Text, TextSize = 14})
        label.Position = UDim2.new(0, 0, 0, 0)
    
        local keybindValue = CreateLabel(keybind, {Text = props.Default or "None", TextColor = Config.Theme.TextDim, TextSize = 14})
        keybindValue.Position = UDim2.new(1, -10, 0, 0)
        keybindValue.TextXAlignment = "Right"
        
        local isBinding = false
        local function bindKey()
            isBinding = true
            keybindValue.Text = "..."
        end
    
        local function unbindKey()
            isBinding = false
            keybindValue.Text = "None"
        end
    
        keybind.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if isBinding then
                    unbindKey()
                else
                    bindKey()            
                end
            end
        end)
    
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if isBinding and not gameProcessed then
                isBinding = false
                keybindValue.Text = input.KeyCode.Name
                if props.Callback then props.Callback(input.KeyCode) end
            end
        end)
    
        section.YOffset = section.YOffset + 30
        return keybind
    end
end

return Library
