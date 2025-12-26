--[[
    GlowHub V6.1 - النسخة العربية المصححة
    تم إصلاح:
    ✔ الطيران
    ✔ النوكليب
    ✔ القفز اللانهائي
    ✔ ScrollFrame
    ✔ Dropdown اللاعبين
]]

-- الخدمات
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- الإعدادات
local COLORS = {
    Background = Color3.fromRGB(20,20,20),
    Accent = Color3.fromRGB(0,120,215),
    Text = Color3.fromRGB(255,255,255),
    Success = Color3.fromRGB(0,255,120),
    Idle = Color3.fromRGB(100,100,100)
}

local Toggles = {
    Fly = false,
    Noclip = false,
    InfJump = false,
    AutoBack = false
}

local Values = {
    SelectedPlayer = nil,
    SavedPos = nil
}

-- الواجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GlowHub_Arabic"
ScreenGui.ResetOnSpawn = false
pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer.PlayerGui
end

-- الإطار الرئيسي
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0,260,0,420)
MainFrame.Position = UDim2.new(0.5,-130,0.5,-210)
MainFrame.BackgroundColor3 = COLORS.Background
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,12)

-- الشريط العلوي
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1,0,0,40)
TopBar.BackgroundColor3 = COLORS.Accent
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0,12)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1,0,1,0)
Title.BackgroundTransparency = 1
Title.Text = "GlowHub V6.1"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = COLORS.Text

-- Scroll
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Position = UDim2.new(0,5,0,45)
Scroll.Size = UDim2.new(1,-10,1,-50)
Scroll.CanvasSize = UDim2.zero
Scroll.ScrollBarThickness = 2
Scroll.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0,5)
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
end)

-- زر Toggle
local function createToggle(text, callback)
    local Btn = Instance.new("TextButton", Scroll)
    Btn.Size = UDim2.new(1,-10,0,35)
    Btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Btn.Text = "  "..text
    Btn.TextXAlignment = Enum.TextXAlignment.Right
    Btn.TextColor3 = COLORS.Text
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 14
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,6)

    local Indicator = Instance.new("Frame", Btn)
    Indicator.Size = UDim2.new(0,10,0,10)
    Indicator.Position = UDim2.new(0.05,0,0.5,-5)
    Indicator.BackgroundColor3 = COLORS.Idle
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1,0)

    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Indicator.BackgroundColor3 = state and COLORS.Success or COLORS.Idle
        callback(state)
    end)
end

-- Dropdown اللاعبين
local DropFrame = Instance.new("Frame", Scroll)
DropFrame.Size = UDim2.new(1,-10,0,40)
DropFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", DropFrame)

local SelectedLabel = Instance.new("TextButton", DropFrame)
SelectedLabel.Size = UDim2.new(1,0,1,0)
SelectedLabel.Text = "اختر لاعب"
SelectedLabel.BackgroundTransparency = 1
SelectedLabel.TextColor3 = COLORS.Text

local PlayerList = Instance.new("ScrollingFrame", DropFrame)
PlayerList.Position = UDim2.new(0,0,1,5)
PlayerList.Size = UDim2.new(1,0,0,120)
PlayerList.Visible = false
PlayerList.ScrollBarThickness = 2
PlayerList.BackgroundColor3 = Color3.fromRGB(45,45,45)
PlayerList.ZIndex = 5

local PLayout = Instance.new("UIListLayout", PlayerList)
PLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerList.CanvasSize = UDim2.new(0,0,0,PLayout.AbsoluteContentSize.Y)
end)

local function updatePlayers()
    for _,v in ipairs(PlayerList:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local b = Instance.new("TextButton", PlayerList)
            b.Size = UDim2.new(1,0,0,30)
            b.Text = plr.Name
            b.BackgroundColor3 = Color3.fromRGB(55,55,55)
            b.TextColor3 = COLORS.Text
            b.ZIndex = 6
            b.MouseButton1Click:Connect(function()
                Values.SelectedPlayer = plr
                SelectedLabel.Text = "المختار: "..plr.Name
                PlayerList.Visible = false
            end)
        end
    end
end

SelectedLabel.MouseButton1Click:Connect(function()
    PlayerList.Visible = not PlayerList.Visible
    updatePlayers()
end)

-- التوغلز
createToggle("طيران", function(s) Toggles.Fly = s end)
createToggle("اختراق الجدران", function(s) Toggles.Noclip = s end)
createToggle("قفز لا نهائي", function(s) Toggles.InfJump = s end)
createToggle("رجوع بعد الموت", function(s) Toggles.AutoBack = s end)

-- Teleport
local TP = Instance.new("TextButton", Scroll)
TP.Size = UDim2.new(1,-10,0,35)
TP.Text = "انتقال إلى اللاعب"
TP.BackgroundColor3 = COLORS.Accent
TP.TextColor3 = COLORS.Text
Instance.new("UICorner", TP)

TP.MouseButton1Click:Connect(function()
    if Values.SelectedPlayer and Values.SelectedPlayer.Character and LocalPlayer.Character then
        LocalPlayer.Character:PivotTo(
            Values.SelectedPlayer.Character:GetPivot()
        )
    end
end)

-- نسخ الملابس
local Skin = Instance.new("TextButton", Scroll)
Skin.Size = UDim2.new(1,-10,0,35)
Skin.Text = "نسخ ملابس اللاعب"
Skin.BackgroundColor3 = Color3.fromRGB(120,0,200)
Skin.TextColor3 = COLORS.Text
Instance.new("UICorner", Skin)

Skin.MouseButton1Click:Connect(function()
    if Values.SelectedPlayer and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            local desc = Players:GetHumanoidDescriptionFromUserId(Values.SelectedPlayer.UserId)
            hum:ApplyDescription(desc)
        end
    end
end)

-- الأنظمة
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Fly
    if Toggles.Fly then
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
        if dir.Magnitude > 0 then
            root.Velocity = dir.Unit * 50
        end
    end

    -- Noclip
    for _,p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            p.CanCollide = not Toggles.Noclip
        end
    end
end)

-- Inf Jump
UserInputService.JumpRequest:Connect(function()
    if Toggles.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- AutoBack
LocalPlayer.CharacterAdded:Connect(function(char)
    if Toggles.AutoBack and Values.SavedPos then
        task.wait(1)
        char:PivotTo(Values.SavedPos)
        Values.SavedPos = nil
    end
    char:WaitForChild("Humanoid").Died:Connect(function()
        if Toggles.AutoBack then
            Values.SavedPos = char:GetPivot()
        end
    end)
end)

-- زر الإظهار
local GBtn = Instance.new("TextButton", ScreenGui)
GBtn.Size = UDim2.new(0,45,0,45)
GBtn.Position = UDim2.new(0.05,0,0.1,0)
GBtn.Text = "G"
GBtn.BackgroundColor3 = COLORS.Accent
GBtn.TextColor3 = COLORS.Text
Instance.new("UICorner", GBtn).CornerRadius = UDim.new(1,0)

GBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

print("🔥 GlowHub V6.1 اشتغل بدون أعذار")
