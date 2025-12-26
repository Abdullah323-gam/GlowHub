local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera

if PlayerGui:FindFirstChild("GlowHubV8") then PlayerGui.GlowHubV8:Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "GlowHubV8"
ScreenGui.ResetOnSpawn = false

-- 1. زر الفتح (متحرك ولا يغطي القفز)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0.9, 0, 0.4, 0) 
OpenBtn.Text = "MENU"
OpenBtn.Draggable = true
OpenBtn.Active = true
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.Style = Enum.ButtonStyle.RobloxRoundDefaultButton

-- 2. اللوحة الرئيسية (مع شريط تمرير)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 320)
Main.Position = UDim2.new(0.5, -120, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Active = true
Main.Draggable = true
Main.Visible = false

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(0, 120, 215)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, 0, 1, -35)
Scroll.Position = UDim2.new(0, 0, 0, 35)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 500)
Scroll.ScrollBarThickness = 4

OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true OpenBtn.Visible = false end)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false OpenBtn.Visible = true end)

local function createRow(name, yPos, type)
    local f = Instance.new("Frame", Scroll)
    f.Size = UDim2.new(1, 0, 0, 45)
    f.Position = UDim2.new(0, 0, 0, yPos)
    f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.4, 0, 1, 0); l.Text = name; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1; l.TextXAlignment = "Left"

    if type == "Value" then
        local m = Instance.new("TextButton", f); m.Size = UDim2.new(0, 30, 0, 30); m.Position = UDim2.new(0.45, 0, 0.15, 0); m.Text = "-"
        local i = Instance.new("TextBox", f); i.Size = UDim2.new(0, 50, 0, 30); i.Position = UDim2.new(0.6, 0, 0.15, 0); i.Text = "16"
        local p = Instance.new("TextButton", f); p.Size = UDim2.new(0, 30, 0, 30); p.Position = UDim2.new(0.85, 0, 0.15, 0); p.Text = "+"
        return m, i, p
    elseif type == "Toggle" then
        local b = Instance.new("TextButton", f); b.Size = UDim2.new(0, 35, 0, 30); b.Position = UDim2.new(0.8, 0, 0.15, 0); b.Text = ""; b.BackgroundColor3 = Color3.fromRGB(60,60,60)
        return b
    end
end

-- === الأوامر المصلحة (نسخة V6 المدمجة) ===

-- 1. السرعة والقفز (Loop مستمر)
local sM, sIn, sP = createRow("السرعة", 10, "Value")
sM.MouseButton1Click:Connect(function() sIn.Text = tostring(tonumber(sIn.Text)-1) end)
sP.MouseButton1Click:Connect(function() sIn.Text = tostring(tonumber(sIn.Text)+1) end)
RunService.RenderStepped:Connect(function() if Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.WalkSpeed = tonumber(sIn.Text) or 16 end end)

local jM, jIn, jP = createRow("القفز", 60, "Value")
jIn.Text = "50"
jM.MouseButton1Click:Connect(function() jIn.Text = tostring(tonumber(jIn.Text)-5) end)
jP.MouseButton1Click:Connect(function() jIn.Text = tostring(tonumber(jIn.Text)+5) end)
RunService.RenderStepped:Connect(function() if Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.UseJumpPower = true Player.Character.Humanoid.JumpPower = tonumber(jIn.Text) or 50 end end)

-- 2. اختراق الجدران (يشتغل ويطفي 100%)
local ncB = createRow("اختراق", 110, "Toggle")
local ncActive = false
ncB.MouseButton1Click:Connect(function()
    ncActive = not ncActive
    ncB.Text = ncActive and "✓" or ""
    ncB.BackgroundColor3 = ncActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    if not ncActive and Player.Character then for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = true end end end
end)
RunService.Stepped:Connect(function() if ncActive and Player.Character then for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)

-- 3. إضاءة FB (يشتغل ويطفي 100%)
local fbB = createRow("إضاءة FB", 160, "Toggle")
local fbActive = false
fbB.MouseButton1Click:Connect(function()
    fbActive = not fbActive
    fbB.Text = fbActive and "✓" or ""
    fbB.BackgroundColor3 = fbActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    if not fbActive then Lighting.ClockTime = 14 Lighting.Brightness = 2 Lighting.GlobalShadows = true end
end)
RunService.RenderStepped:Connect(function() if fbActive then Lighting.ClockTime = 14 Lighting.Brightness = 3 Lighting.GlobalShadows = false end end)

-- 4. طيران (كود داخلي قابل للإيقاف)
local flyB = createRow("طيران", 210, "Toggle"); local flyActive = false
flyB.MouseButton1Click:Connect(function()
    flyActive = not flyActive; flyB.Text = flyActive and "✓" or ""; flyB.BackgroundColor3 = flyActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    local char = Player.Character; local root = char:FindFirstChild("HumanoidRootPart")
    if flyActive and root then
        local bg = Instance.new("BodyGyro", root); bg.P = 9e4; bg.maxTorque = Vector3.new(9e9, 9e9, 9e9); bg.cframe = root.CFrame
        local bv = Instance.new("BodyVelocity", root); bv.velocity = Vector3.new(0, 0.1, 0); bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            while flyActive do
                char.Humanoid.PlatformStand = true
                bv.velocity = Camera.CFrame.LookVector * char.Humanoid.MoveDirection.Z * 50 + Camera.CFrame.RightVector * char.Humanoid.MoveDirection.X * 50
                bg.cframe = Camera.CFrame; task.wait()
            end
            bg:Destroy(); bv:Destroy(); char.Humanoid.PlatformStand = false
        end)
    end
end)

-- 5. إظهار ESP (كود داخلي مضمون)
local espB = createRow("إظهار ESP", 260, "Toggle"); local espActive = false; local espFolder = Instance.new("Folder", game.CoreGui)
espB.MouseButton1Click:Connect(function()
    espActive = not espActive; espB.Text = espActive and "✓" or ""; espB.BackgroundColor3 = espActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    if not espActive then espFolder:ClearAllChildren() end
end)
RunService.RenderStepped:Connect(function()
    if espActive then
        espFolder:ClearAllChildren()
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= Player and p.Character then
                local h = Instance.new("Highlight", espFolder); h.Adornee = p.Character; h.FillColor = Color3.new(1,0,0)
            end
        end
    end
end)

-- 6. قدرات الفريقين (Team Switch)
local teamB = createRow("تبديل الفريق", 310, "Toggle")
teamB.MouseButton1Click:Connect(function()
    for _, t in pairs(game:GetService("Teams"):GetTeams()) do Player.Team = t task.wait(0.1) end
end)

-- 7. انتقال
local tpF = Instance.new("Frame", Scroll); tpF.Size = UDim2.new(1,0,0,45); tpF.Position = UDim2.new(0,0,0,360); tpF.BackgroundTransparency = 1
local tpIn = Instance.new("TextBox", tpF); tpIn.Size = UDim2.new(0,100,0,30); tpIn.Position = UDim2.new(0.05,0,0.15,0); tpIn.PlaceholderText = "الاسم"
local tpBtn = Instance.new("TextButton", tpF); tpBtn.Size = UDim2.new(0,80,0,30); tpBtn.Position = UDim2.new(0.55,0,0.15,0); tpBtn.Text = "انتقال"
tpBtn.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= Player and (tpIn.Text == "" or p.Name:lower():find(tpIn.Text:lower())) then
            Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame; break
        end
    end
end)
