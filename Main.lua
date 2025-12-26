local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

if PlayerGui:FindFirstChild("GlowHubV3") then PlayerGui.GlowHubV3:Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "GlowHubV3"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 250, 0, 420)
Main.Position = UDim2.new(0.5, -125, 0.5, -210) -- في منتصف الشاشة
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Active = true
Main.Draggable = true

-- وظيفة الإخفاء تحت الشاشة (مثل Infinite Yield)
local isHidden = false
local originalPos = Main.Position
local hiddenPos = UDim2.new(Main.Position.X.Scale, Main.Position.X.Offset, 1, 10)

local function toggleGui(show)
    local targetPos = show and originalPos or hiddenPos
    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = targetPos}):Play()
    isHidden = not show
end

-- إخفاء عند الضغط في مكان فارغ
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local pos = input.Position
        if pos.X < Main.AbsolutePosition.X or pos.X > (Main.AbsolutePosition.X + Main.AbsoluteSize.X) or
           pos.Y < Main.AbsolutePosition.Y or pos.Y > (Main.AbsolutePosition.Y + Main.AbsoluteSize.Y) then
            toggleGui(false)
        end
    end
end)

-- إضافة زر صغير لإعادة إظهارها (اختياري)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 20)
OpenBtn.Position = UDim2.new(0.5, -25, 1, -20)
OpenBtn.Text = "OPEN"
OpenBtn.MouseButton1Click:Connect(function() toggleGui(true) end)

local function createRow(name, pos, type)
    local label = Instance.new("TextLabel", Main)
    label.Size = UDim2.new(0, 100, 0, 30)
    label.Position = UDim2.new(0.05, 0, pos, 0)
    label.Text = name
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    if type == "Value" then
        local minus = Instance.new("TextButton", Main)
        minus.Size = UDim2.new(0, 30, 0, 30)
        minus.Position = UDim2.new(0.45, 0, pos, 0)
        minus.Text = "-"
        local input = Instance.new("TextBox", Main)
        input.Size = UDim2.new(0, 60, 0, 30)
        input.Position = UDim2.new(0.6, 0, pos, 0)
        input.Text = "16"
        local plus = Instance.new("TextButton", Main)
        plus.Size = UDim2.new(0, 30, 0, 30)
        plus.Position = UDim2.new(0.85, 0, pos, 0)
        plus.Text = "+"
        return minus, input, plus
    elseif type == "Toggle" then
        local btn = Instance.new("TextButton", Main)
        btn.Size = UDim2.new(0, 30, 0, 30)
        btn.Position = UDim2.new(0.8, 0, pos, 0)
        btn.Text = ""
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        return btn
    end
end

-- 1. السرعة المستمرة (Loop)
local sM, sIn, sP = createRow("السرعة", 0.05, "Value")
sM.MouseButton1Click:Connect(function() sIn.Text = tostring(tonumber(sIn.Text)-1) end)
sP.MouseButton1Click:Connect(function() sIn.Text = tostring(tonumber(sIn.Text)+1) end)
RunService.RenderStepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = tonumber(sIn.Text) or 16
    end
end)

-- 2. القفز المستمر (Loop)
local jM, jIn, jP = createRow("القفز", 0.15, "Value")
jIn.Text = "50"
jM.MouseButton1Click:Connect(function() jIn.Text = tostring(tonumber(jIn.Text)-1) end)
jP.MouseButton1Click:Connect(function() jIn.Text = tostring(tonumber(jIn.Text)+1) end)
RunService.RenderStepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.JumpPower = tonumber(jIn.Text) or 50
    end
end)

-- 3. قفز لا نهائي
local infJ = createRow("قفز لا نهائي", 0.25, "Toggle")
local infJumpActive = false
infJ.MouseButton1Click:Connect(function() infJumpActive = not infJumpActive infJ.Text = infJumpActive and "✓" or "" end)
UserInputService.JumpRequest:Connect(function() if infJumpActive then Player.Character.Humanoid:ChangeState("Jumping") end end)

-- 4. إظهار (ESP)
local espB = createRow("إظهار", 0.35, "Toggle")
espB.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ic3w0lf22/UnnamedESP/master/Source.lua"))() end)

-- 5. قذف (Fling)
local flB = createRow("قذف", 0.45, "Toggle")
flB.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/0866/Fling/main/Fling.lua"))() end)

-- 6. اختراق الجدران (Noclip)
local ncB = createRow("اختراق", 0.55, "Toggle")
local ncActive = false
ncB.MouseButton1Click:Connect(function() ncActive = not ncActive ncB.Text = ncActive and "✓" or "" end)
RunService.Stepped:Connect(function()
    if ncActive and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

-- 7. انتقال (Teleport)
local tpBtn = Instance.new("TextButton", Main)
tpBtn.Size = UDim2.new(0, 60, 0, 30)
tpBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
tpBtn.Text = "انتقال"
local tpIn = Instance.new("TextBox", Main)
tpIn.Size = UDim2.new(0, 120, 0, 30)
tpIn.Position = UDim2.new(0.35, 0, 0.65, 0)
tpIn.PlaceholderText = "اسم الشخص"
tpBtn.MouseButton1Click:Connect(function()
    local target = nil
    if tpIn.Text == "" then local p=game.Players:GetPlayers() target=p[math.random(1,#p)]
    else for _,p in pairs(game.Players:GetPlayers()) do if p.Name:lower():find(tpIn.Text:lower()) then target=p break end end end
    if target and target.Character then Player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame end
end)

-- 8. طيران (Fly)
local flyB = createRow("طيران", 0.8, "Toggle")
flyB.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.lua"))() end)
