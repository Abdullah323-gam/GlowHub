-- GlowHub V4.3 - Powered by Infinite Yield Logic
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- تأكد من حذف النسخة القديمة
if game.CoreGui:FindFirstChild("GlowHub_Final") then game.CoreGui.GlowHub_Final:Destroy() end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "GlowHub_Final"

-- [ الواجهة بنفس تصميم V4 المفضل لديك ]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 400)
Main.Position = UDim2.new(0.5, -120, 1.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Instance.new("UICorner", TopBar)

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "GLOWBOX V4 (IY ENGINE)"; Title.Size = UDim2.new(1,0,1,0); Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundTransparency = 1; Title.Font = "GothamBold"

-- زر G القابل للسحب
local GBtn = Instance.new("TextButton", ScreenGui)
GBtn.Size = UDim2.new(0, 45, 0, 45); GBtn.Position = UDim2.new(0, 20, 0.5, 0); GBtn.Text = "G"
GBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215); GBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", GBtn).CornerRadius = UDim.new(1,0)
GBtn.Draggable = true

local isOpen = false
GBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    Main:TweenPosition(isOpen and UDim2.new(0.5, -120, 0.5, -200) or UDim2.new(0.5, -120, 1.2, 0), "Out", "Quart", 0.4, true)
end)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, 0, 1, -40); Scroll.Position = UDim2.new(0,0,0,40); Scroll.BackgroundTransparency = 1; Scroll.CanvasSize = UDim2.new(0,0,0,900); Scroll.ScrollBarThickness = 2

-- [ استيراد مهارات الحركة من Infinite Yield ]
local function createToggle(name, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.9, 0, 0, 35); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); btn.TextColor3 = Color3.new(1,1,1); btn.Font = "Gotham"
    Instance.new("UICorner", btn)
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(30,30,30)
        callback(active)
    end)
    return btn
end

-- 1. الطيران الأصلي (IY Fly)
createToggle("طيران (IY Logic)", function(state)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    if state then
        _G.Flying = true
        local p = Instance.new("BodyVelocity", char.HumanoidRootPart)
        p.Name = "IYFlyVel"; p.MaxForce = Vector3.new(9e9, 9e9, 9e9); p.Velocity = Vector3.new(0, 0.1, 0)
        local bg = Instance.new("BodyGyro", char.HumanoidRootPart)
        bg.Name = "IYFlyGyro"; bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.CFrame = char.HumanoidRootPart.CFrame
        task.spawn(function()
            while _G.Flying do RunService.RenderStepped:Wait()
                p.Velocity = workspace.CurrentCamera.CFrame.LookVector * 100
                bg.CFrame = workspace.CurrentCamera.CFrame
            end
        end)
    else
        _G.Flying = false
        if char.HumanoidRootPart:FindFirstChild("IYFlyVel") then char.HumanoidRootPart.IYFlyVel:Destroy() end
        if char.HumanoidRootPart:FindFirstChild("IYFlyGyro") then char.HumanoidRootPart.IYFlyGyro:Destroy() end
    end
end)

-- 2. قذف المشي الأصلي (IY WalkFling)
createToggle("قذف المشي (Fling)", function(state)
    _G.Flinging = state
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if state and hrp then
        task.spawn(function()
            while _G.Flinging do
                RunService.Heartbeat:Wait()
                hrp.Velocity = Vector3.new(0, 1000000, 0) -- السر المشهور في IY للقذف
                RunService.RenderStepped:Wait()
                hrp.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    end
end)

-- 3. فسخ وقت الأدوات (IY FastTools)
createToggle("فسخ وقت الأدوات", function(state)
    _G.FastTools = state
    task.spawn(function()
        while _G.FastTools do
            task.wait()
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool.Enabled = true
                if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    tool:Activate()
                end
            end
        end
    end)
end)

-- 4. نسخ السكن (IY Charmorph)
local selectedPlr = ""
createToggle("نسخ سكن المختار", function()
    local target = Players:FindFirstChild(selectedPlr)
    if target and target.Character and LocalPlayer.Character then
        local char = LocalPlayer.Character
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("CharacterMesh") then v:Destroy() end
        end
        for _, v in pairs(target.Character:GetChildren()) do
            if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("CharacterMesh") then
                v:Clone().Parent = char
            end
        end
    end
end)

-- [ قائمة اللاعبين الأصلية لضمان عمل الانتقال ]
local PScroll = Instance.new("ScrollingFrame", Scroll)
PScroll.Size = UDim2.new(0.95,0,0,120); PScroll.BackgroundColor3 = Color3.fromRGB(25,25,25)
local UIList = Instance.new("UIListLayout", PScroll)

local function updateList()
    for _, v in pairs(PScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local b = Instance.new("TextButton", PScroll)
            b.Size = UDim2.new(1,0,0,25); b.Text = p.Name; b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.TextColor3 = Color3.new(1,1,1)
            b.MouseButton1Click:Connect(function()
                selectedPlr = p.Name
                for _, btn in pairs(PScroll:GetChildren()) do if btn:IsA("TextButton") then btn.BackgroundColor3 = Color3.fromRGB(40,40,40) end end
                b.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
            end)
        end
    end
end
updateList()
Players.PlayerAdded:Connect(updateList); Players.PlayerRemoving:Connect(updateList)

local tpBtn = Instance.new("TextButton", Scroll)
tpBtn.Size = UDim2.new(0.9,0,0,35); tpBtn.Text = "انتقال للاعب المختار"; tpBtn.BackgroundColor3 = Color3.fromRGB(0,120,215); tpBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", tpBtn)
tpBtn.MouseButton1Click:Connect(function()
    local t = Players:FindFirstChild(selectedPlr)
    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame
    end
end)
