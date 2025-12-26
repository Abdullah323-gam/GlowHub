local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera

-- تنظيف النسخ القديمة
if PlayerGui:FindFirstChild("GlowHub_Super_V1.1") then PlayerGui:FindFirstChild("GlowHub_Super_V1.1"):Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "GlowHub_Super_V1.1"
ScreenGui.ResetOnSpawn = false

-- اللوحة الرئيسية (نفس شكل 6.3v المربع الواسع)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 250, 0, 600) 
Main.Position = UDim2.new(0.5, -125, 0.5, -300)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Active = true
Main.Draggable = true
Main.Visible = true

local UICorner = Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
Title.Text = "1.1v الخارق"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

-- دالة إنشاء الأزرار (نفس ستايل 6.3v)
local function createRow(name, yPos, type)
    local label = Instance.new("TextLabel", Main)
    label.Size = UDim2.new(0, 100, 0, 30)
    label.Position = UDim2.new(0.05, 0, 0, yPos)
    label.Text = name
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    
    if type == "Toggle" then
        local btn = Instance.new("TextButton", Main)
        btn.Size = UDim2.new(0, 30, 0, 30)
        btn.Position = UDim2.new(0.85, 0, 0, yPos)
        btn.Text = ""
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        Instance.new("UICorner", btn)
        return btn
    end
end

-- ================= الأوامر الكاملة =================

-- 1. السرعة
local speedB = createRow("السرعة الخارقة", 50, "Toggle")
local speedActive = false
speedB.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    speedB.Text = speedActive and "✓" or ""
    speedB.BackgroundColor3 = speedActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
end)

-- 2. الطيران
local flyB = createRow("الطيران", 90, "Toggle")
local flyActive = false
flyB.MouseButton1Click:Connect(function()
    flyActive = not flyActive
    flyB.Text = flyActive and "✓" or ""
    flyB.BackgroundColor3 = flyActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
end)

-- 3. اختراق الجدران
local ncB = createRow("اختراق الجدران", 130, "Toggle")
local ncActive = false
ncB.MouseButton1Click:Connect(function()
    ncActive = not ncActive
    ncB.Text = ncActive and "✓" or ""
    ncB.BackgroundColor3 = ncActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
end)

-- 4. قذف (Fling) - تم إصلاح القوة والتدوير
local flingB = createRow("قذف (WalkFling)", 170, "Toggle")
local flingActive = false
flingB.MouseButton1Click:Connect(function()
    flingActive = not flingActive
    flingB.Text = flingActive and "✓" or ""
    flingB.BackgroundColor3 = flingActive and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(60, 60, 60)
end)

-- 5. كشف أماكن (ESP)
local espB = createRow("كشف أماكن (ESP)", 210, "Toggle")
local espActive = false
local espFolder = Instance.new("Folder", game.CoreGui)
espB.MouseButton1Click:Connect(function()
    espActive = not espActive
    espB.Text = espActive and "✓" or ""
    espB.BackgroundColor3 = espActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    if not espActive then espFolder:ClearAllChildren() end
end)

-- 6. عودة للموت (انتظار 4 ثواني)
local backB = createRow("عودة للموت", 250, "Toggle")
local backActive = false
local lastDeathPos = nil
backB.MouseButton1Click:Connect(function()
    backActive = not backActive
    backB.Text = backActive and "✓" or ""
    backB.BackgroundColor3 = backActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
end)

-- 7. إنقاذ من السقوط
local voidB = createRow("إنقاذ من السقوط", 290, "Toggle")
local voidActive = false
voidB.MouseButton1Click:Connect(function()
    voidActive = not voidActive
    voidB.Text = voidActive and "✓" or ""
    voidB.BackgroundColor3 = voidActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
end)

-- 8. اختفاء
local invB = createRow("الاختفاء", 330, "Toggle")
local invActive = false
invB.MouseButton1Click:Connect(function()
    invActive = not invActive
    invB.Text = invActive and "✓" or ""
    invB.BackgroundColor3 = invActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
end)

-- 9. قسم الانتقال (TP) - مصلح تماماً
local tpLabel = Instance.new("TextLabel", Main)
tpLabel.Size = UDim2.new(1, 0, 0, 30); tpLabel.Position = UDim2.new(0, 0, 0, 375)
tpLabel.Text = "انتقال للاعب:"; tpLabel.TextColor3 = Color3.new(1,1,1); tpLabel.BackgroundTransparency = 1

local tpIn = Instance.new("TextBox", Main)
tpIn.Size = UDim2.new(0.8, 0, 0, 30); tpIn.Position = UDim2.new(0.1, 0, 0, 410)
tpIn.PlaceholderText = "اكتب الاسم هنا..."
tpIn.BackgroundColor3 = Color3.fromRGB(40,40,40); tpIn.TextColor3 = Color3.new(1,1,1)

local tpDo = Instance.new("TextButton", Main)
tpDo.Size = UDim2.new(0.8, 0, 0, 35); tpDo.Position = UDim2.new(0.1, 0, 0, 450)
tpDo.Text = "انتقال الآن"; tpDo.BackgroundColor3 = Color3.fromRGB(180, 0, 0); tpDo.TextColor3 = Color3.new(1,1,1)

tpDo.MouseButton1Click:Connect(function()
    local target = tpIn.Text:lower()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Name:lower():find(target) then
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            end
            break
        end
    end
end)

-- ================= نظام التشغيل (Backend) =================

RunService.Heartbeat:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = Player.Character.HumanoidRootPart
        local hum = Player.Character.Humanoid
        
        -- سرعة
        if speedActive then hum.WalkSpeed = 100 else hum.WalkSpeed = 16 end
        
        -- اختراق
        if ncActive then
            for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
        
        -- فلينج مصلح (طريقة الاهتزاز العنيف)
        if flingActive then
            hrp.Velocity = Vector3.new(0, 10000, 0) -- قوة وهمية
            RunService.RenderStepped:Wait()
            hrp.Velocity = Vector3.new(0, 0, 0)
            hrp.RotVelocity = Vector3.new(0, 10000, 0) -- دوران فائق السرعة
        end
        
        -- حفظ الموقع للعودة
        if backActive and hum.Health > 0 then lastDeathPos = hrp.CFrame end
        
        -- منع السقوط
        if voidActive and hrp.Position.Y < -50 then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    hrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                    hrp.Velocity = Vector3.new(0,0,0)
                    break
                end
            end
        end
        
        -- اختفاء
        if invActive then
            for _, v in pairs(Player.Character:GetDescendants()) do
                if (v:IsA("BasePart") or v:IsA("Decal")) and v.Name ~= "HumanoidRootPart" then v.Transparency = 1 end
            end
        end
    end
end)

-- العودة للموت (انتظار 4 ثواني)
Player.CharacterAdded:Connect(function(char)
    if backActive and lastDeathPos then
        task.wait(4)
        local hrp = char:WaitForChild("HumanoidRootPart", 10)
        if hrp then hrp.CFrame = lastDeathPos end
    end
end)

-- تشغيل الـ ESP
RunService.RenderStepped:Connect(function()
    if espActive then
        espFolder:ClearAllChildren()
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= Player and p.Character then
                local hl = Instance.new("Highlight", espFolder)
                hl.Adornee = p.Character; hl.FillColor = Color3.new(1, 0, 0)
            end
        end
    end
end)
