--[[
    GlowHub V6 - النسخة العربية المحدثة
    تم إصلاح: نظام اختيار اللاعبين، التعريب، وربط الأزرار
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // الإعدادات //
local COLORS = {
    Background = Color3.fromRGB(20, 20, 20),
    Accent = Color3.fromRGB(0, 120, 215),
    Text = Color3.fromRGB(255, 255, 255),
    Success = Color3.fromRGB(0, 255, 120),
    Idle = Color3.fromRGB(100, 100, 100)
}

local Toggles = { Fly = false, Noclip = false, InfJump = false, Speed = false, AutoBack = false }
local Values = { Speed = 16, SelectedPlayer = nil, SavedPos = nil }

-- // إنشاء الواجهة //
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GlowHub_Arabic"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer.PlayerGui end

-- اللوحة الرئيسية
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 420)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -210)
MainFrame.BackgroundColor3 = COLORS.Background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- الشريط العلوي
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = COLORS.Accent
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Text = "جلو هوب V6"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = COLORS.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = TopBar

-- قائمة التمرير
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10, 1, -50)
Scroll.Position = UDim2.new(0, 5, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.Parent = MainFrame
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 5)

-- // وظائف مساعدة //
local function createToggle(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Btn.Text = "  " .. text
    Btn.TextColor3 = COLORS.Text
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 14
    Btn.TextXAlignment = Enum.TextXAlignment.Right
    Btn.Parent = Scroll
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 10, 0, 10)
    Indicator.Position = UDim2.new(0.05, 0, 0.5, -5)
    Indicator.BackgroundColor3 = COLORS.Idle
    Indicator.Parent = Btn
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
    
    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Indicator.BackgroundColor3 = state and COLORS.Success or COLORS.Idle
        callback(state)
    end)
end

-- // قائمة اختيار اللاعبين (الحقيقية) //
local DropdownFrame = Instance.new("Frame")
DropdownFrame.Size = UDim2.new(1, -10, 0, 40)
DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DropdownFrame.Parent = Scroll
Instance.new("UICorner", DropdownFrame)

local SelectedLabel = Instance.new("TextButton")
SelectedLabel.Size = UDim2.new(1, 0, 1, 0)
SelectedLabel.Text = "اختر لاعب من هنا"
SelectedLabel.TextColor3 = COLORS.Text
SelectedLabel.BackgroundTransparency = 1
SelectedLabel.Parent = DropdownFrame

local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Size = UDim2.new(1, 0, 0, 120)
PlayerListFrame.Position = UDim2.new(0, 0, 1, 5)
PlayerListFrame.Visible = false
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
PlayerListFrame.ZIndex = 5
PlayerListFrame.Parent = DropdownFrame
Instance.new("UIListLayout", PlayerListFrame)

local function updatePlayers()
    for _, v in pairs(PlayerListFrame:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1, 0, 0, 30)
            pBtn.Text = plr.Name
            pBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            pBtn.TextColor3 = COLORS.Text
            pBtn.ZIndex = 6
            pBtn.Parent = PlayerListFrame
            pBtn.MouseButton1Click:Connect(function()
                Values.SelectedPlayer = plr
                SelectedLabel.Text = "المختار: " .. plr.Name
                PlayerListFrame.Visible = false
            end)
        end
    end
end

SelectedLabel.MouseButton1Click:Connect(function()
    PlayerListFrame.Visible = not PlayerListFrame.Visible
    updatePlayers()
end)

-- // الأوامر الأساسية //

createToggle("طيران (CFrame)", function(s)
    Toggles.Fly = s
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then root.Anchored = s end
end)

createToggle("اختراق الجدران", function(s) Toggles.Noclip = s end)
createToggle("قفز لا نهائي", function(s) Toggles.InfJump = s end)
createToggle("الرجوع بعد الموت", function(s) Toggles.AutoBack = s end)

-- زر الانتقال (Teleport)
local TPBtn = Instance.new("TextButton")
TPBtn.Size = UDim2.new(1, -10, 0, 35)
TPBtn.BackgroundColor3 = COLORS.Accent
TPBtn.Text = "انتقال إلى اللاعب المختار"
TPBtn.TextColor3 = COLORS.Text
TPBtn.Parent = Scroll
Instance.new("UICorner", TPBtn)

TPBtn.MouseButton1Click:Connect(function()
    if Values.SelectedPlayer and Values.SelectedPlayer.Character then
        local targetPos = Values.SelectedPlayer.Character:GetPivot()
        LocalPlayer.Character:PivotTo(targetPos)
    end
end)

-- زر نسخ الملابس (Skin Copy)
local SkinBtn = Instance.new("TextButton")
SkinBtn.Size = UDim2.new(1, -10, 0, 35)
SkinBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 200)
SkinBtn.Text = "نسخ ملابس اللاعب"
SkinBtn.TextColor3 = COLORS.Text
SkinBtn.Parent = Scroll
Instance.new("UICorner", SkinBtn)

SkinBtn.MouseButton1Click:Connect(function()
    if Values.SelectedPlayer and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            local desc = Players:GetHumanoidDescriptionFromUserId(Values.SelectedPlayer.UserId)
            hum:ApplyDescription(desc)
        end
    end
end)

-- // الأنظمة الخلفية //

-- حلقة الطيران والجدران
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    
    -- الطيران
    if Toggles.Fly and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart
        local moveDir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Camera.CFrame.LookVector end
        root.CFrame = root.CFrame + (moveDir * 1.5)
    end
    
    -- اختراق الجدران
    if Toggles.Noclip then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- قفز لا نهائي
UserInputService.JumpRequest:Connect(function()
    if Toggles.InfJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- نظام الرجوع بعد الموت
LocalPlayer.CharacterAdded:Connect(function(char)
    if Toggles.AutoBack and Values.SavedPos then
        task.wait(1)
        char:PivotTo(Values.SavedPos)
        Values.SavedPos = nil
    end
    char:WaitForChild("Humanoid").Died:Connect(function()
        if Toggles.AutoBack then Values.SavedPos = char:GetPivot() end
    end)
end)

-- الزر العائم (G)
local GBtn = Instance.new("TextButton")
GBtn.Size = UDim2.new(0, 45, 0, 45)
GBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
GBtn.BackgroundColor3 = COLORS.Accent
GBtn.Text = "G"
GBtn.TextColor3 = COLORS.Text
GBtn.Parent = ScreenGui
Instance.new("UICorner", GBtn).CornerRadius = UDim.new(1, 0)

GBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

print("تم تشغيل جلو هوب العربي بنجاح!")
