local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("AbdullahUltimate") then PlayerGui.AbdullahUltimate:Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "AbdullahUltimate"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 250, 0, 420)
Main.Position = UDim2.new(0.1, 0, 0.1, 0)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Active = true
Main.Draggable = true

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

-- 1. السرعة
local sMinus, sInput, sPlus = createRow("السرعة", 0.1, "Value")
sInput.Text = "16"
sMinus.MouseButton1Click:Connect(function() sInput.Text = tostring(tonumber(sInput.Text)-1) Player.Character.Humanoid.WalkSpeed = tonumber(sInput.Text) end)
sPlus.MouseButton1Click:Connect(function() sInput.Text = tostring(tonumber(sInput.Text)+1) Player.Character.Humanoid.WalkSpeed = tonumber(sInput.Text) end)

-- 2. القفز
local jMinus, jInput, jPlus = createRow("القفز", 0.2, "Value")
jInput.Text = "50"
jMinus.MouseButton1Click:Connect(function() jInput.Text = tostring(tonumber(jInput.Text)-1) Player.Character.Humanoid.JumpPower = tonumber(jInput.Text) end)
jPlus.MouseButton1Click:Connect(function() jInput.Text = tostring(tonumber(jInput.Text)+1) Player.Character.Humanoid.JumpPower = tonumber(jInput.Text) end)

-- 3. قفز لا نهائي
local infJumpBtn = createRow("قفز لا نهائي", 0.3, "Toggle")
local infJump = false
infJumpBtn.MouseButton1Click:Connect(function()
    infJump = not infJump
    infJumpBtn.Text = infJump and "✓" or ""
end)
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump then Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)

-- 4. إظهار (ESP خطوط على السكن)
local espBtn = createRow("إظهار", 0.4, "Toggle")
espBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ic3w0lf22/UnnamedESP/master/Source.lua"))()
end)

-- 5. قذف (Fling)
local flingBtn = createRow("قذف", 0.5, "Toggle")
flingBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/0866/Fling/main/Fling.lua"))()
end)

-- 6. اختراق الجدران
local noclipBtn = createRow("اختراق", 0.6, "Toggle")
local noclip = false
noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = noclip and "✓" or ""
end)
game:GetService("RunService").Stepped:Connect(function()
    if noclip and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- 7. انتقال
local tpBtn = Instance.new("TextButton", Main)
tpBtn.Size = UDim2.new(0, 60, 0, 30)
tpBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
tpBtn.Text = "انتقال"

local tpInput = Instance.new("TextBox", Main)
tpInput.Size = UDim2.new(0, 120, 0, 30)
tpInput.Position = UDim2.new(0.35, 0, 0.7, 0)
tpInput.PlaceholderText = "اسم الشخص"

tpBtn.MouseButton1Click:Connect(function()
    local targetName = tpInput.Text
    local target = nil
    if targetName == "" then
        local players = game.Players:GetPlayers()
        target = players[math.random(1, #players)]
    else
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Name:lower():sub(1, #targetName) == targetName:lower() then target = p break end
        end
    end
    if target and target.Character then Player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame end
end)

-- 8. طيران
local flyBtn = createRow("طيران", 0.8, "Toggle")
flyBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.lua"))()
end)
