-- [[ GlowBox Super V2 - Enhanced & Fixed ]] --
local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- 1. تنظيف النسخ القديمة
if PlayerGui:FindFirstChild("GlowBoxSuperV2") then PlayerGui.GlowBoxSuperV2:Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "GlowBoxSuperV2"
ScreenGui.ResetOnSpawn = false

-- 2. زر فتح/إغلاق القائمة (G)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -25)
OpenBtn.Text = "G"; OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
OpenBtn.TextColor3 = Color3.new(1,1,1); OpenBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

-- 3. اللوحة الرئيسية (Main Frame)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 350) 
Main.Position = UDim2.new(0.5, -150, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Visible = false
Instance.new("UICorner", Main)

-- عنوان القائمة
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "GlowBox Super - V2"; Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Instance.new("UICorner", Title)

-- إطار التمرير (لحل مشكلة خروج الأزرار من الشاشة)
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -10, 1, -45)
Scroll.Position = UDim2.new(0, 5, 0, 40)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 700) -- طول المحتوى الداخلي
Scroll.ScrollBarThickness = 4

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 5)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- دالة إنشاء العناصر داخل التمرير
local function createToggle(name, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0, 260, 0, 35)
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = name .. ": " .. (active and "ON" or "OFF")
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(45, 45, 45)
        callback(active)
    end)
    return btn
end

-- 4. المتغيرات والمنطق البرمجي (Logic)
local states = { fly = false, noclip = false, fling = false, antivoid = false, esp = false }
local lastPos = nil

-- [السرعة والقفز]
local speedVal, jumpVal = 16, 50
local sInput = Instance.new("TextBox", Scroll)
sInput.Size = UDim2.new(0, 260, 0, 30); sInput.PlaceholderText = "السرعة (16)"; sInput.Text = "16"
sInput.FocusLost:Connect(function() speedVal = tonumber(sInput.Text) or 16 end)

-- [الطيران Fly]
local function toggleFly(active)
    states.fly = active
    local bv, bg
    if active then
        bv = Instance.new("BodyVelocity", Player.Character.HumanoidRootPart)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0,0,0)
        task.spawn(function()
            while states.fly do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 50
                task.wait()
            end
            bv:Destroy()
        end)
    end
end

-- [قذف المشي WalkFling]
local function toggleFling(active)
    states.fling = active
    task.spawn(function()
        while states.fling do
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = Player.Character.HumanoidRootPart
                hrp.Velocity = Vector3.new(5000, 5000, 5000) -- قوة الدوران الوهمية
                RunService.Stepped:Wait()
                hrp.Velocity = Vector3.new(0,0,0)
            end
            task.wait(0.1)
        end
    end)
end

-- [Anti-Void]
task.spawn(function()
    while task.wait(1) do
        if states.antivoid and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            if Player.Character.HumanoidRootPart.Position.Y < -50 then
                -- العودة لأقرب لاعب
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= Player and p.Character then
                        Player.Character:MoveTo(p.Character.HumanoidRootPart.Position)
                        break
                    end
                end
            end
        end
    end
end)

-- 5. تفعيل الأزرار
createToggle("طيران (Fly)", toggleFly)
createToggle("اختراق الجدران (Noclip)", function(v) states.noclip = v end)
createToggle("قذف المشي (Fling)", toggleFling)
createToggle("إنقاذ من السقوط (Anti-Void)", function(v) states.antivoid = v end)
createToggle("كشف اللاعبين (ESP)", function(v) states.esp = v end)
createToggle("قفز لا نهائي", function(v) states.infJump = v end)

-- [تحديث الحلقة المستمرة]
RunService.Stepped:Connect(function()
    if Player.Character then
        local hum = Player.Character:FindFirstChildOfClass("Humanoid")
        if hum then 
            hum.WalkSpeed = speedVal
            if states.noclip then
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end
    
    -- نظام الـ ESP
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= Player and p.Character then
            local hl = p.Character:FindFirstChild("GlowESP")
            if states.esp then
                if not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "GlowESP"; hl.OutlineColor = Color3.new(1,0,0)
                end
            elseif hl then hl:Destroy() end
        end
    end
end)

-- [فتح وإغلاق القائمة]
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

print("GlowBox Super V2 Loaded!")
