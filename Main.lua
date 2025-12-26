local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- تنظيف النسخ القديمة
if PlayerGui:FindFirstChild("GlowHub_Super_V1.1") then PlayerGui.GlowHub_Super_V1.1:Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "GlowHub_Super_V1.1"
ScreenGui.ResetOnSpawn = false

-- القائمة الرئيسية (تصميم طولي نحيف واحترافي)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 180, 0, 580) 
Main.Position = UDim2.new(0, 20, 0.5, -290) -- موقع جانبي
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Visible = true

local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 12)

-- العنوان
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(170, 0, 0) -- لون أحمر ناري "للخارق"
Title.Text = "V1.1 الخارق"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
local TitleCorner = Instance.new("UICorner", Title)

-- زر التصغير/الإخفاء (دائري وأنيق)
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 20, 0, 20)
ToggleBtn.Text = "G"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold
local TCorner = Instance.new("UICorner", ToggleBtn)
TCorner.CornerRadius = UDim.new(1, 0)
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- دالة إنشاء الأزرار (قائمة طولية)
local function createRow(name, yPos)
    local frame = Instance.new("Frame", Main)
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.Text = name
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 35, 0, 25)
    btn.Position = UDim2.new(0.75, 0, 0.2, 0)
    btn.Text = ""
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    local bCorner = Instance.new("UICorner", btn)
    return btn
end

-- ================= أوامر النسخة الخارقة =================

-- 1. السرعة القصوى
local speedB = createRow("سرعة خارقة", 55)
local speedActive = false
speedB.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    speedB.Text = speedActive and "✓" or ""
    speedB.BackgroundColor3 = speedActive and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)
end)
RunService.RenderStepped:Connect(function()
    if speedActive and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = 80
    elseif not speedActive and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = 16
    end
end)

-- 2. اختراق (Noclip)
local ncB = createRow("اختراق", 100)
local ncActive = false
ncB.MouseButton1Click:Connect(function()
    ncActive = not ncActive
    ncB.Text = ncActive and "✓" or ""
    ncB.BackgroundColor3 = ncActive and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)
end)
RunService.Stepped:Connect(function()
    if ncActive and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do 
            if v:IsA("BasePart") then v.CanCollide = false end 
        end
    end
end)

-- 3. قذف المشي الخارق (WalkFling - IY Mode)
local flB = createRow("قذف (Fling)", 145)
local flActive = false
flB.MouseButton1Click:Connect(function()
    flActive = not flActive
    flB.Text = flActive and "✓" or ""
    flB.BackgroundColor3 = flActive and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)
    
    if flActive then
        task.spawn(function()
            while flActive do
                RunService.Heartbeat:Wait()
                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = Player.Character.HumanoidRootPart
                    local oldV = hrp.Velocity
                    hrp.Velocity = Vector3.new(10000, 10000, 10000)
                    RunService.RenderStepped:Wait()
                    hrp.Velocity = oldV
                    hrp.RotVelocity = Vector3.new(0, 10000, 0)
                end
            end
        end)
    end
end)

-- 4. إضاءة FB
local fbB = createRow("إضاءة FB", 190)
local fbActive = false
fbB.MouseButton1Click:Connect(function()
    fbActive = not fbActive
    fbB.Text = fbActive and "✓" or ""
    fbB.BackgroundColor3 = fbActive and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)
    if not fbActive then Lighting.Brightness = 1; Lighting.GlobalShadows = true end
end)
RunService.RenderStepped:Connect(function()
    if fbActive then Lighting.Brightness = 2; Lighting.GlobalShadows = false end
end)

-- 5. اختفاء الشخصية
local invB = createRow("اختفاء", 235)
local invActive = false
invB.MouseButton1Click:Connect(function()
    invActive = not invActive
    invB.Text = invActive and "✓" or ""
    invB.BackgroundColor3 = invActive and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)
    if Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                if v.Name ~= "HumanoidRootPart" then v.Transparency = invActive and 1 or 0 end
            end
        end
    end
end)

-- 6. عودة للموت (مؤقت 4 ثواني)
local backB = createRow("عودة للموت", 280)
local backActive = false
local lastPos = nil
backB.MouseButton1Click:Connect(function()
    backActive = not backActive
    backB.Text = backActive and "✓" or ""
    backB.BackgroundColor3 = backActive and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)
end)
RunService.Heartbeat:Connect(function()
    if backActive and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        if Player.Character.Humanoid.Health > 0 then lastPos = Player.Character.HumanoidRootPart.CFrame end
    end
end)
Player.CharacterAdded:Connect(function(char)
    if backActive and lastPos then
        task.wait(4)
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if hrp then hrp.CFrame = lastPos end
    end
end)

-- 7. إنقاذ من الفراغ
local voidB = createRow("منع السقوط", 325)
local voidActive = false
voidB.MouseButton1Click:Connect(function()
    voidActive = not voidActive
    voidB.Text = voidActive and "✓" or ""
    voidB.BackgroundColor3 = voidActive and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)
end)
RunService.Heartbeat:Connect(function()
    if voidActive and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        if Player.Character.HumanoidRootPart.Position.Y < -50 then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                    break
                end
            end
        end
    end
end)

-- 8. حقل الانتقال للاعب
local tpTitle = Instance.new("TextLabel", Main)
tpTitle.Size = UDim2.new(1, 0, 0, 30); tpTitle.Position = UDim2.new(0, 0, 0, 370)
tpTitle.Text = "انتقال سريع:"; tpTitle.TextColor3 = Color3.new(1,1,1); tpTitle.BackgroundTransparency = 1; tpTitle.Font = Enum.Font.Gotham

local tpIn = Instance.new("TextBox", Main)
tpIn.Size = UDim2.new(0.9, 0, 0, 30); tpIn.Position = UDim2.new(0.05, 0, 0, 400)
tpIn.PlaceholderText = "اسم اللاعب..."
tpIn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); tpIn.TextColor3 = Color3.new(1,1,1)

local tpDo = Instance.new("TextButton", Main)
tpDo.Size = UDim2.new(0.9, 0, 0, 35); tpDo.Position = UDim2.new(0.05, 0, 0, 440)
tpDo.Text = "انطلق"; tpDo.BackgroundColor3 = Color3.fromRGB(170, 0, 0); tpDo.TextColor3 = Color3.new(1,1,1)
tpDo.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= Player and p.Name:lower():find(tpIn.Text:lower()) then
            Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
            break
        end
    end
end)
