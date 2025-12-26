local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- تنظيف النسخ القديمة
if PlayerGui:FindFirstChild("GlowBox_Ultimate_V4") then PlayerGui.GlowBox_Ultimate_V4:Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "GlowBox_Ultimate_V4"
ScreenGui.ResetOnSpawn = false

-- 1. زر الفتح (G) - ملون
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 20, 0.5, 0)
OpenBtn.Text = "G"; OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
OpenBtn.TextColor3 = Color3.new(1,1,1); OpenBtn.Font = Enum.Font.GothamBold; OpenBtn.TextSize = 25
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
OpenBtn.Draggable = true 

-- 2. اللوحة الرئيسية (ملونة وجذابة)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 430) 
Main.Position = UDim2.new(0.5, -130, 0.5, -215)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0; Main.Active = true; Main.Draggable = true; Main.Visible = false
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40); Title.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Title.Text = "✨ GLOWBOX V4.5 PREMIUM ✨"; Title.TextColor3 = Color3.new(1, 1, 1); Title.Font = Enum.Font.GothamBold
Instance.new("UICorner", Title)

-- زر الخروج (X) أحمر وواضح
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80); CloseBtn.BackgroundTransparency = 1; CloseBtn.TextSize = 22; CloseBtn.Font = "GothamBold"
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)

OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, 0, 1, -50); Scroll.Position = UDim2.new(0, 0, 0, 45)
Scroll.BackgroundTransparency = 1; Scroll.CanvasSize = UDim2.new(0, 0, 0, 1050); Scroll.ScrollBarThickness = 4

-- دالة الصفوف مع تحسين الوضوح والألوان
local function createRow(name, yPos, type)
    local label = Instance.new("TextLabel", Scroll)
    label.Size = UDim2.new(0, 110, 0, 35); label.Position = UDim2.new(0.05, 0, 0, yPos)
    label.Text = name; label.TextColor3 = Color3.fromRGB(220, 220, 220); label.BackgroundTransparency = 1; label.Font = Enum.Font.GothamSemibold; label.TextXAlignment = "Left"
    
    if type == "Value" then
        local m = Instance.new("TextButton", Scroll); m.Size = UDim2.new(0, 28, 0, 28); m.Position = UDim2.new(0.48, 0, 0, yPos); m.Text = "-"; m.BackgroundColor3 = Color3.fromRGB(255, 60, 60); m.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", m)
        local i = Instance.new("TextBox", Scroll); i.Size = UDim2.new(0, 45, 0, 28); i.Position = UDim2.new(0.6, 0, 0, yPos); i.Text = "16"; i.BackgroundColor3 = Color3.fromRGB(40,40,40); i.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", i)
        local p = Instance.new("TextButton", Scroll); p.Size = UDim2.new(0, 28, 0, 28); p.Position = UDim2.new(0.82, 0, 0, yPos); p.Text = "+"; p.BackgroundColor3 = Color3.fromRGB(60, 255, 60); p.TextColor3 = Color3.fromRGB(0,0,0); Instance.new("UICorner", p)
        return m, i, p
    elseif type == "Toggle" then
        local b = Instance.new("TextButton", Scroll); b.Size = UDim2.new(0, 35, 0, 28); b.Position = UDim2.new(0.8, 0, 0, yPos); b.Text = ""
        b.BackgroundColor3 = Color3.fromRGB(50,50,50); Instance.new("UICorner", b)
        return b
    end
end

-- [ الأوامر ]
local sM, sIn, sP = createRow("⚡ السرعة", 10, "Value")
local jM, jIn, jP = createRow("🚀 القفز", 50, "Value")
local flyB = createRow("✈️ طيران", 90, "Toggle")
local flB = createRow("🌪️ قذف (Fling)", 130, "Toggle")
local toolB = createRow("🎒 بقاء الأدوات", 170, "Toggle")
local fastB = createRow("⏲️ فسخ الوقت", 210, "Toggle")

