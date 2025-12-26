-- GlowHub V4.2 FINAL FIX
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- // حذف النسخ القديمة لضمان عدم التعليق //
if game.CoreGui:FindFirstChild("GlowHubV4_Fixed") then game.CoreGui.GlowHubV4_Fixed:Destroy() end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "GlowHubV4_Fixed"

-- [ الواجهة - تم تصغيرها وجعلها أكثر استقراراً ]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 230, 0, 380)
Main.Position = UDim2.new(0.5, -115, 1.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", Main)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Instance.new("UICorner", TopBar)

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "GLOWBOX ULTIMATE FIX"; Title.Size = UDim2.new(1,0,1,0); Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundTransparency = 1; Title.Font = "GothamBold"

-- [ زر G المتحرك ]
local GBtn = Instance.new("TextButton", ScreenGui)
GBtn.Size = UDim2.new(0, 45, 0, 45); GBtn.Position = UDim2.new(0, 20, 0.5, 0); GBtn.Text = "G"
GBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215); GBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", GBtn).CornerRadius = UDim.new(1,0)
GBtn.Draggable = true

-- [ نظام الفتح والإغلاق الذكي ]
local isOpen = false
local function toggle()
    isOpen = not isOpen
    Main:TweenPosition(isOpen and UDim2.new(0.5, -115, 0.5, -190) or UDim2.new(0.5, -115, 1.2, 0), "Out", "Quart", 0.4, true)
end
GBtn.MouseButton1Click:Connect(toggle)

-- [ نظام الأوامر المصلح ]
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, 0, 1, -40); Scroll.Position = UDim2.new(0,0,0,40); Scroll.BackgroundTransparency = 1; Scroll.CanvasSize = UDim2.new(0,0,0,700)

local function createBtn(txt, callback)
    local b = Instance.new("TextButton", Scroll)
    b.Size = UDim2.new(0.9, 0, 0, 35); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.TextColor3 = Color3.new(1,1,1); b.Font = "Gotham"
    local c = Instance.new("UICorner", b)
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        b.BackgroundColor3 = active and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40,40,40)
        callback(active)
    end)
    return b
end

-- 1. إصلاح السرعة والقفز (الطريقة المباشرة)
local speed = 16
createBtn("تفعيل السرعة القوية", function(state)
    _G.Speed = state
    while _G.Speed do task.wait()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = speed
        end
    end
end)

-- 2. إصلاح الطيران (استخدام LinearVelocity - الأحدث في 2025)
createBtn("طيران مصلح (V-Fly)", function(state)
    _G.Fly = state
    local char = LocalPlayer.Character
    if state and char then
        local root = char:FindFirstChild("HumanoidRootPart")
        local vel = Instance.new("LinearVelocity", root)
        local att = Instance.new("Attachment", root)
        vel.Attachment0 = att
        vel.MaxForce = math.huge
        task.spawn(function()
            while _G.Fly do RunService.RenderStepped:Wait()
                vel.VectorVelocity = Camera.CFrame.LookVector * 100
                if not _G.Fly then break end
            end
            vel:Destroy(); att:Destroy()
        end)
    end
end)

-- 3. إصلاح فسخ وقت الأدوات (Fast Tools)
createBtn("فسخ وقت الأدوات", function(state)
    _G.FastWait = state
    RunService.Heartbeat:Connect(function()
        if _G.FastWait and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetChildren()) do
                if v:IsA("Tool") then v.ToolTip = "" -- كسر الحماية البسيطة
                    if v:FindFirstChild("Activated") then v:Activate() end
                end
            end
        end
    end)
end)

-- 4. إصلاح نسخ السكن (Visual Only)
local selectedPlr = ""
createBtn("نسخ شكل اللاعب المختار", function()
    local p = Players:FindFirstChild(selectedPlr)
    if p and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") then v:Destroy() end
        end
        for _, v in pairs(p.Character:GetChildren()) do
            if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") then
                v:Clone().Parent = LocalPlayer.Character
            end
        end
    end
end)

-- [ قائمة اللاعبين المحدثة ]
local PScroll = Instance.new("ScrollingFrame", Scroll)
PScroll.Size = UDim2.new(0.9,0,0,100); PScroll.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UIListLayout", PScroll)

local function refresh()
    for _, v in pairs(PScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local b = Instance.new("TextButton", PScroll)
            b.Size = UDim2.new(1,0,0,25); b.Text = p.Name
            b.MouseButton1Click:Connect(function() selectedPlr = p.Name; b.BackgroundColor3 = Color3.fromRGB(0,120,215) end)
        end
    end
end
refresh()
