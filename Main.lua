local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- تنظيف النسخ القديمة
if PlayerGui:FindFirstChild("GlowHub_Super_V1.1") then PlayerGui:FindFirstChild("GlowHub_Super_V1.1"):Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "GlowHub_Super_V1.1"
ScreenGui.ResetOnSpawn = false

-- اللوحة الرئيسية (نحيفة وطولية)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 170, 0, 500) 
Main.Position = UDim2.new(0, 10, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
Title.Text = "1.1v الخارق"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Instance.new("UICorner", Title)

-- دالة إنشاء الأزرار
local function createButton(name, yPos)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    Instance.new("UICorner", btn)
    return btn
end

-- الأزرار
local speedBtn = createButton("سرعة: مطفأ", 50)
local noclipBtn = createButton("اختراق: مطفأ", 90)
local flingBtn = createButton("فلينج: مطفأ", 130)
local backBtn = createButton("عودة للموت: مطفأ", 170)
local voidBtn = createButton("منع السقوط: مطفأ", 210)

-- حقل الانتقال (Teleport Section)
local tpIn = Instance.new("TextBox", Main)
tpIn.Size = UDim2.new(0.9, 0, 0, 30)
tpIn.Position = UDim2.new(0.05, 0, 0, 260)
tpIn.PlaceholderText = "اسم اللاعب..."
tpIn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tpIn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", tpIn)

local tpDo = createButton("انتقال الآن", 300)
tpDo.BackgroundColor3 = Color3.fromRGB(0, 100, 200)

-- المتغيرات
local speedOn, noclipOn, flingOn, autoBackOn, antiVoidOn = false, false, false, false, false
local lastPos = nil

-- تشغيل الأزرار
speedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    speedBtn.Text = speedOn and "سرعة: مفعل" or "سرعة: مطفأ"
    speedBtn.BackgroundColor3 = speedOn and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclipOn = not noclipOn
    noclipBtn.Text = noclipOn and "اختراق: مفعل" or "اختراق: مطفأ"
    noclipBtn.BackgroundColor3 = noclipOn and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
end)

flingBtn.MouseButton1Click:Connect(function()
    flingOn = not flingOn
    flingBtn.Text = flingOn and "فلينج: مفعل" or "فلينج: مطفأ"
    flingBtn.BackgroundColor3 = flingOn and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(40, 40, 40)
end)

backBtn.MouseButton1Click:Connect(function()
    autoBackOn = not autoBackOn
    backBtn.Text = autoBackOn and "عودة للموت: مفعل" or "عودة للموت: مطفأ"
    backBtn.BackgroundColor3 = autoBackOn and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
end)

voidBtn.MouseButton1Click:Connect(function()
    antiVoidOn = not antiVoidOn
    voidBtn.Text = antiVoidOn and "منع السقوط: مفعل" or "منع السقوط: مطفأ"
    voidBtn.BackgroundColor3 = antiVoidOn and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
end)

-- برمجة زر الانتقال
tpDo.MouseButton1Click:Connect(function()
    local targetName = tpIn.Text:lower()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= Player and p.Name:lower():find(targetName) then
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            end
            break
        end
    end
end)

-- الحلقة الأساسية
RunService.Stepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = Player.Character.HumanoidRootPart
        
        if speedOn then Player.Character.Humanoid.WalkSpeed = 100 end
        
        if noclipOn then
            for _, v in pairs(Player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
        
        if flingOn then
            hrp.Velocity = Vector3.new(0, 5000, 0)
            RunService.RenderStepped:Wait()
            hrp.Velocity = Vector3.new(0, 0, 0)
            hrp.RotVelocity = Vector3.new(0, 10000, 0)
        end
        
        if autoBackOn and Player.Character.Humanoid.Health > 0 then
            lastPos = hrp.CFrame
        end
        
        if antiVoidOn and hrp.Position.Y < -50 then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    hrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                    hrp.Velocity = Vector3.new(0,0,0)
                    break
                end
            end
        end
    end
end)

-- العودة للموت بعد 4 ثواني
Player.CharacterAdded:Connect(function(char)
    if autoBackOn and lastPos then
        task.wait(4)
        local root = char:WaitForChild("HumanoidRootPart", 10)
        if root then root.CFrame = lastPos end
    end
end)
