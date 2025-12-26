local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- تنظيف النسخ القديمة
if PlayerGui:FindFirstChild("GlowBox_Ultimate_V4") then PlayerGui.GlowBox_Ultimate_V4:Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "GlowBox_Ultimate_V4"
ScreenGui.ResetOnSpawn = false

-- 1. زر الفتح (G) - قابل للسحب ودائري
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 20, 0.5, 0)
OpenBtn.Text = "G"; OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
OpenBtn.TextColor3 = Color3.new(1,1,1); OpenBtn.Font = Enum.Font.GothamBold; OpenBtn.TextSize = 20
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
OpenBtn.Draggable = true 

-- 2. اللوحة الرئيسية
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 400) 
Main.Position = UDim2.new(0.5, -120, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0; Main.Active = true; Main.Draggable = true; Main.Visible = false
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35); Title.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Title.Text = "GLOWBOX V4.1 FULL"; Title.TextColor3 = Color3.new(1, 1, 1); Title.Font = Enum.Font.GothamBold
Instance.new("UICorner", Title)

-- نظام الإخفاء التلقائي
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and Main.Visible then
        local pos = UserInputService:GetMouseLocation()
        local gp = Main.AbsolutePosition
        local gs = Main.AbsoluteSize
        if pos.X < gp.X or pos.X > gp.X + gs.X or pos.Y < gp.Y or pos.Y > gp.Y + gs.Y then
            Main:TweenPosition(UDim2.new(0.5, -120, 1, 50), "In", "Quart", 0.4, true, function() 
                Main.Visible = false; OpenBtn.Visible = true 
            end)
        end
    end
end)

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true; OpenBtn.Visible = false
    Main:TweenPosition(UDim2.new(0.5, -120, 0.5, -200), "Out", "Quart", 0.4, true)
end)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, 0, 1, -40); Scroll.Position = UDim2.new(0, 0, 0, 40)
Scroll.BackgroundTransparency = 1; Scroll.CanvasSize = UDim2.new(0, 0, 0, 1100); Scroll.ScrollBarThickness = 2

local function createRow(name, yPos, type)
    local label = Instance.new("TextLabel", Scroll)
    label.Size = UDim2.new(0, 100, 0, 30); label.Position = UDim2.new(0.05, 0, 0, yPos)
    label.Text = name; label.TextColor3 = Color3.new(1,1,1); label.BackgroundTransparency = 1; label.Font = Enum.Font.Gotham; label.TextXAlignment = "Left"
    
    if type == "Value" then
        local m = Instance.new("TextButton", Scroll); m.Size = UDim2.new(0, 25, 0, 25); m.Position = UDim2.new(0.45, 0, 0, yPos); m.Text = "-"; m.BackgroundColor3 = Color3.fromRGB(50,50,50); m.TextColor3 = Color3.new(1,1,1)
        local i = Instance.new("TextBox", Scroll); i.Size = UDim2.new(0, 40, 0, 25); i.Position = UDim2.new(0.58, 0, 0, yPos); i.Text = "16"; i.BackgroundColor3 = Color3.fromRGB(35,35,35); i.TextColor3 = Color3.new(1,1,1)
        local p = Instance.new("TextButton", Scroll); p.Size = UDim2.new(0, 25, 0, 25); p.Position = UDim2.new(0.8, 0, 0, yPos); p.Text = "+"; p.BackgroundColor3 = Color3.fromRGB(50,50,50); p.TextColor3 = Color3.new(1,1,1)
        return m, i, p
    elseif type == "Toggle" then
        local b = Instance.new("TextButton", Scroll); b.Size = UDim2.new(0, 35, 0, 25); b.Position = UDim2.new(0.8, 0, 0, yPos); b.Text = ""; b.BackgroundColor3 = Color3.fromRGB(60,60,60); Instance.new("UICorner", b)
        return b
    end
end

