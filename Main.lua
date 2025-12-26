local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera

-- تنظيف النسخ القديمة
if PlayerGui:FindFirstChild("GlowHub_V4_Super") then PlayerGui.GlowHub_V4_Super:Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "GlowHub_V4_Super"
ScreenGui.ResetOnSpawn = false

-- اللوحة الرئيسية (تصميم V4)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 500)
Main.Position = UDim2.new(0.5, -130, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true

local MainCorner = Instance.new("UICorner", Main)

-- العنوان
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Title.Text = "الخارق GLOWBOX V4"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Instance.new("UICorner", Title)

-- نظام الإخفاء (Tween)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 100, 0, 35)
OpenBtn.Position = UDim2.new(0.5, -50, 0, 10)
OpenBtn.Text = "فتح السكربت"
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Visible = false
Instance.new("UICorner", OpenBtn)

local function toggleGui(show)
    if show then
        Main.Visible = true
        OpenBtn.Visible = false
        Main:TweenPosition(UDim2.new(0.5, -130, 0.5, -250), "Out", "Quart", 0.5, true)
    else
        Main:TweenPosition(UDim2.new(0.5, -130, 1, 50), "In", "Quart", 0.5, true, function()
            Main.Visible = false
            OpenBtn.Visible = true
        end)
    end
end

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"; CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); CloseBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", CloseBtn)

OpenBtn.MouseButton1Click:Connect(function() toggleGui(true) end)
CloseBtn.MouseButton1Click:Connect(function() toggleGui(false) end)

-- قائمة التمرير للأوامر
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, 0, 1, -50)
Scroll.Position = UDim2.new(0, 0, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 1100) -- وسعنا المساحة لكل الأوامر
Scroll.ScrollBarThickness = 3

local function createRow(name, yPos, type)
    local label = Instance.new("TextLabel", Scroll)
    label.Size = UDim2.new(0, 120, 0, 30)
    label.Position = UDim2.new(0.05, 0, 0, yPos)
    label.Text = name; label.TextColor3 = Color3.new(1,1,1); label.BackgroundTransparency = 1; label.Font = Enum.Font.Gotham; label.TextXAlignment = "Left"
    
    if type == "Value" then
        local input = Instance.new("TextBox", Scroll)
        input.Size = UDim2.new(0, 50, 0, 25); input.Position = UDim2.new(0.6, 0, 0, yPos); input.Text = "16"
        input.BackgroundColor3 = Color3.fromRGB(40,40,40); input.TextColor3 = Color3.new(1,1,1)
        return input
    elseif type == "Toggle" then
        local btn = Instance.new("TextButton", Scroll)
        btn.Size = UDim2.new(0, 35, 0, 25); btn.Position = UDim2.new(0.8, 0, 0, yPos); btn.Text = ""
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60); Instance.new("UICorner", btn)
        return btn
    end
end

-- ================= إعداد الأوامر =================

local sIn = createRow("السرعة", 10, "Value")
local jIn = createRow("القفز", 45, "Value") jIn.Text = "50"
local infJ = createRow("قفز لا نهائي", 80, "Toggle")
local ncB = createRow("اختراق جدران", 115, "Toggle")
local flyB = createRow("الطيران", 150, "Toggle")
local voidB = createRow("منع السقوط", 185, "Toggle")
local flB = createRow("WalkFling (قذف)", 220, "Toggle")
local invB = createRow("اختفاء", 255, "Toggle")
local espB = createRow("ESP (كشف)", 290, "Toggle")
local nobB = createRow("ESP Nob (تحويل نوب)", 325, "Toggle")
local backB = createRow("عودة للموت", 360, "Toggle")
local toolB = createRow("بقاء الأدوات", 395, "Toggle")
local fastB = createRow("فسخ وقت الأدوات", 430, "Toggle")

-- نظام قائمة اللاعبين (Teleport)
local pLabel = Instance.new("TextLabel", Scroll)
pLabel.Size = UDim2.new(1, 0, 0, 30); pLabel.Position = UDim2.new(0, 0, 0, 470)
pLabel.Text = "--- قائمة اللاعبين ---"; pLabel.TextColor3 = Color3.fromRGB(0, 120, 215); pLabel.BackgroundTransparency = 1

local PList = Instance.new("ScrollingFrame", Scroll)
PList.Size = UDim2.new(0.9, 0, 0, 120); PList.Position = UDim2.new(0.05, 0, 0, 505)
PList.BackgroundColor3 = Color3.fromRGB(30, 30, 30); PList.CanvasSize = UDim2.new(0,0,0,0)
local listL = Instance.new("UIListLayout", PList)

