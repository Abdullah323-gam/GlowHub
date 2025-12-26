local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- تنظيف النسخ القديمة
if PlayerGui:FindFirstChild("GlowHubV5") then PlayerGui.GlowHubV5:Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "GlowHubV5"
ScreenGui.ResetOnSpawn = false

-- الإطار الرئيسي (القائمة)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 250, 0, 450) -- زدنا الطول قليلاً لزر الإضاءة
Main.Position = UDim2.new(0.5, -125, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Visible = false -- نبدأ وهي مخفية

-- العنوان
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Title.Text = "GlowHub V5"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- زر الإغلاق (X)
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1,1,1)

-- زر الفتح (مكانه الجديد: أسفل اليمين، تحت زر القفز)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
-- الموقع: (1, -80) يعني أقصى اليمين مع إزاحة قليلة، (0.8, 0) يعني أسفل الشاشة
OpenBtn.Position = UDim2.new(1, -90, 0.75, 0) 
OpenBtn.Text = "MENU"
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.BackgroundTransparency = 0.5 -- شفاف قليلاً لكي لا يزعجك
OpenBtn.Style = Enum.ButtonStyle.RobloxRoundDefaultButton -- شكل دائري جميل
OpenBtn.Font = Enum.Font.GothamBold

-- وظائف الفتح والإغلاق
local function toggleGui(show)
    Main.Visible = show
    OpenBtn.Visible = not show -- يخفي زر الفتح عند فتح القائمة
end

OpenBtn.MouseButton1Click:Connect(function() toggleGui(true) end)
CloseBtn.MouseButton1Click:Connect(function() toggleGui(false) end)

-- دالة إنشاء الأزرار
local function createRow(name, pos, type)
    local label = Instance.new("TextLabel", Main)
    label.Size = UDim2.new(0, 90, 0, 30)
    label.Position = UDim2.new(0.05, 0, pos, 0)
    label.Text = name
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham

    if type == "Value" then
        local minus = Instance.new("TextButton", Main)
        minus.Size = UDim2.new(0, 30, 0, 30)
        minus.Position = UDim2.new(0.45, 0, pos, 0)
        minus.Text = "-"
        minus.BackgroundColor3 = Color3.fromRGB(50,50,50)
        minus.TextColor3 = Color3.new(1,1,1)
        
        local input = Instance.new("TextBox", Main)
        input.Size = UDim2.new(0, 60, 0, 30)
        input.Position = UDim2.new(0.6, 0, pos, 0)
        input.Text = "16"
        input.BackgroundColor3 = Color3.fromRGB(40,40,40)
        input.TextColor3 = Color3.new(1,1,1)
        
        local plus = Instance.new("TextButton", Main)
        plus.Size = UDim2.new(0, 30, 0, 30)
        plus.Position = UDim2.new(0.85, 0, pos, 0)
        plus.Text = "+"
        plus.BackgroundColor3 = Color3.fromRGB(50,50,50)
        plus.TextColor3 = Color3.new(1,1,1)
        return minus, input, plus
    elseif type == "Toggle" then
        local btn = Instance.new("TextButton", Main)
        btn.Size = UDim2.new(0, 30, 0, 30)
        btn.Position = UDim2.new(0.85, 0, pos, 0)
        btn.Text = ""
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        btn.TextColor3 = Color3.new(1,1,1)
        return btn
    end
end

-- 1. السرعة
local sM, sIn, sP = createRow("السرعة", 0.1, "Value")
sM.MouseButton1Click:Connect(function() sIn.Text = tostring(tonumber(sIn.Text)-1) end)
sP.MouseButton1Click:Connect(function() sIn.Text = tostring(tonumber(sIn.Text)+1) end)
RunService.RenderStepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = tonumber(sIn.Text) or 16
    end
end)

