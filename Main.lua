-- [[ السكربت: الخارق جلو هوب 1.1v ]] --
-- [[ إعداد: خبير البرمجة ]] --

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- 1. إنشاء الواجهة الرسومية (GUI)
local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "GlowHub_1.1v"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 240, 0, 350)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 150) -- لون أخضر "جلو"
MainFrame.Active = true
MainFrame.Draggable = true

-- زر إغلاق/إظهار القائمة (اضغط حرف "L" للتبديل)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.L then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "الخارق جلو هوب 1.1v"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, 0, 1, -45)
Scroll.Position = UDim2.new(0, 0, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 1.5, 0)
Scroll.ScrollBarThickness = 5

local Layout = Instance.new("UIListLayout", Scroll)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Padding = UDim.new(0, 8)

-- وظيفة إنشاء الأزرار
local function createButton(name, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Text = name
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.MouseButton1Click:Connect(callback)
    
    -- تأثير عند الضغط
    btn.MouseButton1Down:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(0, 255, 150) end)
    btn.MouseButton1Up:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45) end)
end

--- مهارات السكربت ---

-- السرعة
createButton("زيادة السرعة (Speed+)", function()
    Player.Character.Humanoid.WalkSpeed = 100
end)

-- القفز
createButton("قوة القفز (Jump+)", function()
    Player.Character.Humanoid.JumpPower = 120
end)

-- قفز لانهائي
local infJump = false
createButton("تبديل قفز لانهائي", function()
    infJump = not infJump
end)
UserInputService.JumpRequest:Connect(function()
    if infJump then Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- اختراق الجدران (Noclip)
local noclip = false
createButton("تبديل اختراق الجدران", function()
    noclip = not noclip
end)
RunService.Stepped:Connect(function()
    if noclip and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- كشف الأماكن (ESP)
createButton("كشف اللاعبين (ESP)", function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= Player and p.Character then
            local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
            h.FillColor = Color3.new(1, 0, 0)
        end
    end
end)

-- قذف اللاعبين (WalkFling)
local fling = false
createButton("تفعيل القذف (Fling)", function()
    fling = not fling
    local hrp = Player.Character.HumanoidRootPart
    while fling do
        hrp.Velocity = Vector3.new(0, 10000, 0) -- تزييف الفيزياء للقذف
        task.wait(0.1)
    end
end)

-- العودة للموت (Auto Back)
local lastPos = nil
Player.CharacterAdded:Connect(function(char)
    if lastPos then
        task.wait(4)
        char:MoveTo(lastPos.Position)
        lastPos = nil
    end
    char:WaitForChild("Humanoid").Died:Connect(function()
        lastPos = char.HumanoidRootPart.CFrame
    end)
end)

print("تم تشغيل الخارق جلو هوب 1.1v بنجاح!")
