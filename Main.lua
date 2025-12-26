-- GlowHub V4.4 - إصلاح الترتيب والظهور الكامل
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- تنظيف النسخ القديمة
if game.CoreGui:FindFirstChild("GlowHub_V4_Final") then game.CoreGui.GlowHub_V4_Final:Destroy() end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "GlowHub_V4_Final"

-- [ اللوحة الرئيسية - تصميم V4 ]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 400)
Main.Position = UDim2.new(0.5, -120, 1.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Instance.new("UICorner", TopBar)

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "GLOWBOX V4.4 (Full Fix)"; Title.Size = UDim2.new(1,0,1,0); Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundTransparency = 1; Title.Font = "GothamBold"

-- منطقة التمرير (هنا نضع كل شيء لضمان ظهوره)
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, 0, 1, -40); Scroll.Position = UDim2.new(0,0,0,40); Scroll.BackgroundTransparency = 1; Scroll.CanvasSize = UDim2.new(0,0,0,1000); Scroll.ScrollBarThickness = 3

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 5); UIList.HorizontalAlignment = "Center"

-- [ زر G الصغير ]
local GBtn = Instance.new("TextButton", ScreenGui)
GBtn.Size = UDim2.new(0, 45, 0, 45); GBtn.Position = UDim2.new(0, 20, 0.5, 0); GBtn.Text = "G"
GBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215); GBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", GBtn).CornerRadius = UDim.new(1,0)
GBtn.Draggable = true

local isOpen = false
GBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    Main:TweenPosition(isOpen and UDim2.new(0.5, -120, 0.5, -200) or UDim2.new(0.5, -120, 1.2, 0), "Out", "Quart", 0.4, true)
end)

-- دالة إنشاء الأزرار
local function makeToggle(name, callback)
    local b = Instance.new("TextButton", Scroll)
    b.Size = UDim2.new(0.9, 0, 0, 35); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(35,35,35); b.TextColor3 = Color3.new(1,1,1); b.Font = "Gotham"
    Instance.new("UICorner", b)
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        b.BackgroundColor3 = active and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(35,35,35)
        callback(active)
    end)
end

-- // المهارات المدمجة برمجياً //

makeToggle("طيران (IY Engine)", function(state)
    _G.Fly = state
    local char = LocalPlayer.Character
    if state and char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local bv = Instance.new("BodyVelocity", hrp); bv.MaxForce = Vector3.new(9e9,9e9,9e9); bv.Velocity = Vector3.new(0,0.1,0)
        local bg = Instance.new("BodyGyro", hrp); bg.MaxTorque = Vector3.new(9e9,9e9,9e9); bg.CFrame = hrp.CFrame
        task.spawn(function()
            while _G.Fly do RunService.RenderStepped:Wait()
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 100
                bg.CFrame = workspace.CurrentCamera.CFrame
            end
            bv:Destroy(); bg:Destroy()
        end)
    end
end)

makeToggle("قذف المشي (Fling)", function(state)
    _G.Fling = state
    while _G.Fling do RunService.Heartbeat:Wait()
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 1000000, 0)
        RunService.RenderStepped:Wait()
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    end
end)

makeToggle("فسخ وقت الأدوات", function(state)
    _G.Fast = state
    while _G.Fast do task.wait()
        local t = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if t then t.Enabled = true; if UserInputService:IsMouseButtonPressed(0) then t:Activate() end end
    end
end)

-- [ نظام اللاعبين المصلح ]
local selectedPlr = ""
local PScroll = Instance.new("ScrollingFrame", Scroll)
PScroll.Size = UDim2.new(0.9,0,0,100); PScroll.BackgroundColor3 = Color3.fromRGB(25,25,25); Instance.new("UIListLayout", PScroll)

local function updateList()
    for _,v in pairs(PScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _,p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then
        local b = Instance.new("TextButton", PScroll); b.Size = UDim2.new(1,0,0,25); b.Text = p.Name
        b.MouseButton1Click:Connect(function() selectedPlr = p.Name; b.BackgroundColor3 = Color3.fromRGB(0,120,215) end)
    end end
end
updateList(); Players.PlayerAdded:Connect(updateList)

local tpBtn = Instance.new("TextButton", Scroll)
tpBtn.Size = UDim2.new(0.9,0,0,35); tpBtn.Text = "انتقال للاعب المختار"; tpBtn.BackgroundColor3 = Color3.fromRGB(0,120,215)
tpBtn.MouseButton1Click:Connect(function()
    local t = Players:FindFirstChild(selectedPlr)
    if t then LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame end
end)
