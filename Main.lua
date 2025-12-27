local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- تنظيف أي نسخة قديمة لضمان عدم التداخل
if PlayerGui:FindFirstChild("GlowBox_V4_6_Mobile") then 
    PlayerGui.GlowBox_V4_6_Mobile:Destroy() 
end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "GlowBox_V4_6_Mobile"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- [ اللوحة الرئيسية - تم تعديل الحجم للجوال ]
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 220, 0, 300) -- حجم أصغر ومناسب للجوال
Main.Position = UDim2.new(0.5, -110, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Visible = false -- تبدأ مخفية وتظهر عند ضغط زر G
local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 15)

-- [ العنوان ]
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Title.Text = "GLOWBOX V4.6 MOBILE"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
local TitleCorner = Instance.new("UICorner", Title)

-- [ زر الفتح والإغلاق للجوال ]
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Name = "MobileToggle"
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
ToggleBtn.Text = "G"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 20
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

-- وظيفة الفتح والإغلاق
ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- [ قائمة الخيارات ]
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -10, 1, -45)
Scroll.Position = UDim2.new(0, 5, 0, 40)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
Scroll.ScrollBarThickness = 2

-- دالة إنشاء الأزرار للجوال
local function createBtn(name, yPos, callback, color)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(45, 45, 45)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        task.wait(0.1)
        btn.BackgroundColor3 = color or Color3.fromRGB(45, 45, 45)
        callback()
    end)
end

-- [ إضافة القدرات المطلوبة ]

-- 1. الرجوع من الموت
createBtn("💀 الرجوع من الموت", 10, function()
    local lastSafePos = nil
    task.spawn(function()
        while true do
            local char = Player.Character
            local hum = char and char:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 and hum.Health < 25 then
                lastSafePos = char.HumanoidRootPart.CFrame
                task.wait(5)
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = lastSafePos
                end
            end
            task.wait(1)
        end
    end)
end, Color3.fromRGB(200, 50, 50))

-- 2. ESP خطوط (Highlight)
createBtn("🌈 ESP خطوط الجسم", 55, function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character then
            local h = Instance.new("Highlight", v.Character)
            h.FillTransparency = 1
            h.OutlineColor = Color3.new(0, 1, 0)
        end
    end
end)

-- 3. ESP نوب (الاتجاه)
createBtn("🤖 ESP نوب (المختفين)", 100, function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local n = Instance.new("Part", v.Character)
            n.Size = Vector3.new(2,2,2)
            n.Color = Color3.new(1,1,0)
            n.CanCollide = false
            local bg = Instance.new("BillboardGui", n)
            bg.Size = UDim2.new(0, 50, 0, 50)
            bg.AlwaysOnTop = true
            local tl = Instance.new("TextLabel", bg)
            tl.Text = "PLAYER HERE"
            tl.Size = UDim2.new(1,0,1,0)
            tl.BackgroundTransparency = 1
            tl.TextColor3 = Color3.new(1,1,1)
            RunService.RenderStepped:Connect(function()
                n.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 4, 0)
            end)
        end
    end
end)

-- 4. WalkFling المطور
createBtn("🌪️ WalkFling (IY)", 145, function()
    local char = Player.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local vel = hrp.Velocity
    hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
    RunService.RenderStepped:Wait()
    hrp.Velocity = vel
end)

-- 5. طيران للجوال
createBtn("✈️ تفعيل الطيران", 190, function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.lua"))()
end, Color3.fromRGB(0, 120, 215))

-- [ نظام سحب بسيط للجوال ]
local dragging, dragStart, startPos
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = ToggleBtn.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
ToggleBtn.InputEnded:Connect(function() dragging = false end)