-- نظام التحكم في الـ Toggle مع علامة صح واضحة جداً
local states = {}
local function handleToggle(btn, key, callback)
    states[key] = false
    btn.MouseButton1Click:Connect(function()
        states[key] = not states[key]
        if states[key] then
            btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0) -- لون أخضر للمربع
            btn.Text = "✓"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = "GothamBold"
        else
            btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
            btn.Text = ""
        end
        callback(states[key])
    end)
end

-- 1. القذف المصلح (يتعطل عند إزالة الصح)
handleToggle(flB, "fling", function(active) end)
RunService.Heartbeat:Connect(function()
    if states["fling"] and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = Player.Character.HumanoidRootPart
        hrp.Velocity = Vector3.new(0, 1000000, 0)
        hrp.RotVelocity = Vector3.new(0, 1000000, 0)
    end
end)

-- 2. الطيران
handleToggle(flyB, "fly", function(active)
    if active then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.lua"))()
    end
end)

-- 3. فسخ الوقت (يتعطل عند إزالة الصح)
handleToggle(fastB, "fast", function(active) end)
task.spawn(function()
    while true do task.wait()
        if states["fast"] and Player.Character then
            local tool = Player.Character:FindFirstChildOfClass("Tool")
            if tool then tool.Enabled = true end
        end
    end
end)

-- [ قائمة اللاعبين ]
local PList = Instance.new("ScrollingFrame", Scroll)
PList.Size = UDim2.new(0.9, 0, 0, 110); PList.Position = UDim2.new(0.05, 0, 0, 255)
PList.BackgroundColor3 = Color3.fromRGB(35, 35, 35); Instance.new("UIListLayout", PList)

local selectedPlr = ""
local function updateList()
    for _, v in pairs(PList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= Player then
            local b = Instance.new("TextButton", PList); b.Size = UDim2.new(1, 0, 0, 25); b.Text = p.Name; b.BackgroundColor3 = Color3.fromRGB(45,45,45); b.TextColor3 = Color3.new(1,1,1)
            b.MouseButton1Click:Connect(function()
                selectedPlr = p.Name
                for _, btn in pairs(PList:GetChildren()) do if btn:IsA("TextButton") then btn.BackgroundColor3 = Color3.fromRGB(45,45,45) end end
                b.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
            end)
        end
    end
end
updateList(); game.Players.PlayerAdded:Connect(updateList); game.Players.PlayerRemoving:Connect(updateList)

-- أزرار الانتقال والملابس
local function createActionBtn(txt, y, color, func)
    local btn = Instance.new("TextButton", Scroll); btn.Size = UDim2.new(0.9, 0, 0, 35); btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.Text = txt; btn.BackgroundColor3 = color; btn.TextColor3 = Color3.new(1,1,1); btn.Font = "GothamBold"
    Instance.new("UICorner", btn); btn.MouseButton1Click:Connect(func)
end

createActionBtn("📍 انتقال للاعب المختار", 375, Color3.fromRGB(0, 120, 215), function()
    local t = game.Players:FindFirstChild(selectedPlr)
    if t then Player.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame end
end)

createActionBtn("👕 نسخ ملابس المختار", 420, Color3.fromRGB(150, 50, 200), function()
    local t = game.Players:FindFirstChild(selectedPlr)
    if t and t.Character then
        for _, v in pairs(Player.Character:GetChildren()) do if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") then v:Destroy() end end
        for _, v in pairs(t.Character:GetChildren()) do if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") then v:Clone().Parent = Player.Character end end
    end
end)

-- تحكم القيم
sM.MouseButton1Click:Connect(function() sIn.Text = tostring(tonumber(sIn.Text)-5) end)
sP.MouseButton1Click:Connect(function() sIn.Text = tostring(tonumber(sIn.Text)+5) end)
jM.MouseButton1Click:Connect(function() jIn.Text = tostring(tonumber(jIn.Text)-10) end)
jP.MouseButton1Click:Connect(function() jIn.Text = tostring(tonumber(jIn.Text)+10) end)

RunService.RenderStepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = tonumber(sIn.Text) or 16
        Player.Character.Humanoid.JumpPower = tonumber(jIn.Text) or 50
    end
end)
