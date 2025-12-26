--[[
    GlowHub V6.2 - Mobile Edition
    مخصص للموبايل 100%
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Settings
local COLORS = {
    Background = Color3.fromRGB(20,20,20),
    Accent = Color3.fromRGB(0,120,215),
    Text = Color3.fromRGB(255,255,255),
    On = Color3.fromRGB(0,255,120),
    Off = Color3.fromRGB(120,120,120)
}

local Toggles = {
    Fly = false,
    Noclip = false,
    InfJump = false
}

local Values = {
    SelectedPlayer = nil
}

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer.PlayerGui
end

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0.9,0,0.8,0)
Main.Position = UDim2.new(0.05,0,0.1,0)
Main.BackgroundColor3 = COLORS.Background
Main.Visible = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,14)

local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1,0,0,50)
Top.BackgroundColor3 = COLORS.Accent
Instance.new("UICorner", Top).CornerRadius = UDim.new(0,14)

local Title = Instance.new("TextLabel", Top)
Title.Size = UDim2.new(1,0,1,0)
Title.BackgroundTransparency = 1
Title.Text = "GlowHub Mobile"
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = COLORS.Text

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Position = UDim2.new(0,10,0,60)
Scroll.Size = UDim2.new(1,-20,1,-70)
Scroll.ScrollBarThickness = 4
Scroll.CanvasSize = UDim2.zero
Scroll.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0,10)
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 20)
end)

-- Toggle Button
local function ToggleButton(text, callback)
    local B = Instance.new("TextButton", Scroll)
    B.Size = UDim2.new(1,0,0,50)
    B.BackgroundColor3 = Color3.fromRGB(40,40,40)
    B.Text = text
    B.TextSize = 16
    B.Font = Enum.Font.GothamBold
    B.TextColor3 = COLORS.Text
    Instance.new("UICorner", B)

    local state = false
    B.Activated:Connect(function()
        state = not state
        B.BackgroundColor3 = state and COLORS.On or Color3.fromRGB(40,40,40)
        callback(state)
    end)
end

-- Player Select
local Select = Instance.new("TextButton", Scroll)
Select.Size = UDim2.new(1,0,0,50)
Select.Text = "اختيار لاعب"
Select.TextSize = 16
Select.Font = Enum.Font.GothamBold
Select.TextColor3 = COLORS.Text
Select.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", Select)

local function PickPlayer()
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            Values.SelectedPlayer = p
            Select.Text = "المختار: "..p.Name
            break
        end
    end
end
Select.Activated:Connect(PickPlayer)

-- Buttons
ToggleButton("✈️ طيران", function(v) Toggles.Fly = v end)
ToggleButton("🚫 اختراق الجدران", function(v) Toggles.Noclip = v end)
ToggleButton("⬆️ قفز لا نهائي", function(v) Toggles.InfJump = v end)

local TP = Instance.new("TextButton", Scroll)
TP.Size = UDim2.new(1,0,0,50)
TP.Text = "📍 انتقال للاعب"
TP.TextSize = 16
TP.Font = Enum.Font.GothamBold
TP.TextColor3 = COLORS.Text
TP.BackgroundColor3 = COLORS.Accent
Instance.new("UICorner", TP)

TP.Activated:Connect(function()
    if Values.SelectedPlayer and Values.SelectedPlayer.Character and LocalPlayer.Character then
        LocalPlayer.Character:PivotTo(
            Values.SelectedPlayer.Character:GetPivot()
        )
    end
end)

-- Systems
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Fly Mobile (forward)
    if Toggles.Fly then
        root.Velocity = Camera.CFrame.LookVector * 45
    end

    -- Noclip
    for _,p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            p.CanCollide = not Toggles.Noclip
        end
    end
end)

-- Infinite Jump Mobile
UserInputService.JumpRequest:Connect(function()
    if Toggles.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

print("🔥 GlowHub Mobile Loaded Successfully")
