-- [[ GlowHub V1.1 الخارق - النسخة المنظمة ]] --

local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local PlayerGui = Player:WaitForChild("PlayerGui")

-- تنظيف النسخ القديمة
if PlayerGui:FindFirstChild("GlowHub_Super_V1.1") then PlayerGui["GlowHub_Super_V1.1"]:Destroy() end

-- إنشاء الواجهة
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "GlowHub_Super_V1.1"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 250, 0, 600)
Main.Position = UDim2.new(0.5, -125, 0.5, -300)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
Title.Text = "1.1v الخارق"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Instance.new("UICorner", Title)

-- قائمة الأوامر (هنا تضيف السكربتات الجديدة مستقبلاً)
local Toggles = {} 
local Buttons = {}

-- دالة لإضافة زر تفعيل (Toggle) بسهولة
local function AddToggle(name, yPos, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = name .. ": مطفأ"
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = name .. (active and ": مفعل" or ": مطفأ")
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(45, 45, 45)
        callback(active)
    end)
end

-- ================= تسجيل الأوامر (سهلة النقل) =================

-- 1. السرعة
local speedState = false
AddToggle("السرعة", 50, function(state) speedState = state end)

-- 2. الطيران
local flyState = false
AddToggle("الطيران", 95, function(state) flyState = state end)

-- 3. اختراق الجدران
local noclipState = false
AddToggle("اختراق الجدران", 140, function(state) noclipState = state end)

-- 4. القذف (Fling)
local flingState = false
AddToggle("القذف الخارق", 185, function(state) flingState = state end)

-- 5. عودة للموت (4 ثواني)
local backState = false
local lastPos = nil
AddToggle("العودة للموت", 230, function(state) backState = state end)

-- 6. منع السقوط
local voidState = false
AddToggle("منع السقوط", 275, function(state) voidState = state end)

-- 7. كشف الأماكن (ESP)
local espState = false
AddToggle("كشف الأماكن", 320, function(state) espState = state end)

-- ================= قسم الانتقال (TP) =================
local tpIn = Instance.new("TextBox", Main)
tpIn.Size = UDim2.new(0.9, 0, 0, 35); tpIn.Position = UDim2.new(0.05, 0, 0, 370)
tpIn.PlaceholderText = "اسم اللاعب للاانتقال..."
tpIn.BackgroundColor3 = Color3.fromRGB(35, 35, 35); tpIn.TextColor3 = Color3.new(1, 1, 1)

local tpBtn = Instance.new("TextButton", Main)
tpBtn.Size = UDim2.new(0.9, 0, 0, 35); tpBtn.Position = UDim2.new(0.05, 0, 0, 415)
tpBtn.Text = "انتقل الآن"; tpBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0); tpBtn.TextColor3 = Color3.new(1,1,1)

tpBtn.MouseButton1Click:Connect(function()
    local target = tpIn.Text:lower()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Name:lower():find(target) then
            Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            break
        end
    end
end)

-- ================= حلقة التشغيل المركزية =================

RunService.Heartbeat:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = Player.Character.HumanoidRootPart
        local hum = Player.Character.Humanoid
        
        if speedState then hum.WalkSpeed = 100 else hum.WalkSpeed = 16 end
        
        if noclipState then
            for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
        
        if flingState then
            hrp.Velocity = Vector3.new(0, 10000, 0)
            RunService.RenderStepped:Wait()
            hrp.Velocity = Vector3.new(0, 0, 0)
            hrp.RotVelocity = Vector3.new(0, 10000, 0)
        end
        
        if backState and hum.Health > 0 then lastPos = hrp.CFrame end
        
        if voidState and hrp.Position.Y < -50 then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= Player and p.Character then
                    hrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                    break
                end
            end
        end
    end
end)

-- نظام العودة للموت
Player.CharacterAdded:Connect(function(char)
    if backState and lastPos then
        task.wait(4)
        local root = char:WaitForChild("HumanoidRootPart", 10)
        if root then root.CFrame = lastPos end
    end
end)
