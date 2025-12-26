-- [[ السكربت الكامل: GlowBox Super Fixed & Enhanced ]] --

local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- 1. تنظيف النسخ القديمة
if PlayerGui:FindFirstChild("GlowBoxSuper") then PlayerGui.GlowBoxSuper:Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "GlowBoxSuper"
ScreenGui.ResetOnSpawn = false

-- 2. زر فتح القائمة (G)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.4, 0)
OpenBtn.Text = "G"
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 25
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

-- 3. اللوحة الرئيسية (Main Frame)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 400) 
Main.Position = UDim2.new(0.5, -140, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Visible = false
Instance.new("UICorner", Main)

-- جعل النافذة قابلة للسحب
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = Main.Position
    end
end)
Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Title.Text = "GlowBox Super - النسخة الكاملة"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Instance.new("UICorner", Title)

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"; CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); CloseBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", CloseBtn)

OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)

-- 4. دالة إنشاء الأزرار والصفوف
local function createRow(name, yPos, type)
    local label = Instance.new("TextLabel", Main)
    label.Size = UDim2.new(0, 140, 0, 30); label.Position = UDim2.new(0.05, 0, 0, yPos)
    label.Text = name; label.TextColor3 = Color3.new(1,1,1); label.BackgroundTransparency = 1; label.TextXAlignment = Enum.TextXAlignment.Left; label.Font = Enum.Font.Gotham
    
    if type == "Value" then
        local minus = Instance.new("TextButton", Main)
        minus.Size = UDim2.new(0, 25, 0, 25); minus.Position = UDim2.new(0.55, 0, 0, yPos); minus.Text = "-"
        local input = Instance.new("TextBox", Main)
        input.Size = UDim2.new(0, 40, 0, 25); input.Position = UDim2.new(0.68, 0, 0, yPos); input.Text = "16"
        local plus = Instance.new("TextButton", Main)
        plus.Size = UDim2.new(0, 25, 0, 25); plus.Position = UDim2.new(0.88, 0, 0, yPos); plus.Text = "+"
        minus.MouseButton1Click:Connect(function() input.Text = tostring((tonumber(input.Text) or 0) - 5) end)
        plus.MouseButton1Click:Connect(function() input.Text = tostring((tonumber(input.Text) or 0) + 5) end)
        return minus, input, plus
    elseif type == "Toggle" then
        local btn = Instance.new("TextButton", Main)
        btn.Size = UDim2.new(0, 45, 0, 25); btn.Position = UDim2.new(0.78, 0, 0, yPos); btn.Text = "OFF"
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60); btn.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", btn)
        return btn
    end
end

-- 5. تعريف الأوامر
local _, sIn, _ = createRow("السرعة", 50, "Value")
local _, jIn, _ = createRow("القفز", 90, "Value")
local infJ = createRow("قفز لا نهائي", 130, "Toggle")
local ncB = createRow("اختراق الجدران", 170, "Toggle")
local gBtn = createRow("رؤية G (نوب)", 210, "Toggle")
local rBtn = createRow("رؤية R (خطوط)", 250, "Toggle")

-- 6. منطق العمل (Backend)
local infJumpActive, ncActive, noobModeActive, highlightActive = false, false, false, false

-- وظائف التبديل (Toggles)
infJ.MouseButton1Click:Connect(function() 
    infJumpActive = not infJumpActive
    infJ.Text = infJumpActive and "ON" or "OFF"
    infJ.BackgroundColor3 = infJumpActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
end)

ncB.MouseButton1Click:Connect(function() 
    ncActive = not ncActive
    ncB.Text = ncActive and "ON" or "OFF"
    ncB.BackgroundColor3 = ncActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
end)

gBtn.MouseButton1Click:Connect(function()
    noobModeActive = not noobModeActive
    gBtn.Text = noobModeActive and "ON" or "OFF"
    gBtn.BackgroundColor3 = noobModeActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
end)

rBtn.MouseButton1Click:Connect(function()
    highlightActive = not highlightActive
    rBtn.Text = highlightActive and "ON" or "OFF"
    rBtn.BackgroundColor3 = highlightActive and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(60, 60, 60)
end)

-- 7. حلقة التحديث المستمر (Main Loop)
RunService.Stepped:Connect(function()
    if Player.Character then
        -- السرعة والقفز
        local hum = Player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = tonumber(sIn.Text) or 16
            hum.JumpPower = tonumber(jIn.Text) or 50
        end
        -- الاختراق
        if ncActive then
            for _, v in pairs(Player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
        -- تحديث اللاعبين الآخرين (رؤية G و R)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= Player and p.Character then
                -- نظام النوب (G)
                if noobModeActive then
                    for _, part in pairs(p.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.Transparency = 0
                            if part.Name == "Head" then part.Color = Color3.new(1, 1, 0)
                            elseif part.Name == "Torso" then part.Color = Color3.new(0, 0, 1)
                            elseif part.Name:find("Leg") or part.Name:find("Arm") then part.Color = Color3.new(0, 1, 0) end
                        elseif part:IsA("Accessory") or part:IsA("Shirt") or part:IsA("Pants") then
                            part.Parent = nil -- إخفاء الملابس مؤقتاً
                        end
                    end
                end
                -- نظام الخطوط (R)
                local existingHl = p.Character:FindFirstChild("GlowHighlight")
                if highlightActive then
                    if not existingHl then
                        local hl = Instance.new("Highlight", p.Character)
                        hl.Name = "GlowHighlight"
                        hl.OutlineColor = Color3.new(1, 0, 0)
                        hl.FillTransparency = 1
                    end
                else
                    if existingHl then existingHl:Destroy() end
                end
            end
        end
    end
end)

-- قفز لا نهائي
UserInputService.JumpRequest:Connect(function()
    if infJumpActive and Player.Character then
        local hum = Player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

print("GlowBox Super: All systems online!")
