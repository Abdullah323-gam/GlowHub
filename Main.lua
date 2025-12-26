local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera

-- 1. تنظيف وإعداد الواجهة
if PlayerGui:FindFirstChild("GlowHubV6_1") then PlayerGui.GlowHubV6_1:Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "GlowHubV6_1"
ScreenGui.ResetOnSpawn = false -- ضروري لعمل Auto Back

-- 2. زر الفتح (متحرك ولا يغطي القفز)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0.9, 0, 0.4, 0) -- مكان آمن
OpenBtn.Text = "MENU"
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.Style = Enum.ButtonStyle.RobloxRoundDefaultButton
OpenBtn.Draggable = true -- قابل للتحريك
OpenBtn.Active = true

-- 3. القائمة الرئيسية (تم توسيعها)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 250, 0, 580) -- تكبير الحجم للأوامر الجديدة
Main.Position = UDim2.new(0.5, -125, 0.5, -290)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Active = true
Main.Draggable = true
Main.Visible = false

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Title.Text = "GlowHub V6.1"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1,1,1)

local function toggleGui(show)
    Main.Visible = show
    OpenBtn.Visible = not show
end
OpenBtn.MouseButton1Click:Connect(function() toggleGui(true) end)
CloseBtn.MouseButton1Click:Connect(function() toggleGui(false) end)

-- دالة إنشاء الأزرار (مرتبة جداً)
local function createRow(name, yPos, type)
    local label = Instance.new("TextLabel", Main)
    label.Size = UDim2.new(0, 100, 0, 30)
    label.Position = UDim2.new(0.05, 0, 0, yPos)
    label.Text = name
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    
    if type == "Value" then
        local minus = Instance.new("TextButton", Main)
        minus.Size = UDim2.new(0, 30, 0, 30)
        minus.Position = UDim2.new(0.45, 0, 0, yPos)
        minus.Text = "-"
        minus.BackgroundColor3 = Color3.fromRGB(50,50,50)
        minus.TextColor3 = Color3.new(1,1,1)
        
        local input = Instance.new("TextBox", Main)
        input.Size = UDim2.new(0, 50, 0, 30)
        input.Position = UDim2.new(0.6, 0, 0, yPos)
        input.Text = "16"
        input.BackgroundColor3 = Color3.fromRGB(40,40,40)
        input.TextColor3 = Color3.new(1,1,1)
        
        local plus = Instance.new("TextButton", Main)
        plus.Size = UDim2.new(0, 30, 0, 30)
        plus.Position = UDim2.new(0.85, 0, 0, yPos)
        plus.Text = "+"
        plus.BackgroundColor3 = Color3.fromRGB(50,50,50)
        plus.TextColor3 = Color3.new(1,1,1)
        return minus, input, plus
    elseif type == "Toggle" then
        local btn = Instance.new("TextButton", Main)
        btn.Size = UDim2.new(0, 30, 0, 30)
        btn.Position = UDim2.new(0.85, 0, 0, yPos)
        btn.Text = ""
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        btn.TextColor3 = Color3.new(1,1,1)
        return btn
    end
end

-- ================= الأوامر =================

-- 1. السرعة (Y: 45)
local sM, sIn, sP = createRow("Speed", 45, "Value")
sM.MouseButton1Click:Connect(function() sIn.Text = tostring(tonumber(sIn.Text)-1) end)
sP.MouseButton1Click:Connect(function() sIn.Text = tostring(tonumber(sIn.Text)+1) end)
RunService.RenderStepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = tonumber(sIn.Text) or 16
    end
end)

-- 2. القفز (Y: 85)
local jM, jIn, jP = createRow("Jump", 85, "Value")
jIn.Text = "50"
jM.MouseButton1Click:Connect(function() jIn.Text = tostring(tonumber(jIn.Text)-5) end)
jP.MouseButton1Click:Connect(function() jIn.Text = tostring(tonumber(jIn.Text)+5) end)
RunService.RenderStepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.UseJumpPower = true
        Player.Character.Humanoid.JumpPower = tonumber(jIn.Text) or 50
    end
end)

-- 3. قفز لا نهائي (Y: 125)
local infJ = createRow("Inf Jump", 125, "Toggle")
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

