local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

if PlayerGui:FindFirstChild("GlowHubV7") then PlayerGui.GlowHubV7:Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "GlowHubV7"
ScreenGui.ResetOnSpawn = false

-- زر الفتح المتحرك
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0.9, 0, 0.4, 0) 
OpenBtn.Text = "MENU"
OpenBtn.Draggable = true
OpenBtn.Active = true
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.Style = Enum.ButtonStyle.RobloxRoundDefaultButton

-- اللوحة الرئيسية
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 220, 0, 300) -- حجم أصغر وأنسب
Main.Position = UDim2.new(0.5, -110, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Visible = false

-- عنوان ثابت وزر إغلاق
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(0, 120, 215)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Text = "GlowHub V7"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

-- قائمة التمرير (Scrolling) لكي لا تخرج الأزرار عن الشاشة
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, 0, 1, -35)
Scroll.Position = UDim2.new(0, 0, 0, 35)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 550) -- مساحة الأوامر بالداخل
Scroll.ScrollBarThickness = 5

OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true OpenBtn.Visible = false end)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false OpenBtn.Visible = true end)

local function createRow(name, yPos, type)
    local frame = Instance.new("Frame", Scroll)
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Text = name
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    
    if type == "Value" then
        local m = Instance.new("TextButton", frame)
        m.Size = UDim2.new(0, 30, 0, 30)
        m.Position = UDim2.new(0.45, 0, 0.1, 0)
        m.Text = "-"
        local input = Instance.new("TextBox", frame)
        input.Size = UDim2.new(0, 50, 0, 30)
        input.Position = UDim2.new(0.6, 0, 0.1, 0)
        input.Text = "16"
        local p = Instance.new("TextButton", frame)
        p.Size = UDim2.new(0, 30, 0, 30)
        p.Position = UDim2.new(0.85, 0, 0.1, 0)
        p.Text = "+"
        return m, input, p
    elseif type == "Toggle" then
        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(0, 30, 0, 30)
        btn.Position = UDim2.new(0.85, 0, 0.1, 0)
        btn.Text = ""
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        return btn
    end
end

-- الأوامر بالترتيب داخل الـ Scroll
local sM, sIn, sP = createRow("السرعة", 10, "Value")
RunService.RenderStepped:Connect(function() if Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.WalkSpeed = tonumber(sIn.Text) or 16 end end)

local jM, jIn, jP = createRow("القفز", 50, "Value")
jIn.Text = "50"
RunService.RenderStepped:Connect(function() if Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.UseJumpPower = true Player.Character.Humanoid.JumpPower = tonumber(jIn.Text) or 50 end end)

local infJ = createRow("قفز لا نهائي", 90, "Toggle")
local infJumpActive = false
infJ.MouseButton1Click:Connect(function() infJumpActive = not infJumpActive infJ.Text = infJumpActive and "✓" or "" end)
UserInputService.JumpRequest:Connect(function() if infJumpActive then Player.Character.Humanoid:ChangeState("Jumping") end end)

local ncB = createRow("اختراق", 130, "Toggle")
local ncActive = false
ncB.MouseButton1Click:Connect(function() ncActive = not ncActive ncB.Text = ncActive and "✓" or "" end)
RunService.Stepped:Connect(function() if ncActive and Player.Character then for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)

local fbB = createRow("إضاءة FB", 170, "Toggle")
local fbActive = false
fbB.MouseButton1Click:Connect(function() 
    fbActive = not fbActive 
    fbB.Text = fbActive and "✓" or ""
    if not fbActive then Lighting.Brightness = 2 Lighting.ClockTime = 14 end
end)
RunService.RenderStepped:Connect(function() if fbActive then Lighting.Brightness = 2 Lighting.ClockTime = 14 Lighting.GlobalShadows = false end end)

local flyB = createRow("طيران", 210, "Toggle")
flyB.MouseButton1Click:Connect(function() flyB.Text = "✓" loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.lua"))() end)

local flB = createRow("قذف Fling", 250, "Toggle")
flB.MouseButton1Click:Connect(function() flB.Text = "✓" loadstring(game:HttpGet("https://raw.githubusercontent.com/0866/Fling/main/Fling.lua"))() end)

local espB = createRow("إظهار ESP", 290, "Toggle")
espB.MouseButton1Click:Connect(function() espB.Text = "✓" loadstring(game:HttpGet("https://raw.githubusercontent.com/ic3w0lf22/UnnamedESP/master/Source.lua"))() end)

-- ميزة قدرات الفريقين (Team Switch)
local teamB = createRow("قدرات الفريقين", 330, "Toggle")
teamB.MouseButton1Click:Connect(function()
    teamB.Text = "✓"
    for _, t in pairs(game:GetService("Teams"):GetTeams()) do
        Player.Team = t -- يحاول التبديل بين الفرق للحصول على الأدوات
        task.wait(0.1)
    end
end)

-- زر انتقال (أسفل القائمة)
local tpL = Instance.new("TextLabel", Scroll)
tpL.Text = "انتقال:"; tpL.Size = UDim2.new(0, 50, 0, 30); tpL.Position = UDim2.new(0.05, 0, 0, 370); tpL.TextColor3 = Color3.new(1,1,1); tpL.BackgroundTransparency = 1
local tpIn = Instance.new("TextBox", Scroll)
tpIn.Size = UDim2.new(0, 100, 0, 30); tpIn.Position = UDim2.new(0.3, 0, 0, 370); tpIn.PlaceholderText = "الاسم"; tpIn.BackgroundColor3 = Color3.fromRGB(40,40,40); tpIn.TextColor3 = Color3.new(1,1,1)
local tpBtn = Instance.new("TextButton", Scroll)
tpBtn.Size = UDim2.new(0, 40, 0, 30); tpBtn.Position = UDim2.new(0.8, 0, 0, 370); tpBtn.Text = "Go"
tpBtn.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= Player and (tpIn.Text == "" or p.Name:lower():find(tpIn.Text:lower())) then
            Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,3,0)
            break
        end
    end
end)