-- 2. القفز
local jM, jIn, jP = createRow("القفز", 0.2, "Value")
jIn.Text = "50"
jM.MouseButton1Click:Connect(function() jIn.Text = tostring(tonumber(jIn.Text)-5) end)
jP.MouseButton1Click:Connect(function() jIn.Text = tostring(tonumber(jIn.Text)+5) end)
RunService.RenderStepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        local hum = Player.Character.Humanoid
        hum.UseJumpPower = true
        hum.JumpPower = tonumber(jIn.Text) or 50
    end
end)

-- 3. قفز لا نهائي
local infJ = createRow("قفز لا نهائي", 0.3, "Toggle")
local infJumpActive = false
infJ.MouseButton1Click:Connect(function() 
    infJumpActive = not infJumpActive 
    infJ.Text = infJumpActive and "✓" or "" 
    infJ.BackgroundColor3 = infJumpActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
end)
UserInputService.JumpRequest:Connect(function() 
    if infJumpActive and Player.Character then 
        Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") 
    end 
end)

-- 4. اختراق الجدران (Noclip)
local ncB = createRow("اختراق", 0.4, "Toggle")
local ncActive = false
ncB.MouseButton1Click:Connect(function() 
    ncActive = not ncActive 
    ncB.Text = ncActive and "✓" or ""
    ncB.BackgroundColor3 = ncActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    
    if not ncActive and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do 
            if v:IsA("BasePart") then v.CanCollide = true end 
        end
    end
end)
RunService.Stepped:Connect(function()
    if ncActive and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do 
            if v:IsA("BasePart") then v.CanCollide = false end 
        end
    end
end)

-- 5. إضاءة كاملة (Fullbright) - جديد!
local fbB = createRow("إضاءة (FB)", 0.5, "Toggle")
local fbActive = false
fbB.MouseButton1Click:Connect(function()
    fbActive = not fbActive
    fbB.Text = fbActive and "✓" or ""
    fbB.BackgroundColor3 = fbActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    
    if not fbActive then
        Lighting.ClockTime = 14 -- إعادة للوضع الطبيعي تقريباً
        Lighting.Brightness = 2
    end
end)
RunService.RenderStepped:Connect(function()
    if fbActive then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end)


-- 6. انتقال
local tpBtn = Instance.new("TextButton", Main)
tpBtn.Size = UDim2.new(0, 60, 0, 30)
tpBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
tpBtn.Text = "انتقال"
tpBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
tpBtn.TextColor3 = Color3.new(1,1,1)

local tpIn = Instance.new("TextBox", Main)
tpIn.Size = UDim2.new(0, 120, 0, 30)
tpIn.Position = UDim2.new(0.35, 0, 0.6, 0)
tpIn.PlaceholderText = "اكتب الاسم"
tpIn.Text = ""
tpIn.BackgroundColor3 = Color3.fromRGB(40,40,40)
tpIn.TextColor3 = Color3.new(1,1,1)

tpBtn.MouseButton1Click:Connect(function()
    local target = nil
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= Player and (tpIn.Text == "" or p.Name:lower():sub(1, #tpIn.Text) == tpIn.Text:lower()) then
            target = p
            if tpIn.Text ~= "" then break end
        end
    end
    if target and target.Character and Player.Character then
        local myRoot = Player.Character:FindFirstChild("HumanoidRootPart") or Player.Character:FindFirstChild("Torso")
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Torso")
        if myRoot and targetRoot then
            myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 2, 0)
        end
    end
end)

-- 7. طيران
local flyB = createRow("طيران", 0.7, "Toggle")
flyB.MouseButton1Click:Connect(function()
    flyB.Text = "✓"
    flyB.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.lua"))()
end)

-- 8. قذف (Fling)
local flB = createRow("قذف", 0.8, "Toggle")
flB.MouseButton1Click:Connect(function()
    flB.Text = "✓"
    flB.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/0866/Fling/main/Fling.lua"))()
end)

-- 9. إظهار (ESP)
local espB = createRow("إظهار", 0.9, "Toggle")
espB.MouseButton1Click:Connect(function()
    espB.Text = "✓"
    espB.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ic3w0lf22/UnnamedESP/master/Source.lua"))()
end)