-- 4. اختراق الجدران Noclip (Y: 165)
local ncB = createRow("Noclip", 165, "Toggle")
local ncActive = false
ncB.MouseButton1Click:Connect(function() 
    ncActive = not ncActive 
    ncB.Text = ncActive and "✓" or ""
    ncB.BackgroundColor3 = ncActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    if not ncActive and Player.Character then
        -- عند الإطفاء يعيد التصادم
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

-- 5. طيران Fly (Y: 205)
local flyB = createRow("Fly", 205, "Toggle")
local flyActive = false
flyB.MouseButton1Click:Connect(function()
    flyActive = not flyActive
    flyB.Text = flyActive and "✓" or ""
    flyB.BackgroundColor3 = flyActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if flyActive and root then
        local bg = Instance.new("BodyGyro", root)
        bg.Name = "FlyGyro"
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = root.CFrame
        
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "FlyVel"
        bv.velocity = Vector3.new(0, 0.1, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        task.spawn(function()
            while flyActive and char:FindFirstChild("Humanoid") do
                char.Humanoid.PlatformStand = true
                local speed = 50
                local moveDir = Vector3.new(0,0,0)
                if char.Humanoid.MoveDirection.Magnitude > 0 then
                    moveDir = Camera.CFrame.LookVector * char.Humanoid.MoveDirection.Z * speed + 
                              Camera.CFrame.RightVector * char.Humanoid.MoveDirection.X * speed
                end
                bg.cframe = Camera.CFrame
                bv.velocity = moveDir
                task.wait()
            end
            if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
            if root:FindFirstChild("FlyVel") then root.FlyVel:Destroy() end
            char.Humanoid.PlatformStand = false
        end)
    else
        if root and root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
        if root and root:FindFirstChild("FlyVel") then root.FlyVel:Destroy() end
        if char then char.Humanoid.PlatformStand = false end
    end
end)

-- 6. إظهار ESP (Y: 245)
local espB = createRow("ESP", 245, "Toggle")
local espActive = false
local espFolder = Instance.new("Folder", game.CoreGui)
espB.MouseButton1Click:Connect(function()
    espActive = not espActive
    espB.Text = espActive and "✓" or ""
    espB.BackgroundColor3 = espActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    if not espActive then espFolder:ClearAllChildren() end
end)
RunService.RenderStepped:Connect(function()
    espFolder:ClearAllChildren()
    if espActive then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= Player and plr.Character then
                local hl = Instance.new("Highlight")
                hl.Adornee = plr.Character
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.5
                hl.Parent = espFolder
            end
        end
    end
end)

-- 7. إضاءة Fullbright (إصلاح كامل) (Y: 285)
local fbB = createRow("Fullbright", 285, "Toggle")
local fbActive = false
fbB.MouseButton1Click:Connect(function()
    fbActive = not fbActive
    fbB.Text = fbActive and "✓" or ""
    fbB.BackgroundColor3 = fbActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    
    if not fbActive then
        -- إعادة الإضاءة للوضع الطبيعي عند الإطفاء
        Lighting.Brightness = 1
        Lighting.ClockTime = 14 -- وقت الظهيرة الافتراضي
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 10000
    end
end)
RunService.RenderStepped:Connect(function()
    if fbActive then
        Lighting.Brightness = 2
        Lighting.ClockTime = 12 -- تثبيت على الظهر
        Lighting.GlobalShadows = false -- إزالة الظلال
        Lighting.FogEnd = 9e9 -- إزالة الضباب
    end
end)

-- 8. قذف Fling (دوران سريع جداً) (Y: 325)
local flB = createRow("Spin Fling", 325, "Toggle")
local flActive = false
flB.MouseButton1Click:Connect(function()
    flActive = not flActive
    flB.Text = flActive and "✓" or ""
    flB.BackgroundColor3 = flActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        if flActive then
            -- إضافة قوة دوران هائلة
            local bav = Instance.new("BodyAngularVelocity")
            bav.Name = "SpinFlingVelocity"
            bav.MaxTorque = Vector3.new(0, math.huge, 0) -- قوة لا نهائية على المحور Y
            bav.AngularVelocity = Vector3.new(0, 10000, 0) -- سرعة دوران جنونية
            bav.Parent = root
        else
            -- إزالة الدوران
            for _, v in pairs(root:GetChildren()) do
                if v.Name == "SpinFlingVelocity" then v:Destroy() end
            end
            root.RotVelocity = Vector3.new(0,0,0)
        end
    end
end)

-- 9. اختفاء Invis (Y: 365)
local invB = createRow("Invis", 365, "Toggle")
local invActive = false
local function updateInvis()
    if Player.Character then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                if part.Name ~= "HumanoidRootPart" then
                    part.Transparency = invActive and 1 or 0
                end
            end
        end
    end
end
invB.MouseButton1Click:Connect(function()
    invActive = not invActive
    invB.Text = invActive and "✓" or ""
    invB.BackgroundColor3 = invActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    updateInvis()
end)
Player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if invActive then updateInvis() end
end)

-- 10. عودة للموت Auto Back (Y: 405)
local backB = createRow("Auto Back", 405, "Toggle")
local backActive = false
local lastDeathPos = nil
backB.MouseButton1Click:Connect(function()
    backActive = not backActive
    backB.Text = backActive and "✓" or ""
    backB.BackgroundColor3 = backActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
end)
RunService.RenderStepped:Connect(function()
    if backActive and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local hum = Player.Character:FindFirstChild("Humanoid")
        if hum and hum.Health > 0 then
            lastDeathPos = Player.Character.HumanoidRootPart.CFrame
        end
    end
end)
Player.CharacterAdded:Connect(function(char)
    if backActive and lastDeathPos then
        local root = char:WaitForChild("HumanoidRootPart", 5)
        if root then
            task.wait(0.6)
            root.CFrame = lastDeathPos
        end
    end
end)

-- 11. انتقال (Y: 455)
local tpBtn = Instance.new("TextButton", Main)
tpBtn.Size = UDim2.new(0, 60, 0, 30); tpBtn.Position = UDim2.new(0.05, 0, 0, 455); tpBtn.Text = "TP To"
tpBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); tpBtn.TextColor3 = Color3.new(1,1,1)
local tpIn = Instance.new("TextBox", Main)
tpIn.Size = UDim2.new(0, 120, 0, 30); tpIn.Position = UDim2.new(0.35, 0, 0, 455); tpIn.PlaceholderText = "Player Name"
tpIn.BackgroundColor3 = Color3.fromRGB(40,40,40); tpIn.TextColor3 = Color3.new(1,1,1)
tpBtn.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= Player and (tpIn.Text == "" or p.Name:lower():find(tpIn.Text:lower())) then
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                 Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,2,0)
            end
            break
        end
    end
end)