local selPlr = ""
local function updateList()
    for _, v in pairs(PList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= Player then
            local b = Instance.new("TextButton", PList)
            b.Size = UDim2.new(1, 0, 0, 25); b.Text = p.Name; b.BackgroundColor3 = Color3.fromRGB(45,45,45); b.TextColor3 = Color3.new(1,1,1)
            b.MouseButton1Click:Connect(function()
                selPlr = p.Name
                for _, btn in pairs(PList:GetChildren()) do if btn:IsA("TextButton") then btn.BackgroundColor3 = Color3.fromRGB(45,45,45) end end
                b.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
            end)
        end
    end
end
game.Players.PlayerAdded:Connect(updateList); game.Players.PlayerRemoving:Connect(updateList); updateList()

local tpDo = Instance.new("TextButton", Scroll)
tpDo.Size = UDim2.new(0.9, 0, 0, 35); tpDo.Position = UDim2.new(0.05, 0, 0, 635)
tpDo.Text = "انتقال للاعب المختار"; tpDo.BackgroundColor3 = Color3.fromRGB(0, 120, 215); tpDo.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", tpDo)
tpDo.MouseButton1Click:Connect(function()
    if selPlr ~= "" and game.Players:FindFirstChild(selPlr) then
        Player.Character.HumanoidRootPart.CFrame = game.Players[selPlr].Character.HumanoidRootPart.CFrame * CFrame.new(0,3,0)
    end
end)

-- ================= تشغيل المهارات =================

local toggles = {infJ=false, nc=false, fly=false, void=false, fling=false, inv=false, esp=false, nob=false, back=false, tool=false, fast=false}

local function setupToggle(btn, key)
    btn.MouseButton1Click:Connect(function()
        toggles[key] = not toggles[key]
        btn.Text = toggles[key] and "✓" or ""
        btn.BackgroundColor3 = toggles[key] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    end)
end

setupToggle(infJ, "infJ"); setupToggle(ncB, "nc"); setupToggle(flyB, "fly"); setupToggle(voidB, "void")
setupToggle(flB, "fling"); setupToggle(invB, "inv"); setupToggle(espB, "esp"); setupToggle(nobB, "nob")
setupToggle(backB, "back"); setupToggle(toolB, "tool"); setupToggle(fastB, "fast")

local lastPos = nil
RunService.Heartbeat:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = Player.Character.HumanoidRootPart
        local hum = Player.Character.Humanoid
        
        hum.WalkSpeed = tonumber(sIn.Text) or 16
        hum.JumpPower = tonumber(jIn.Text) or 50
        
        if toggles.nc then for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        if toggles.fling then hrp.Velocity = Vector3.new(0,5000,0); RunService.RenderStepped:Wait(); hrp.Velocity = Vector3.new(0,0,0); hrp.RotVelocity = Vector3.new(0,10000,0) end
        if toggles.back and hum.Health > 0 then lastPos = hrp.CFrame end
        if toggles.void and hrp.Position.Y < -50 then
            for _, p in pairs(game.Players:GetPlayers()) do if p ~= Player and p.Character then hrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,5,0); break end end
        end
        if toggles.fast then
            for _, v in pairs(Player.Character:GetChildren()) do if v:IsA("Tool") then v.Activated:Connect(function() task.wait() v:Activate() end) end end
        end
    end
end)

-- ميزة بقاء الأدوات (Tool Keeper)
Player.CharacterRemoving:Connect(function()
    if toggles.tool then
        for _, v in pairs(Player.Backpack:GetChildren()) do v.Parent = Player:WaitForChild("StarterGui") end
    end
end)

-- ميزة ESP Nob
RunService.RenderStepped:Connect(function()
    if toggles.nob then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= Player and p.Character then
                for _, part in pairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") then part.Color = Color3.new(1,1,0) end -- لون أصفر نوب
                    if part.Name == "Torso" or part.Name == "UpperTorso" then part.Color = Color3.new(0,0,1) end -- أزرق
                end
            end
        end
    end
end)

-- عودة للموت
Player.CharacterAdded:Connect(function(char)
    if toggles.back and lastPos then
        task.wait(4)
        char:WaitForChild("HumanoidRootPart").CFrame = lastPos
    end
end)

-- قفز لا نهائي
UserInputService.JumpRequest:Connect(function()
    if toggles.infJ and Player.Character then Player.Character.Humanoid:ChangeState("Jumping") end
end)