-- الإضافات الجديدة والقدرات المضافة
local sM, sIn, sP = createRow("السرعة", 10, "Value")
local jM, jIn, jP = createRow("القفز", 45, "Value")
local flyB = createRow("طيران", 80, "Toggle")
local infJB = createRow("قفز لا نهائي", 115, "Toggle")
local ncB = createRow("اختراق جدران", 150, "Toggle")
local flB = createRow("WalkFling (قذف)", 185, "Toggle")
local voidB = createRow("Anti-Void (إنقاذ)", 220, "Toggle")
local espB = createRow("كشف الأماكن (ESP)", 255, "Toggle")
local toolB = createRow("بقاء الأدوات", 290, "Toggle")
local fastB = createRow("فسخ الوقت", 325, "Toggle")
local backB = createRow("عودة للموت", 360, "Toggle")
local copyB = createRow("نسخ سكن اللاعب", 395, "Toggle")

-- [ البرمجة - Logic ]

-- طيران (IY)
flyB.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.lua"))()
end)

-- قفز لا نهائي
local infJump = false
infJB.MouseButton1Click:Connect(function()
    infJump = not infJump
    infJB.Text = infJump and "✓" or ""
end)
UserInputService.JumpRequest:Connect(function()
    if infJump then Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)

-- اختراق جدران (Noclip)
local noclip = false
ncB.MouseButton1Click:Connect(function()
    noclip = not noclip
    ncB.Text = noclip and "✓" or ""
end)
RunService.Stepped:Connect(function()
    if noclip and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- WalkFling
local fling = false
flB.MouseButton1Click:Connect(function()
    fling = not fling
    flB.Text = fling and "✓" or ""
end)
RunService.Heartbeat:Connect(function()
    if fling and Player.Character then
        local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(0, 1000000, 0)
            RunService.RenderStepped:Wait()
            hrp.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- بقية الأوامر (نسخ السكن، عودة للموت، قائمة اللاعبين) بنفس المنطق الأصلي في V4.1 ...
-- [تم دمج قائمة اللاعبين والانتقال في الأسفل]

local PList = Instance.new("ScrollingFrame", Scroll)
PList.Size = UDim2.new(0.9, 0, 0, 100); PList.Position = UDim2.new(0.05, 0, 0, 450)
PList.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Instance.new("UIListLayout", PList)

local selectedPlr = ""
local function updateList()
    for _, v in pairs(PList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= Player then
            local b = Instance.new("TextButton", PList); b.Size = UDim2.new(1, 0, 0, 25); b.Text = p.Name; b.BackgroundColor3 = Color3.fromRGB(45,45,45); b.TextColor3 = Color3.new(1,1,1)
            b.MouseButton1Click:Connect(function()
                selectedPlr = p.Name
                for _, btn in pairs(PList:GetChildren()) do if btn:IsA("TextButton") then btn.BackgroundColor3 = Color3.fromRGB(45,45,45) end end
                b.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
            end)
        end
    end
end
updateList()

local tpDo = Instance.new("TextButton", Scroll)
tpDo.Size = UDim2.new(0.9, 0, 0, 35); tpDo.Position = UDim2.new(0.05, 0, 0, 560); tpDo.Text = "انتقال للاعب المختار"; tpDo.BackgroundColor3 = Color3.fromRGB(0, 120, 215); tpDo.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", tpDo)
tpDo.MouseButton1Click:Connect(function()
    if selectedPlr ~= "" and game.Players:FindFirstChild(selectedPlr) then
        Player.Character.HumanoidRootPart.CFrame = game.Players[selectedPlr].Character.HumanoidRootPart.CFrame
    end
end)

-- التحكم في القيم
sM.MouseButton1Click:Connect(function() sIn.Text = tostring(tonumber(sIn.Text)-5) end)
sP.MouseButton1Click:Connect(function() sIn.Text = tostring(tonumber(sIn.Text)+5) end)
jM.MouseButton1Click:Connect(function() jIn.Text = tostring(tonumber(jIn.Text)-5) end)
jP.MouseButton1Click:Connect(function() jIn.Text = tostring(tonumber(jIn.Text)+5) end)

RunService.RenderStepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = tonumber(sIn.Text) or 16
        Player.Character.Humanoid.JumpPower = tonumber(jIn.Text) or 50
    end
end)
